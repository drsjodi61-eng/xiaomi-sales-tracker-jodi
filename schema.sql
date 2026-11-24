-- Xiaomi Sales Tracker Jodi — Supabase SQL
-- Jalankan di Supabase Dashboard > SQL Editor.
-- Browser client wajib menggunakan anon/publishable key, TIDAK service_role.
create table if not exists public.jodi_sales_vault (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.jodi_sales_vault enable row level security;
drop policy if exists "user reads own encrypted vault" on public.jodi_sales_vault;
create policy "user reads own encrypted vault"
on public.jodi_sales_vault for select to authenticated
using (auth.uid() = user_id);
drop policy if exists "user inserts own encrypted vault" on public.jodi_sales_vault;
create policy "user inserts own encrypted vault"
on public.jodi_sales_vault for insert to authenticated
with check (auth.uid() = user_id);
drop policy if exists "user updates own encrypted vault" on public.jodi_sales_vault;
create policy "user updates own encrypted vault"
on public.jodi_sales_vault for update to authenticated
using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "user deletes own encrypted vault" on public.jodi_sales_vault;
create policy "user deletes own encrypted vault"
on public.jodi_sales_vault for delete to authenticated
using (auth.uid() = user_id);
revoke all on public.jodi_sales_vault from anon;
grant select, insert, update, delete on public.jodi_sales_vault to authenticated;
