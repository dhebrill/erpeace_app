-- =====================================================================
-- ERPeace · 004_rls.sql
-- Row Level Security for every table.
-- Run this file LAST in the Supabase SQL Editor.
--
-- Roles
--   admin     : full access
--   manager   : read everything, approve PO / SO
--   warehouse : products, stock and opname read-write, receive PO
--   sales     : customers and sales orders
--   purchasing: suppliers and purchase orders
--
-- Inactive users (is_active = false) can only read their own profile row.
-- =====================================================================

alter table public.profiles           enable row level security;
alter table public.categories         enable row level security;
alter table public.products           enable row level security;
alter table public.stock_movements     enable row level security;
alter table public.stock_opnames       enable row level security;
alter table public.stock_opname_items  enable row level security;
alter table public.suppliers           enable row level security;
alter table public.customers           enable row level security;
alter table public.purchase_orders     enable row level security;
alter table public.purchase_order_items enable row level security;
alter table public.sales_orders        enable row level security;
alter table public.sales_order_items   enable row level security;
alter table public.document_counters    enable row level security;

-- ---------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select to authenticated
  using (
    id = auth.uid()
    or public.current_user_role() in ('admin', 'manager')
  );

drop policy if exists profiles_insert_admin on public.profiles;
create policy profiles_insert_admin on public.profiles
  for insert to authenticated
  with check (public.current_user_role() = 'admin');

drop policy if exists profiles_update_admin on public.profiles;
create policy profiles_update_admin on public.profiles
  for update to authenticated
  using (public.current_user_role() = 'admin')
  with check (public.current_user_role() = 'admin');

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid() and public.current_user_is_active())
  with check (id = auth.uid());

drop policy if exists profiles_delete_admin on public.profiles;
create policy profiles_delete_admin on public.profiles
  for delete to authenticated
  using (public.current_user_role() = 'admin');

-- ---------------------------------------------------------------------
-- categories
-- ---------------------------------------------------------------------
drop policy if exists categories_select on public.categories;
create policy categories_select on public.categories
  for select to authenticated
  using (public.current_user_is_active());

drop policy if exists categories_insert on public.categories;
create policy categories_insert on public.categories
  for insert to authenticated
  with check (public.current_user_role() in ('admin', 'manager', 'warehouse'));

drop policy if exists categories_update on public.categories;
create policy categories_update on public.categories
  for update to authenticated
  using (public.current_user_role() in ('admin', 'manager', 'warehouse'))
  with check (public.current_user_role() in ('admin', 'manager', 'warehouse'));

drop policy if exists categories_delete on public.categories;
create policy categories_delete on public.categories
  for delete to authenticated
  using (public.current_user_role() in ('admin', 'manager'));

-- ---------------------------------------------------------------------
-- products
-- ---------------------------------------------------------------------
drop policy if exists products_select on public.products;
create policy products_select on public.products
  for select to authenticated
  using (public.current_user_is_active());

drop policy if exists products_insert on public.products;
create policy products_insert on public.products
  for insert to authenticated
  with check (public.current_user_role() in ('admin', 'manager', 'warehouse'));

drop policy if exists products_update on public.products;
create policy products_update on public.products
  for update to authenticated
  using (public.current_user_role() in ('admin', 'manager', 'warehouse'))
  with check (public.current_user_role() in ('admin', 'manager', 'warehouse'));

drop policy if exists products_delete on public.products;
create policy products_delete on public.products
  for delete to authenticated
  using (public.current_user_role() in ('admin', 'manager'));

-- ---------------------------------------------------------------------
-- stock_movements · written by the RPCs only
-- ---------------------------------------------------------------------
drop policy if exists stock_movements_select on public.stock_movements;
create policy stock_movements_select on public.stock_movements
  for select to authenticated
  using (public.current_user_is_active());

drop policy if exists stock_movements_delete on public.stock_movements;
create policy stock_movements_delete on public.stock_movements
  for delete to authenticated
  using (public.current_user_role() = 'admin');

-- ---------------------------------------------------------------------
-- stock_opnames
-- ---------------------------------------------------------------------
drop policy if exists stock_opnames_select on public.stock_opnames;
create policy stock_opnames_select on public.stock_opnames
  for select to authenticated
  using (public.current_user_is_active());

