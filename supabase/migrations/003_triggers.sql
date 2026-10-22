-- =====================================================================
-- ERPeace · 003_triggers.sql
-- Automatic profile creation on signup, updated_at maintenance and the
-- guard that prevents a user from changing their own role / active flag.
-- Run this file THIRD in the Supabase SQL Editor.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Keep updated_at fresh
-- ---------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

drop trigger if exists categories_set_updated_at on public.categories;
create trigger categories_set_updated_at
  before update on public.categories
  for each row execute function public.set_updated_at();

drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at
  before update on public.products
  for each row execute function public.set_updated_at();

drop trigger if exists stock_movements_set_updated_at on public.stock_movements;
create trigger stock_movements_set_updated_at
  before update on public.stock_movements
  for each row execute function public.set_updated_at();

drop trigger if exists stock_opnames_set_updated_at on public.stock_opnames;
create trigger stock_opnames_set_updated_at
  before update on public.stock_opnames
  for each row execute function public.set_updated_at();

drop trigger if exists stock_opname_items_set_updated_at on public.stock_opname_items;
create trigger stock_opname_items_set_updated_at
  before update on public.stock_opname_items
  for each row execute function public.set_updated_at();

drop trigger if exists suppliers_set_updated_at on public.suppliers;
create trigger suppliers_set_updated_at
  before update on public.suppliers
  for each row execute function public.set_updated_at();

drop trigger if exists customers_set_updated_at on public.customers;
create trigger customers_set_updated_at
  before update on public.customers
  for each row execute function public.set_updated_at();

drop trigger if exists purchase_orders_set_updated_at on public.purchase_orders;
create trigger purchase_orders_set_updated_at
  before update on public.purchase_orders
  for each row execute function public.set_updated_at();

drop trigger if exists purchase_order_items_set_updated_at on public.purchase_order_items;
create trigger purchase_order_items_set_updated_at
  before update on public.purchase_order_items
  for each row execute function public.set_updated_at();

drop trigger if exists sales_orders_set_updated_at on public.sales_orders;
create trigger sales_orders_set_updated_at
  before update on public.sales_orders
  for each row execute function public.set_updated_at();

drop trigger if exists sales_order_items_set_updated_at on public.sales_order_items;
create trigger sales_order_items_set_updated_at
  before update on public.sales_order_items
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------
-- Create the profile row automatically on signup
-- role defaults to 'sales' and is_active to false, so a new account has to
-- be activated by an admin before it can use the application.
-- ---------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email, role, is_active)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'full_name', ''),
      nullif(new.raw_user_meta_data ->> 'name', ''),
      split_part(coalesce(new.email, ''), '@', 1)
    ),
    new.email,
    'sales',
    false
  )
  on conflict (id) do update
    set email = coalesce(excluded.email, profiles.email);

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------
-- A user can never change their own role or active flag
-- ---------------------------------------------------------------------
create or replace function public.prevent_self_role_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.id = auth.uid()
     and (new.role is distinct from old.role or new.is_active is distinct from old.is_active)
  then
    raise exception 'Anda tidak dapat mengubah role atau status aktif akun Anda sendiri.'
      using errcode = '42501';
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_prevent_self_role_change on public.profiles;
create trigger profiles_prevent_self_role_change
  before update on public.profiles
  for each row execute function public.prevent_self_role_change();
