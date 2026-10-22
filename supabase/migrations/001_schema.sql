-- =====================================================================
-- ERPeace · 001_schema.sql
-- Tables, enums and indexes.
-- Run this file FIRST in the Supabase SQL Editor.
-- The script is idempotent: running it twice is safe.
-- =====================================================================

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------
do $$
begin
  create type public.app_role as enum (
    'admin', 'manager', 'warehouse', 'sales', 'purchasing'
  );
exception
  when duplicate_object then null;
end
$$;

do $$
begin
  create type public.stock_movement_type as enum (
    'in', 'out', 'adjustment', 'opname'
  );
exception
  when duplicate_object then null;
end
$$;

do $$
begin
  create type public.purchase_order_status as enum (
    'draft', 'approved', 'received', 'cancelled'
  );
exception
  when duplicate_object then null;
end
$$;

do $$
begin
  create type public.sales_order_status as enum (
    'draft', 'approved', 'completed', 'cancelled'
  );
exception
  when duplicate_object then null;
end
$$;

do $$
begin
  create type public.stock_opname_status as enum (
    'draft', 'finalized', 'cancelled'
  );
exception
  when duplicate_object then null;
end
$$;

-- ---------------------------------------------------------------------
-- profiles · one row per auth user, created automatically on signup
-- ---------------------------------------------------------------------
create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  full_name   text        not null default '',
  email       text,
  role        public.app_role not null default 'sales',
  is_active   boolean     not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists profiles_role_idx on public.profiles (role);
create index if not exists profiles_is_active_idx on public.profiles (is_active);

