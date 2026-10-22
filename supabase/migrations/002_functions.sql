-- =====================================================================
-- ERPeace · 002_functions.sql
-- Helper functions, document numbering and the atomic business RPCs.
-- Run this file SECOND in the Supabase SQL Editor.
-- Every function is SECURITY DEFINER but still re-checks the caller role.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Role helpers
-- ---------------------------------------------------------------------
create or replace function public.current_user_role()
returns public.app_role
language sql
stable
security definer
set search_path = public
as $$
  select p.role
  from public.profiles p
  where p.id = auth.uid()
    and p.is_active = true;
$$;

create or replace function public.current_user_is_active()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select p.is_active from public.profiles p where p.id = auth.uid()),
    false
  );
$$;

create or replace function public.has_any_role(p_roles public.app_role[])
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.current_user_role() = any (p_roles), false);
$$;

-- ---------------------------------------------------------------------
-- Document numbering · PO-2026-0001 / SO-2026-0001 / OPN-2026-0001
-- The counter row is locked by the upsert, so the function is atomic.
-- ---------------------------------------------------------------------
create or replace function public.next_document_number(p_prefix text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_period text := to_char((now() at time zone 'Asia/Jakarta'), 'YYYY');
  v_value  integer;
begin
  insert into public.document_counters as counter (prefix, period, last_value)
  values (upper(p_prefix), v_period, 1)
  on conflict (prefix, period)
  do update set last_value = counter.last_value + 1
  returning counter.last_value into v_value;

  return upper(p_prefix) || '-' || v_period || '-' || lpad(v_value::text, 4, '0');
end;
$$;

-- ---------------------------------------------------------------------
-- Purchase orders
-- ---------------------------------------------------------------------
create or replace function public.create_purchase_order(
  p_supplier_id uuid,
  p_note        text   default null,
  p_items       jsonb  default '[]'::jsonb
)
returns public.purchase_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role    public.app_role;
  v_po      public.purchase_orders;
  v_item    jsonb;
  v_product uuid;
  v_qty     numeric;
  v_price   numeric;
  v_total   numeric := 0;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'purchasing') then
    raise exception 'Hanya admin, manager, atau pembelian yang dapat membuat purchase order.'
      using errcode = '42501';
  end if;
  if p_supplier_id is null then
    raise exception 'Supplier wajib dipilih.' using errcode = 'P0001';
  end if;
  if jsonb_array_length(coalesce(p_items, '[]'::jsonb)) = 0 then
    raise exception 'Purchase order harus memiliki minimal satu item.' using errcode = 'P0001';
  end if;

  insert into public.purchase_orders (
    po_number, supplier_id, status, total, note, created_by
  )
  values (
    public.next_document_number('PO'), p_supplier_id, 'draft', 0, p_note, auth.uid()
  )
  returning * into v_po;

  for v_item in select * from jsonb_array_elements(coalesce(p_items, '[]'::jsonb))
  loop
    v_product := nullif(v_item ->> 'product_id', '')::uuid;
    v_qty     := coalesce((v_item ->> 'qty')::numeric, 0);
    v_price   := coalesce((v_item ->> 'price')::numeric, 0);

    if v_product is null then
      raise exception 'Item purchase order tidak valid.' using errcode = 'P0001';
    end if;
    if v_qty <= 0 then
      raise exception 'Jumlah item purchase order harus lebih dari 0.' using errcode = 'P0001';
    end if;

    insert into public.purchase_order_items (
      purchase_order_id, product_id, qty, price, subtotal
    )
    values (
      v_po.id, v_product, v_qty, v_price, round(v_qty * v_price, 2)
    );

    v_total := v_total + round(v_qty * v_price, 2);
  end loop;

  update public.purchase_orders
     set total = v_total, updated_at = now()
   where id = v_po.id
  returning * into v_po;

  return v_po;
end;
$$;

create or replace function public.approve_purchase_order(p_po_id uuid)
returns public.purchase_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role public.app_role;
  v_po   public.purchase_orders;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager') then
    raise exception 'Hanya admin atau manager yang dapat menyetujui purchase order.'
      using errcode = '42501';
  end if;

  select * into v_po from public.purchase_orders where id = p_po_id for update;
  if not found then
    raise exception 'Purchase order tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_po.status <> 'draft' then
    raise exception 'Purchase order harus berstatus draft untuk disetujui.' using errcode = 'P0001';
  end if;

  update public.purchase_orders
     set status = 'approved',
         approved_by = auth.uid(),
         approved_at = now(),
         updated_at = now()
   where id = p_po_id
  returning * into v_po;

  return v_po;
