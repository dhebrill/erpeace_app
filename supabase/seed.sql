-- =====================================================================
-- ERPeace · seed.sql
-- Demo data for a fresh project.
-- Run this file AFTER 001_schema.sql, 002_functions.sql, 003_triggers.sql
-- and 004_rls.sql in the Supabase SQL Editor.
--
-- The script is idempotent: running it twice does not duplicate rows.
-- It never creates auth users, so the admin panel starts empty and the
-- first admin has to be promoted manually (see README).
-- =====================================================================

-- ---------------------------------------------------------------------
-- Categories
-- ---------------------------------------------------------------------
insert into public.categories (id, name) values
  ('11111111-1111-4111-8111-000000000001', 'Elektronik'),
  ('11111111-1111-4111-8111-000000000002', 'Furniture'),
  ('11111111-1111-4111-8111-000000000003', 'Stationer'),
  ('11111111-1111-4111-8111-000000000004', 'Makanan & Minuman'),
  ('11111111-1111-4111-8111-000000000005', 'Olahraga')
on conflict (name) do nothing;

-- ---------------------------------------------------------------------
-- Suppliers
-- ---------------------------------------------------------------------
insert into public.suppliers (id, name, phone, email, address) values
  ('22222222-2222-4222-8222-000000000001', 'PT Nusantara Elektronik', '021-5550101', 'sales@nusantara-elektronik.co.id', 'Jl. Raya Industri No. 12, Jakarta Timur'),
  ('22222222-2222-4222-8222-000000000002', 'CV Karya Furniture', '022-5550102', 'info@karyafurniture.co.id', 'Jl. Pajajaran No. 45, Bandung'),
  ('22222222-2222-4222-8222-000000000003', 'CV Sumber Stationer', '027-5550103', 'order@sumberstationer.co.id', 'Jl. Malioboro No. 8, Yogyakarta'),
  ('22222222-2222-4222-8222-000000000004', 'PT Nusantara Food', '031-5550104', 'cs@nusantarafood.co.id', 'Jl. Puri No. 21, Surabaya'),
  ('22222222-2222-4222-8222-000000000005', 'PT Sporting Nusantara', '021-5550105', 'sales@sportingnusantara.co.id', 'Jl. Gelora No. 7, Jakarta Selatan')
on conflict (id) do nothing;

-- ---------------------------------------------------------------------
-- Customers
-- ---------------------------------------------------------------------
insert into public.customers (id, name, phone, email, address) values
  ('33333333-3333-4333-8333-000000000001', 'CV Maju Jaya', '021-5550201', 'beli@majujaya.co.id', 'Jl. Sudirman No. 1, Jakarta Pusat'),
  ('33333333-3333-4333-8333-000000000002', 'Toko Berkah Abadi', '021-5550202', 'tokoberkah@gmail.com', 'Jl. Pasar Baru No. 15, Jakarta Pusat'),
  ('33333333-3333-4333-8333-000000000003', 'CV Sinar Terang', '022-5550203', 'order@sinarterang.co.id', 'Jl. Asia Afrika No. 100, Bandung'),
  ('33333333-3333-4333-8333-000000000004', 'Warung Bu Imas', '027-5550204', 'buimas@example.com', 'Jl. Malioboro No. 55, Yogyakarta'),
  ('33333333-3333-4333-8333-000000000005', 'PT Garuda Logistik', '031-5550205', 'purchasing@garudalogistik.co.id', 'Jl. Rungkut Industri No. 3, Surabaya')
on conflict (id) do nothing;