drop policy if exists stock_opnames_insert on public.stock_opnames;
create policy stock_opnames_insert on public.stock_opnames
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'manager', 'warehouse')
    and status = 'draft'
  );

drop policy if exists stock_opnames_update on public.stock_opnames;
create policy stock_opnames_update on public.stock_opnames
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'warehouse')
    and status = 'draft'
  )
  with check (
    public.current_user_role() in ('admin', 'manager', 'warehouse')
    and status = 'draft'
  );

drop policy if exists stock_opnames_delete on public.stock_opnames;
create policy stock_opnames_delete on public.stock_opnames
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'manager')
    and status = 'draft'
  );

-- ---------------------------------------------------------------------
-- stock_opname_items
-- ---------------------------------------------------------------------
drop policy if exists stock_opname_items_select on public.stock_opname_items;
create policy stock_opname_items_select on public.stock_opname_items
  for select to authenticated
  using (public.current_user_is_active());

drop policy if exists stock_opname_items_insert on public.stock_opname_items;
create policy stock_opname_items_insert on public.stock_opname_items
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'manager', 'warehouse')
    and exists (
      select 1 from public.stock_opnames o
      where o.id = public.stock_opname_items.opname_id
        and o.status = 'draft'
    )
  );

drop policy if exists stock_opname_items_update on public.stock_opname_items;
create policy stock_opname_items_update on public.stock_opname_items
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'warehouse')
    and exists (
      select 1 from public.stock_opnames o
      where o.id = public.stock_opname_items.opname_id
        and o.status = 'draft'
    )
  )
  with check (
    public.current_user_role() in ('admin', 'manager', 'warehouse')
    and exists (
      select 1 from public.stock_opnames o
      where o.id = public.stock_opname_items.opname_id
        and o.status = 'draft'
    )
  );

drop policy if exists stock_opname_items_delete on public.stock_opname_items;
create policy stock_opname_items_delete on public.stock_opname_items
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'manager')
    and exists (
      select 1 from public.stock_opnames o
      where o.id = public.stock_opname_items.opname_id
        and o.status = 'draft'
    )
  );

-- ---------------------------------------------------------------------
-- suppliers
-- ---------------------------------------------------------------------
drop policy if exists suppliers_select on public.suppliers;
create policy suppliers_select on public.suppliers
  for select to authenticated
  using (public.current_user_is_active());

drop policy if exists suppliers_insert on public.suppliers;
create policy suppliers_insert on public.suppliers
  for insert to authenticated
  with check (public.current_user_role() in ('admin', 'manager', 'purchasing'));

drop policy if exists suppliers_update on public.suppliers;
create policy suppliers_update on public.suppliers
  for update to authenticated
  using (public.current_user_role() in ('admin', 'manager', 'purchasing'))
  with check (public.current_user_role() in ('admin', 'manager', 'purchasing'));

drop policy if exists suppliers_delete on public.suppliers;
create policy suppliers_delete on public.suppliers
  for delete to authenticated
  using (public.current_user_role() in ('admin', 'manager'));

-- ---------------------------------------------------------------------
-- customers
-- ---------------------------------------------------------------------
drop policy if exists customers_select on public.customers;
create policy customers_select on public.customers
  for select to authenticated
  using (public.current_user_is_active());

drop policy if exists customers_insert on public.customers;
create policy customers_insert on public.customers
  for insert to authenticated
  with check (public.current_user_role() in ('admin', 'manager', 'sales'));

drop policy if exists customers_update on public.customers;
create policy customers_update on public.customers
  for update to authenticated
  using (public.current_user_role() in ('admin', 'manager', 'sales'))
  with check (public.current_user_role() in ('admin', 'manager', 'sales'));

drop policy if exists customers_delete on public.customers;
create policy customers_delete on public.customers
  for delete to authenticated
  using (public.current_user_role() in ('admin', 'manager'));

-- ---------------------------------------------------------------------
-- purchase_orders
-- ---------------------------------------------------------------------
drop policy if exists purchase_orders_select on public.purchase_orders;
create policy purchase_orders_select on public.purchase_orders
  for select to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'purchasing', 'warehouse')
  );