end;
$$;

create or replace function public.cancel_purchase_order(p_po_id uuid)
returns public.purchase_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role public.app_role;
  v_po   public.purchase_orders;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'purchasing') then
    raise exception 'Anda tidak memiliki izin untuk membatalkan purchase order.'
      using errcode = '42501';
  end if;

  select * into v_po from public.purchase_orders where id = p_po_id for update;
  if not found then
    raise exception 'Purchase order tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_role not in ('admin', 'manager') and v_po.created_by is distinct from auth.uid() then
    raise exception 'Anda hanya dapat membatalkan purchase order milik Anda sendiri.'
      using errcode = '42501';
  end if;
  if v_po.status not in ('draft', 'approved') then
    raise exception 'Purchase order yang sudah diterima tidak dapat dibatalkan.'
      using errcode = 'P0001';
  end if;

  update public.purchase_orders
     set status = 'cancelled', updated_at = now()
   where id = p_po_id
  returning * into v_po;

  return v_po;
end;
$$;

-- Receives an approved purchase order: creates the stock movements and
-- increases the product stock in one atomic transaction.
create or replace function public.receive_purchase_order(p_po_id uuid)
returns public.purchase_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role public.app_role;
  v_po   public.purchase_orders;
  v_item record;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'warehouse') then
    raise exception 'Hanya admin, manager, atau gudang yang dapat menerima purchase order.'
      using errcode = '42501';
  end if;

  select * into v_po from public.purchase_orders where id = p_po_id for update;
  if not found then
    raise exception 'Purchase order tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_po.status <> 'approved' then
    raise exception 'Purchase order harus berstatus approved sebelum diterima.' using errcode = 'P0001';
  end if;

  for v_item in
    select poi.product_id, poi.qty
    from public.purchase_order_items poi
    where poi.purchase_order_id = p_po_id
  loop
    update public.products
       set stock = stock + v_item.qty,
           updated_at = now()
     where id = v_item.product_id;

    insert into public.stock_movements (
      product_id, type, quantity, reference_type, reference_id, note, created_by
    )
    values (
      v_item.product_id, 'in', v_item.qty, 'purchase_order', p_po_id,
      'Penerimaan ' || v_po.po_number, auth.uid()
    );
  end loop;

  update public.purchase_orders
     set status = 'received',
         received_at = now(),
         updated_at = now()
   where id = p_po_id
  returning * into v_po;

  return v_po;
end;
$$;

-- ---------------------------------------------------------------------
-- Sales orders
-- ---------------------------------------------------------------------
create or replace function public.create_sales_order(
  p_customer_id uuid,
  p_note       text  default null,
  p_items      jsonb default '[]'::jsonb
)
returns public.sales_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role     public.app_role;
  v_so       public.sales_orders;
  v_item     jsonb;
  v_product  uuid;
  v_qty      numeric;
  v_price    numeric;
  v_total    numeric := 0;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'sales') then
    raise exception 'Hanya admin, manager, atau penjualan yang dapat membuat sales order.'
      using errcode = '42501';
  end if;
  if p_customer_id is null then
    raise exception 'Pelanggan wajib dipilih.' using errcode = 'P0001';
  end if;
  if jsonb_array_length(coalesce(p_items, '[]'::jsonb)) = 0 then
    raise exception 'Sales order harus memiliki minimal satu item.' using errcode = 'P0001';
  end if;

  insert into public.sales_orders (
    so_number, customer_id, status, total, note, created_by
  )
  values (
    public.next_document_number('SO'), p_customer_id, 'draft', 0, p_note, auth.uid()
  )
  returning * into v_so;

  for v_item in select * from jsonb_array_elements(coalesce(p_items, '[]'::jsonb))
  loop
    v_product := nullif(v_item ->> 'product_id', '')::uuid;
    v_qty     := coalesce((v_item ->> 'qty')::numeric, 0);
    v_price   := coalesce((v_item ->> 'price')::numeric, 0);

    if v_product is null then
      raise exception 'Item sales order tidak valid.' using errcode = 'P0001';
    end if;
    if v_qty <= 0 then
      raise exception 'Jumlah item sales order harus lebih dari 0.' using errcode = 'P0001';
    end if;

    insert into public.sales_order_items (
      sales_order_id, product_id, qty, price, subtotal
    )
    values (
      v_so.id, v_product, v_qty, v_price, round(v_qty * v_price, 2)
    );

    v_total := v_total + round(v_qty * v_price, 2);
  end loop;

  update public.sales_orders
     set total = v_total, updated_at = now()
   where id = v_so.id
  returning * into v_so;

  return v_so;