-- ---------------------------------------------------------------------
-- Products
-- ---------------------------------------------------------------------
insert into public.products
  (id, sku, name, category_id, unit, buy_price, sell_price, stock, min_stock) values
  ('44444444-4444-4444-8444-000000000001', 'ELK-001', 'Smartphone 5G 128GB',   '11111111-1111-4111-8111-000000000001', 'pcs', 3250000, 3999000, 42, 10),
  ('44444444-4444-4444-8444-000000000002', 'ELK-002', 'Laptop 14" Core i5',     '11111111-1111-4111-8111-000000000001', 'pcs', 8650000, 10250000, 18, 5),
  ('44444444-4444-4444-8444-000000000003', 'ELK-003', 'Headset Wireless ANC',   '11111111-1111-4111-8111-000000000001', 'pcs', 620000,  899000,  75, 20),
  ('44444444-4444-4444-8444-000000000004', 'ELK-004', 'Powerbank 20.000mAh',    '11111111-1111-4111-8111-000000000001', 'pcs', 245000,  349000,  120, 30),
  ('44444444-4444-4444-8444-000000000005', 'ELK-005', 'Smart TV 43" 4K',        '11111111-1111-4111-8111-000000000001', 'pcs', 4750000, 5499000, 12, 4),
  ('44444444-4444-4444-8444-000000000006', 'FUR-001', 'Kursi Kerja Ergonomis',  '11111111-1111-4111-8111-000000000002', 'pcs', 780000,  1150000, 35, 10),
  ('44444444-4444-4444-8444-000000000007', 'FUR-002', 'Meja Meeting 240cm',     '11111111-1111-4111-8111-000000000002', 'pcs', 3200000, 4250000, 9, 3),
  ('44444444-4444-4444-8444-000000000008', 'FUR-003', 'Lemari Arsip 4 Pintu',    '11111111-1111-4111-8111-000000000002', 'pcs', 2450000, 3195000, 7, 3),
  ('44444444-4444-4444-8444-000000000009', 'FUR-004', 'Rak Steel 5 Levels',     '11111111-1111-4111-8111-000000000002', 'pcs', 890000,  1190000, 26, 8),
  ('44444444-4444-4444-8444-000000000010', 'FUR-005', 'Sofa Minimalis 3 Seat',  '11111111-1111-4111-8111-000000000002', 'pcs', 2150000, 2850000, 11, 4),
  ('44444444-4444-4444-8444-000000000011', 'STA-001', 'Kertas A4 80gr (500s)',  '11111111-1111-4111-8111-000000000003', 'rim', 62000,   85000,   210, 50),
  ('44444444-4444-4444-8444-000000000012', 'STA-002', 'Pulpen Gel 0.5 (12s)',   '11111111-1111-4111-8111-000000000003', 'pak', 24000,   38000,   320, 80),
  ('44444444-4444-4444-8444-000000000013', 'STA-003', 'Buku Tulis 38 Sheets',   '11111111-1111-4111-8111-000000000003', 'pcs', 9500,    15000,   540, 120),
  ('44444444-4444-4444-8444-000000000014', 'STA-004', 'Stapler Heavy Duty',     '11111111-1111-4111-8111-000000000003', 'pcs', 175000,  235000,  44, 15),
  ('44444444-4444-4444-8444-000000000015', 'STA-005', 'Kalkulator Scientific',  '11111111-1111-4111-8111-000000000003', 'pcs', 118000,  165000,  58, 15),
  ('44444444-4444-4444-8444-000000000016', 'FNB-001', 'Kopi Arabika 250g',      '11111111-1111-4111-8111-000000000004', 'pcs', 58000,   85000,   260, 60),
  ('44444444-4444-4444-8444-000000000017', 'FNB-002', 'Susu UHT Full Cream 1L',  '11111111-1111-4111-8111-000000000004', 'pcs', 16500,   22000,   480, 100),
  ('44444444-4444-4444-8444-000000000018', 'FNB-003', 'Mi Instan Goreng (5s)',   '11111111-1111-4111-8111-000000000004', 'pcs', 13500,   18000,   610, 150),
  ('44444444-4444-4444-8444-000000000019', 'OLR-001', 'Bola Sepak Pro',         '11111111-1111-4111-8111-000000000005', 'pcs', 145000,  199000,  66, 20),
  ('44444444-4444-4444-8444-000000000020', 'OLR-002', 'Raket Badminton Carbon', '11111111-1111-4111-8111-000000000005', 'pcs', 385000,  529000,  38, 10)
on conflict (sku) do nothing;

