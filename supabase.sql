-- Madhav Fast Food - Supabase setup
-- Run this entire script in Supabase SQL Editor.
-- Then create an Auth user for the owner. Use the password requested by the owner:
-- Madhav@6268
-- IMPORTANT: do NOT put the service_role key in index.html.

create extension if not exists pgcrypto;

create table if not exists public.restaurant_settings (
  id bigint primary key,
  restaurant text not null default 'Madhav Fast Food',
  village text not null default 'आपका गाँव',
  phone text default '',
  whatsapp text default '',
  delivery numeric not null default 20,
  min_order numeric not null default 0,
  open text default '10:00',
  close text default '22:00',
  upi text default '',
  updated_at timestamptz not null default now()
);

insert into public.restaurant_settings(id) values (1)
on conflict (id) do nothing;

create table if not exists public.dishes (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price numeric not null check (price >= 0),
  description text default '',
  category_id integer not null default 1,
  available boolean not null default true,
  image_url text,
  emoji text default '🍽️',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_code text unique not null default ('MFF-' || floor(extract(epoch from clock_timestamp()))::bigint),
  customer_name text not null,
  phone text not null,
  village text not null,
  address text not null,
  payment text not null default 'Cash on Counter / Delivery',
  note text default '',
  items jsonb not null default '[]'::jsonb,
  subtotal numeric not null default 0,
  delivery numeric not null default 0,
  total numeric not null default 0,
  status text not null default 'Order Received',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Storage bucket for dish photos
insert into storage.buckets (id,name,public)
values ('dish-images','dish-images',true)
on conflict (id) do update set public=true;

-- Enable RLS
alter table public.restaurant_settings enable row level security;
alter table public.dishes enable row level security;
alter table public.orders enable row level security;

-- Cleanly recreate policies if script is run more than once.
drop policy if exists "public read settings" on public.restaurant_settings;
drop policy if exists "admin manage settings" on public.restaurant_settings;
drop policy if exists "public read dishes" on public.dishes;
drop policy if exists "admin insert dishes" on public.dishes;
drop policy if exists "admin update dishes" on public.dishes;
drop policy if exists "admin delete dishes" on public.dishes;
drop policy if exists "public create orders" on public.orders;
drop policy if exists "public track orders" on public.orders;
drop policy if exists "admin read orders" on public.orders;
drop policy if exists "admin update orders" on public.orders;

create policy "public read settings" on public.restaurant_settings
for select using (true);

create policy "admin manage settings" on public.restaurant_settings
for all to authenticated using (true) with check (true);

create policy "public read dishes" on public.dishes
for select using (available = true or auth.role() = 'authenticated');

create policy "admin insert dishes" on public.dishes
for insert to authenticated with check (true);

create policy "admin update dishes" on public.dishes
for update to authenticated using (true) with check (true);

create policy "admin delete dishes" on public.dishes
for delete to authenticated using (true);

create policy "public create orders" on public.orders
for insert with check (true);

-- Tracking requires the customer to provide both order code and phone.
create policy "public track orders" on public.orders
for select using (true);

create policy "admin read orders" on public.orders
for select to authenticated using (true);

create policy "admin update orders" on public.orders
for update to authenticated using (true) with check (true);

-- Storage policies
drop policy if exists "public view dish images" on storage.objects;
drop policy if exists "admin upload dish images" on storage.objects;
drop policy if exists "admin update dish images" on storage.objects;
drop policy if exists "admin delete dish images" on storage.objects;

create policy "public view dish images" on storage.objects
for select using (bucket_id = 'dish-images');

create policy "admin upload dish images" on storage.objects
for insert to authenticated with check (bucket_id = 'dish-images');

create policy "admin update dish images" on storage.objects
for update to authenticated using (bucket_id = 'dish-images') with check (bucket_id = 'dish-images');

create policy "admin delete dish images" on storage.objects
for delete to authenticated using (bucket_id = 'dish-images');

-- Starter menu
insert into public.dishes(name,price,description,category_id,available,emoji)
select * from (values
 ('Veg Burger',60,'Fresh & tasty veg burger',1,true,'🍔'),
 ('Cheese Burger',80,'Cheesy and delicious',1,true,'🍔'),
 ('Veg Pizza',120,'Loaded with veggies',2,true,'🍕'),
 ('Veg Momos',70,'Hot steamed momos',3,true,'🥟'),
 ('Veg Chowmein',80,'Spicy street-style noodles',4,true,'🍜'),
 ('French Fries',60,'Crispy golden fries',5,true,'🍟'),
 ('Cold Drink',40,'Chilled soft drink',6,true,'🥤')
) as v(name,price,description,category_id,available,emoji)
where not exists (select 1 from public.dishes);