end;
$$;

create or replace function public.approve_sales_order(p_so_id uuid)
returns public.sales_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role public.app_role;
  v_so   public.sales_orders;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager') then
    raise exception 'Hanya admin atau manager yang dapat menyetujui sales order.'
      using errcode = '42501';
  end if;

  select * into v_so from public.sales_orders where id = p_so_id for update;
  if not found then
    raise exception 'Sales order tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_so.status <> 'draft' then
    raise exception 'Sales order harus berstatus draft untuk disetujui.' using errcode = 'P0001';
  end if;

  update public.sales_orders
     set status = 'approved',
         approved_by = auth.uid(),
         approved_at = now(),
         updated_at = now()
   where id = p_so_id
  returning * into v_so;

  return v_so;
end;
$$;

create or replace function public.cancel_sales_order(p_so_id uuid)
returns public.sales_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role public.app_role;
  v_so   public.sales_orders;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'sales') then
    raise exception 'Anda tidak memiliki izin untuk membatalkan sales order.'
      using errcode = '42501';
  end if;

  select * into v_so from public.sales_orders where id = p_so_id for update;
  if not found then
    raise exception 'Sales order tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_role not in ('admin', 'manager') and v_so.created_by is distinct from auth.uid() then
    raise exception 'Anda hanya dapat membatalkan sales order milik Anda sendiri.'
      using errcode = '42501';
  end if;
  if v_so.status not in ('draft', 'approved') then
    raise exception 'Sales order yang sudah selesai tidak dapat dibatalkan.' using errcode = 'P0001';
  end if;

  update public.sales_orders
     set status = 'cancelled', updated_at = now()
   where id = p_so_id
  returning * into v_so;

  return v_so;
end;
$$;

-- Completes an approved sales order: validates the stock, creates the stock
-- movements and decreases the product stock atomically.
create or replace function public.complete_sales_order(p_so_id uuid)
returns public.sales_orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role  public.app_role;
  v_so    public.sales_orders;
  v_item  record;
  v_stock numeric;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'sales') then
    raise exception 'Hanya admin, manager, atau penjualan yang dapat menyelesaikan sales order.'
      using errcode = '42501';
  end if;

  select * into v_so from public.sales_orders where id = p_so_id for update;
  if not found then
    raise exception 'Sales order tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_so.status <> 'approved' then
    raise exception 'Sales order harus berstatus approved sebelum diselesaikan.' using errcode = 'P0001';
  end if;

  -- Validate the stock of every line before changing anything.
  for v_item in
    select soi.product_id, soi.qty, p.name as product_name
    from public.sales_order_items soi
    join public.products p on p.id = soi.product_id
    where soi.sales_order_id = p_so_id
  loop
    select stock into v_stock
      from public.products
     where id = v_item.product_id
     for update;

    if v_stock is null or v_stock < v_item.qty then
      raise exception 'Stok % tidak mencukupi. Tersedia %, dibutuhkan %.',
        v_item.product_name, coalesce(v_stock, 0), v_item.qty
        using errcode = 'P0001';
    end if;
  end loop;

  for v_item in
    select product_id, qty
    from public.sales_order_items
    where sales_order_id = p_so_id
  loop
    update public.products
       set stock = stock - v_item.qty,
           updated_at = now()
     where id = v_item.product_id;

    insert into public.stock_movements (
      product_id, type, quantity, reference_type, reference_id, note, created_by
    )
    values (
      v_item.product_id, 'out', v_item.qty, 'sales_order', p_so_id,
      'Penjualan ' || v_so.so_number, auth.uid()
    );
  end loop;

  update public.sales_orders
     set status = 'completed',
         completed_at = now(),
         updated_at = now()
   where id = p_so_id
  returning * into v_so;

  return v_so;
end;
$$;