-- ---------------------------------------------------------------------
-- Opening stock movements
-- ---------------------------------------------------------------------
insert into public.stock_movements
  (product_id, type, quantity, reference_type, note)
select id, 'in', stock, 'opening', 'Saldo awal sistem'
from public.products
where stock > 0
  and not exists (
    select 1 from public.stock_movements m
    where m.product_id = public.products.id
      and m.reference_type = 'opening'
  );

-- ---------------------------------------------------------------------
-- Sample purchase orders
-- ---------------------------------------------------------------------
insert into public.purchase_orders
  (id, po_number, supplier_id, status, total, note)
values
  ('55555555-5555-4555-8555-000000000001', 'PO-2026-0001', '22222222-2222-4222-8222-000000000001', 'approved', 19750000, 'Pengadaan perangkat kantor'),
  ('55555555-5555-4555-8555-000000000002', 'PO-2026-0002', '22222222-2222-4222-8222-000000000003', 'draft', 13400000, 'Pengadaan alat tulis')
on conflict (po_number) do nothing;

insert into public.purchase_order_items
  (id, purchase_order_id, product_id, qty, price, subtotal) values
  ('66666666-6666-4666-8666-000000000001', '55555555-5555-4555-8555-000000000001', '44444444-4444-4444-8444-000000000003', 20,  620000, 12400000),
  ('66666666-6666-4666-8666-000000000002', '55555555-5555-4555-8555-000000000001', '44444444-4444-4444-8444-000000000004', 30,  245000, 7350000),
  ('66666666-6666-4666-8666-000000000003', '55555555-5555-4555-8555-000000000002', '44444444-4444-4444-8444-000000000011', 100, 62000,  6200000),
  ('66666666-6666-4666-8666-000000000004', '55555555-5555-4555-8555-000000000002', '44444444-4444-4444-8444-000000000012', 300, 24000,  7200000)
on conflict (id) do nothing;

update public.purchase_orders po
   set total = agg.total
  from (
    select purchase_order_id, sum(subtotal) as total
    from public.purchase_order_items
    group by purchase_order_id
  ) agg
 where agg.purchase_order_id = po.id
   and po.total <> agg.total;

-- ---------------------------------------------------------------------
-- Sample sales orders
-- ---------------------------------------------------------------------
insert into public.sales_orders
  (id, so_number, customer_id, status, total, note)
values
  ('77777777-7777-4777-8777-000000000001', 'SO-2026-0001', '33333333-3333-4333-8333-000000000001', 'approved', 16372000, 'Pemasangan perangkat kantor'),
  ('77777777-7777-4777-8777-000000000002', 'SO-2026-0002', '33333333-3333-4333-8333-000000000002', 'draft', 8725000, 'Pembelian aksesori')
on conflict (so_number) do nothing;

insert into public.sales_order_items
  (id, sales_order_id, product_id, qty, price, subtotal) values
  ('88888888-8888-4888-8888-000000000001', '77777777-7777-4777-8777-000000000001', '44444444-4444-4444-8444-000000000003', 12, 899000, 10788000),
  ('88888888-8888-4888-8888-000000000002', '77777777-7777-4777-8777-000000000001', '44444444-4444-4444-8444-000000000004', 16, 349000, 5584000),
  ('88888888-8888-4888-8888-000000000003', '77777777-7777-4777-8777-000000000002', '44444444-4444-4444-8444-000000000004', 25, 349000, 8725000)
on conflict (id) do nothing;

update public.sales_orders so
   set total = agg.total
  from (
    select sales_order_id, sum(subtotal) as total
    from public.sales_order_items
    group by sales_order_id
  ) agg
 where agg.sales_order_id = so.id
   and so.total <> agg.total;

-- ---------------------------------------------------------------------
-- Document counters aligned with the seeded documents
-- ---------------------------------------------------------------------
insert into public.document_counters (prefix, period, last_value) values
  ('PO', '2026', 2),
  ('SO', '2026', 2)
on conflict (prefix, period) do update set last_value = excluded.last_value;