drop policy if exists purchase_orders_insert on public.purchase_orders;
create policy purchase_orders_insert on public.purchase_orders
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'manager', 'purchasing')
    and status = 'draft'
  );

drop policy if exists purchase_orders_update on public.purchase_orders;
create policy purchase_orders_update on public.purchase_orders
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'purchasing')
    and status = 'draft'
  )
  with check (
    public.current_user_role() in ('admin', 'manager', 'purchasing')
    and status = 'draft'
  );

drop policy if exists purchase_orders_delete on public.purchase_orders;
create policy purchase_orders_delete on public.purchase_orders
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'manager')
    and status = 'draft'
  );

-- ---------------------------------------------------------------------
-- purchase_order_items
-- ---------------------------------------------------------------------
drop policy if exists purchase_order_items_select on public.purchase_order_items;
create policy purchase_order_items_select on public.purchase_order_items
  for select to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'purchasing', 'warehouse')
  );

drop policy if exists purchase_order_items_insert on public.purchase_order_items;
create policy purchase_order_items_insert on public.purchase_order_items
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'manager', 'purchasing')
    and exists (
      select 1 from public.purchase_orders o
      where o.id = public.purchase_order_items.purchase_order_id
        and o.status = 'draft'
    )
  );

drop policy if exists purchase_order_items_update on public.purchase_order_items;
create policy purchase_order_items_update on public.purchase_order_items
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'purchasing')
    and exists (
      select 1 from public.purchase_orders o
      where o.id = public.purchase_order_items.purchase_order_id
        and o.status = 'draft'
    )
  )
  with check (
    public.current_user_role() in ('admin', 'manager', 'purchasing')
    and exists (
      select 1 from public.purchase_orders o
      where o.id = public.purchase_order_items.purchase_order_id
        and o.status = 'draft'
    )
  );

drop policy if exists purchase_order_items_delete on public.purchase_order_items;
create policy purchase_order_items_delete on public.purchase_order_items
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'purchasing')
    and exists (
      select 1 from public.purchase_orders o
      where o.id = public.purchase_order_items.purchase_order_id
        and o.status = 'draft'
    )
  );

-- ---------------------------------------------------------------------
-- sales_orders
-- ---------------------------------------------------------------------
drop policy if exists sales_orders_select on public.sales_orders;
create policy sales_orders_select on public.sales_orders
  for select to authenticated
  using (public.current_user_role() in ('admin', 'manager', 'sales'));

drop policy if exists sales_orders_insert on public.sales_orders;
create policy sales_orders_insert on public.sales_orders
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'manager', 'sales')
    and status = 'draft'
  );

drop policy if exists sales_orders_update on public.sales_orders;
create policy sales_orders_update on public.sales_orders
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'sales')
    and status = 'draft'
  )
  with check (
    public.current_user_role() in ('admin', 'manager', 'sales')
    and status = 'draft'
  );

drop policy if exists sales_orders_delete on public.sales_orders;
create policy sales_orders_delete on public.sales_orders
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'manager')
    and status = 'draft'
  );

-- ---------------------------------------------------------------------
-- sales_order_items
-- ---------------------------------------------------------------------
drop policy if exists sales_order_items_select on public.sales_order_items;
create policy sales_order_items_select on public.sales_order_items
  for select to authenticated
  using (public.current_user_role() in ('admin', 'manager', 'sales'));

drop policy if exists sales_order_items_insert on public.sales_order_items;
create policy sales_order_items_insert on public.sales_order_items
  for insert to authenticated
  with check (
    public.current_user_role() in ('admin', 'manager', 'sales')
    and exists (
      select 1 from public.sales_orders o
      where o.id = public.sales_order_items.sales_order_id
        and o.status = 'draft'
    )
  );

drop policy if exists sales_order_items_update on public.sales_order_items;
create policy sales_order_items_update on public.sales_order_items
  for update to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'sales')
    and exists (
      select 1 from public.sales_orders o
      where o.id = public.sales_order_items.sales_order_id
        and o.status = 'draft'
    )
  )
  with check (
    public.current_user_role() in ('admin', 'manager', 'sales')
    and exists (
      select 1 from public.sales_orders o
      where o.id = public.sales_order_items.sales_order_id
        and o.status = 'draft'
    )
  );