-- ---------------------------------------------------------------------
-- categories
-- ---------------------------------------------------------------------
create table if not exists public.categories (
  id          uuid primary key default gen_random_uuid(),
  name        text        not null unique,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- products
-- ---------------------------------------------------------------------
create table if not exists public.products (
  id           uuid primary key default gen_random_uuid(),
  sku          text          not null unique,
  name         text          not null,
  category_id  uuid          references public.categories (id) on delete set null,
  unit         text          not null default 'pcs',
  buy_price    numeric(14, 2) not null default 0,
  sell_price   numeric(14, 2) not null default 0,
  stock        numeric(14, 2) not null default 0,
  min_stock    numeric(14, 2) not null default 0,
  image_url    text,
  is_active    boolean       not null default true,
  created_at   timestamptz   not null default now(),
  updated_at   timestamptz   not null default now()
);

-- Generated columns used by the stock filters of the mobile application.
alter table public.products
  drop column if exists is_low_stock;
alter table public.products
  add column is_low_stock boolean
  generated always as (min_stock > 0 and stock <= min_stock) stored;

alter table public.products
  drop column if exists is_out_of_stock;
alter table public.products
  add column is_out_of_stock boolean
  generated always as (stock <= 0) stored;

create index if not exists products_category_idx on public.products (category_id);
create index if not exists products_name_idx on public.products (name);
create index if not exists products_is_active_idx on public.products (is_active);

-- ---------------------------------------------------------------------
-- stock_movements · journal of every stock change
-- ---------------------------------------------------------------------
create table if not exists public.stock_movements (
  id             uuid primary key default gen_random_uuid(),
  product_id     uuid                    not null references public.products (id) on delete cascade,
  type           public.stock_movement_type not null,
  quantity       numeric(14, 2)          not null,
  reference_type text,
  reference_id   uuid,
  note           text,
  created_by     uuid                    references public.profiles (id) on delete set null,
  created_at     timestamptz             not null default now(),
  updated_at     timestamptz             not null default now()
);

create index if not exists stock_movements_product_idx on public.stock_movements (product_id, created_at desc);
create index if not exists stock_movements_reference_idx on public.stock_movements (reference_type, reference_id);

-- ---------------------------------------------------------------------
-- stock_opnames · physical stock count sessions
-- ---------------------------------------------------------------------
create table if not exists public.stock_opnames (
  id             uuid primary key default gen_random_uuid(),
  opname_number  text                  not null unique,
  status         public.stock_opname_status not null default 'draft',
  note           text,
  created_by     uuid                  references public.profiles (id) on delete set null,
  finalized_at   timestamptz,
  created_at     timestamptz           not null default now(),
  updated_at     timestamptz           not null default now()
);

create table if not exists public.stock_opname_items (
  id          uuid primary key default gen_random_uuid(),
  opname_id   uuid          not null references public.stock_opnames (id) on delete cascade,
  product_id  uuid          not null references public.products (id) on delete cascade,
  system_qty  numeric(14, 2) not null default 0,
  counted_qty numeric(14, 2) not null default 0,
  difference  numeric(14, 2) not null default 0,
  created_at  timestamptz   not null default now(),
  updated_at  timestamptz   not null default now(),
  constraint stock_opname_items_unique unique (opname_id, product_id)
);

create index if not exists stock_opname_items_opname_idx on public.stock_opname_items (opname_id);

-- ---------------------------------------------------------------------
-- suppliers & customers
-- ---------------------------------------------------------------------
create table if not exists public.suppliers (
  id          uuid primary key default gen_random_uuid(),
  name        text        not null,
  phone       text,
  email       text,
  address     text,
  is_active   boolean     not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists suppliers_name_idx on public.suppliers (name);

create table if not exists public.customers (
  id          uuid primary key default gen_random_uuid(),
  name        text        not null,
  phone       text,
  email       text,
  address     text,
  is_active   boolean     not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists customers_name_idx on public.customers (name);

-- ---------------------------------------------------------------------
-- purchase orders
-- ---------------------------------------------------------------------
create table if not exists public.purchase_orders (
  id           uuid primary key default gen_random_uuid(),
  po_number    text                    not null unique,
  supplier_id  uuid                    not null references public.suppliers (id) on delete restrict,
  status       public.purchase_order_status not null default 'draft',
  total        numeric(14, 2)          not null default 0,
  note         text,
  created_by   uuid                    references public.profiles (id) on delete set null,
  approved_by  uuid                    references public.profiles (id) on delete set null,
  approved_at  timestamptz,
  received_at  timestamptz,
  created_at   timestamptz             not null default now(),
  updated_at   timestamptz             not null default now()
);

create index if not exists purchase_orders_status_idx on public.purchase_orders (status);
create index if not exists purchase_orders_supplier_idx on public.purchase_orders (supplier_id);

create table if not exists public.purchase_order_items (
  id                 uuid primary key default gen_random_uuid(),
  purchase_order_id  uuid          not null references public.purchase_orders (id) on delete cascade,
  product_id         uuid          not null references public.products (id) on delete restrict,
  qty                numeric(14, 2) not null default 0,
  price              numeric(14, 2) not null default 0,
  subtotal           numeric(14, 2) not null default 0,
  created_at         timestamptz   not null default now(),
  updated_at         timestamptz   not null default now()
);

create index if not exists purchase_order_items_order_idx on public.purchase_order_items (purchase_order_id);
create index if not exists purchase_order_items_product_idx on public.purchase_order_items (product_id);

-- ---------------------------------------------------------------------
-- sales orders
-- ---------------------------------------------------------------------
create table if not exists public.sales_orders (
  id           uuid primary key default gen_random_uuid(),
  so_number    text                    not null unique,
  customer_id  uuid                    not null references public.customers (id) on delete restrict,
  status       public.sales_order_status not null default 'draft',
  total        numeric(14, 2)          not null default 0,
  note         text,
  created_by   uuid                    references public.profiles (id) on delete set null,
  approved_by  uuid                    references public.profiles (id) on delete set null,
  approved_at  timestamptz,
  completed_at timestamptz,
  created_at   timestamptz             not null default now(),
  updated_at   timestamptz             not null default now()
);

create index if not exists sales_orders_status_idx on public.sales_orders (status);
create index if not exists sales_orders_customer_idx on public.sales_orders (customer_id);
create index if not exists sales_orders_completed_idx on public.sales_orders (completed_at desc);

create table if not exists public.sales_order_items (
  id              uuid primary key default gen_random_uuid(),
  sales_order_id  uuid          not null references public.sales_orders (id) on delete cascade,
  product_id      uuid          not null references public.products (id) on delete restrict,
  qty             numeric(14, 2) not null default 0,
  price           numeric(14, 2) not null default 0,
  subtotal        numeric(14, 2) not null default 0,
  created_at      timestamptz   not null default now(),
  updated_at      timestamptz   not null default now()
);

create index if not exists sales_order_items_order_idx on public.sales_order_items (sales_order_id);
create index if not exists sales_order_items_product_idx on public.sales_order_items (product_id);

-- ---------------------------------------------------------------------
-- document_counters · backs the PO / SO / OPN auto numbering
-- ---------------------------------------------------------------------
create table if not exists public.document_counters (
  prefix     text    not null,
  period     text    not null,
  last_value integer not null default 0,
  primary key (prefix, period)
);