-- ---------------------------------------------------------------------
-- Stock opname
-- ---------------------------------------------------------------------
create or replace function public.create_stock_opname(
  p_note        text    default null,
  p_product_ids uuid[]  default null
)
returns public.stock_opnames
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role   public.app_role;
  v_opname public.stock_opnames;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'warehouse') then
    raise exception 'Hanya admin, manager, atau gudang yang dapat membuat stock opname.'
      using errcode = '42501';
  end if;

  insert into public.stock_opnames (
    opname_number, status, note, created_by
  )
  values (
    public.next_document_number('OPN'), 'draft', p_note, auth.uid()
  )
  returning * into v_opname;

  insert into public.stock_opname_items (
    opname_id, product_id, system_qty, counted_qty, difference
  )
  select
    v_opname.id, p.id, p.stock, p.stock, 0
  from public.products p
  where p.is_active = true
    and (p_product_ids is null or p.id = any (p_product_ids));

  return v_opname;
end;
$$;

create or replace function public.set_stock_opname_item_count(
  p_item_id     uuid,
  p_counted_qty numeric
)
returns public.stock_opname_items
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role  public.app_role;
  v_item  public.stock_opname_items;
  v_status public.stock_opname_status;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'warehouse') then
    raise exception 'Hanya admin, manager, atau gudang yang dapat mengisi stock opname.'
      using errcode = '42501';
  end if;

  select * into v_item
    from public.stock_opname_items
   where id = p_item_id
   for update;
  if not found then
    raise exception 'Item stock opname tidak ditemukan.' using errcode = 'P0002';
  end if;

  select status into v_status
    from public.stock_opnames
   where id = v_item.opname_id;
  if v_status <> 'draft' then
    raise exception 'Stock opname sudah difinalisasi dan tidak dapat diubah.'
      using errcode = 'P0001';
  end if;

  update public.stock_opname_items
     set counted_qty = coalesce(p_counted_qty, 0),
         difference  = coalesce(p_counted_qty, 0) - system_qty,
         updated_at  = now()
   where id = p_item_id
  returning * into v_item;

  return v_item;
end;
$$;

create or replace function public.finalize_stock_opname(p_opname_id uuid)
returns public.stock_opnames
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role   public.app_role;
  v_opname public.stock_opnames;
  v_item   record;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'warehouse') then
    raise exception 'Hanya admin, manager, atau gudang yang dapat memfinalisasi stock opname.'
      using errcode = '42501';
  end if;

  select * into v_opname
    from public.stock_opnames
   where id = p_opname_id
   for update;
  if not found then
    raise exception 'Stock opname tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_opname.status <> 'draft' then
    raise exception 'Stock opname sudah diproses sebelumnya.' using errcode = 'P0001';
  end if;

  for v_item in
    select * from public.stock_opname_items where opname_id = p_opname_id
  loop
    update public.stock_opname_items
       set difference = v_item.counted_qty - v_item.system_qty,
           updated_at = now()
     where id = v_item.id;

    update public.products
       set stock = v_item.counted_qty,
           updated_at = now()
     where id = v_item.product_id;

    if v_item.counted_qty <> v_item.system_qty then
      insert into public.stock_movements (
        product_id, type, quantity, reference_type, reference_id, note, created_by
      )
      values (
        v_item.product_id, 'adjustment', v_item.counted_qty - v_item.system_qty,
        'stock_opname', p_opname_id,
        'Penyesuaian stok ' || v_opname.opname_number, auth.uid()
      );
    end if;
  end loop;

  update public.stock_opnames
     set status = 'finalized',
         finalized_at = now(),
         updated_at = now()
   where id = p_opname_id
  returning * into v_opname;

  return v_opname;
end;
$$;

create or replace function public.cancel_stock_opname(p_opname_id uuid)
returns public.stock_opnames
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role   public.app_role;
  v_opname public.stock_opnames;
begin
  if auth.uid() is null then
    raise exception 'Anda harus masuk terlebih dahulu.' using errcode = '42501';
  end if;

  v_role := public.current_user_role();
  if v_role is null then
    raise exception 'Akun Anda belum aktif. Hubungi admin.' using errcode = '42501';
  end if;
  if v_role not in ('admin', 'manager', 'warehouse') then
    raise exception 'Anda tidak memiliki izin untuk membatalkan stock opname.'
      using errcode = '42501';
  end if;

  select * into v_opname
    from public.stock_opnames
   where id = p_opname_id
   for update;
  if not found then
    raise exception 'Stock opname tidak ditemukan.' using errcode = 'P0002';
  end if;
  if v_opname.status <> 'draft' then
    raise exception 'Stock opname yang sudah difinalisasi tidak dapat dibatalkan.'
      using errcode = 'P0001';
  end if;

  update public.stock_opnames
     set status = 'cancelled', updated_at = now()
   where id = p_opname_id
  returning * into v_opname;

  return v_opname;
end;
$$;