drop policy if exists sales_order_items_delete on public.sales_order_items;
create policy sales_order_items_delete on public.sales_order_items
  for delete to authenticated
  using (
    public.current_user_role() in ('admin', 'manager', 'sales')
    and exists (
      select 1 from public.sales_orders o
      where o.id = public.sales_order_items.sales_order_id
        and o.status = 'draft'
    )
  );

-- ---------------------------------------------------------------------
-- document_counters · only the numbering function may touch it
-- ---------------------------------------------------------------------
drop policy if exists document_counters_all on public.document_counters;
create policy document_counters_all on public.document_counters
  for all to authenticated
  using (false)
  with check (false);

-- =====================================================================
-- Table permissions
-- =====================================================================
-- Every list screen and the dashboard read through PostgREST, so the
-- authenticated role needs SELECT on every table. Which rows are visible
-- is still decided by the RLS policies above.
grant select on all tables in schema public to authenticated;

-- Write access is granted on the tables the app edits; the RLS policies
-- decide which role may write which row.
grant insert, update, delete on
  public.categories,
  public.customers,
  public.products,
  public.profiles,
  public.purchase_order_items,
  public.purchase_orders,
  public.sales_order_items,
  public.sales_orders,
  public.stock_movements,
  public.stock_opname_items,
  public.stock_opnames,
  public.suppliers
to authenticated;

-- Anonymous visitors never touch business data.
revoke all on all tables in schema public from anon;

-- =====================================================================
-- Function permissions
-- =====================================================================
-- Revoke the default PUBLIC grant first, then hand the permissions out
-- explicitly: the business RPCs to signed in users, the role helpers to
-- authenticated (they are used inside the RLS policies) and nothing at
-- all to anonymous visitors.
revoke execute on function public.create_purchase_order(uuid, text, jsonb) from public;
revoke execute on function public.approve_purchase_order(uuid) from public;
revoke execute on function public.cancel_purchase_order(uuid) from public;
revoke execute on function public.receive_purchase_order(uuid) from public;
revoke execute on function public.create_sales_order(uuid, text, jsonb) from public;
revoke execute on function public.approve_sales_order(uuid) from public;
revoke execute on function public.cancel_sales_order(uuid) from public;
revoke execute on function public.complete_sales_order(uuid) from public;
revoke execute on function public.create_stock_opname(text, uuid[]) from public;
revoke execute on function public.set_stock_opname_item_count(uuid, numeric) from public;
revoke execute on function public.finalize_stock_opname(uuid) from public;
revoke execute on function public.cancel_stock_opname(uuid) from public;

grant execute on function public.create_purchase_order(uuid, text, jsonb) to authenticated;
grant execute on function public.approve_purchase_order(uuid) to authenticated;
grant execute on function public.cancel_purchase_order(uuid) to authenticated;
grant execute on function public.receive_purchase_order(uuid) to authenticated;
grant execute on function public.create_sales_order(uuid, text, jsonb) to authenticated;
grant execute on function public.approve_sales_order(uuid) to authenticated;
grant execute on function public.cancel_sales_order(uuid) to authenticated;
grant execute on function public.complete_sales_order(uuid) to authenticated;
grant execute on function public.create_stock_opname(text, uuid[]) to authenticated;
grant execute on function public.set_stock_opname_item_count(uuid, numeric) to authenticated;
grant execute on function public.finalize_stock_opname(uuid) to authenticated;
grant execute on function public.cancel_stock_opname(uuid) to authenticated;

-- Used inside the RLS policies, so authenticated needs EXECUTE.
grant execute on function public.current_user_role() to authenticated;
grant execute on function public.current_user_is_active() to authenticated;
grant execute on function public.has_any_role(public.app_role[]) to authenticated;

-- Internal helpers are never exposed to the client.
-- next_document_number is only ever called by the SECURITY DEFINER RPCs
-- above, which run with the privileges of the owner.
revoke execute on function public.next_document_number(text) from public;

-- Trigger functions keep their grant for authenticated (PostgreSQL checks
-- EXECUTE when the trigger is created, not when it fires) but anonymous
-- visitors must not be able to call them.
revoke execute on function public.set_updated_at() from anon;
revoke execute on function public.handle_new_user() from anon;
revoke execute on function public.prevent_self_role_change() from anon;
