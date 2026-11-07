-- Store BD Online database schema. Run in Supabase SQL Editor.
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 email text unique not null,
 full_name text default '',
 role text not null default 'customer' check (role in ('customer','admin')),
 created_at timestamptz not null default now(),
 last_login_at timestamptz,
 login_count integer not null default 0
);
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 name text not null, description text default '', category text default 'General',
 price numeric(12,2) not null default 0, compare_at_price numeric(12,2),
 image_url text default '', stock integer not null default 0,
 featured boolean not null default false, active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(), user_id uuid references auth.users(id),
 customer_email text not null, items jsonb not null default '[]', total numeric(12,2) not null,
 status text not null default 'pending', address text default '', phone text default '',
 created_at timestamptz not null default now()
);
create table if not exists public.login_events (
 id bigint generated always as identity primary key, user_id uuid references auth.users(id) on delete cascade,
 email text not null, logged_in_at timestamptz not null default now()
);
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into public.profiles(id,email,full_name) values(new.id,new.email,coalesce(new.raw_user_meta_data->>'full_name','')) on conflict(id) do nothing; return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
create or replace function public.record_login() returns void language plpgsql security definer set search_path=public as $$
begin update public.profiles set login_count=login_count+1,last_login_at=now() where id=auth.uid(); insert into public.login_events(user_id,email) select id,email from public.profiles where id=auth.uid(); end; $$;
alter table public.profiles enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.login_events enable row level security;
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $
  select exists(select 1 from public.profiles where id=auth.uid() and role='admin');
$;
drop policy if exists "profiles read own or admin" on public.profiles;
create policy "profiles read own or admin" on public.profiles for select to authenticated using (id=auth.uid() or public.is_admin());
drop policy if exists "profiles update own" on public.profiles;
create policy "profiles update own" on public.profiles for update to authenticated using (id=auth.uid());
drop policy if exists "products public read" on public.products;
create policy "products public read" on public.products for select using (active=true or public.is_admin());
drop policy if exists "products admin write" on public.products;
create policy "products admin write" on public.products for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "orders own or admin read" on public.orders;
create policy "orders own or admin read" on public.orders for select to authenticated using (user_id=auth.uid() or public.is_admin());
drop policy if exists "orders customer create" on public.orders;
create policy "orders customer create" on public.orders for insert to authenticated with check (user_id=auth.uid());
drop policy if exists "orders admin update" on public.orders;
create policy "orders admin update" on public.orders for update to authenticated using (public.is_admin());
drop policy if exists "login events admin read" on public.login_events;
create policy "login events admin read" on public.login_events for select to authenticated using (public.is_admin());
-- After the owner signs up, promote their account using the SQL below, replacing the email if needed:
-- update public.profiles set role='admin' where email='YOUR_ADMIN_EMAIL';
