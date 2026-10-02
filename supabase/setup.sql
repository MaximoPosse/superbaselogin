create table if not exists public.productos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  nombre text not null check (char_length(trim(nombre)) between 1 and 120),
  descripcion text,
  precio numeric(12, 2) not null check (precio >= 0),
  stock integer not null default 0 check (stock >= 0),
  activo boolean not null default true,
  imagen_url text,
  imagen_ruta text,
  creado_en timestamptz not null default now()
);

alter table public.productos
  add column if not exists user_id uuid references auth.users (id) on delete cascade;
alter table public.productos add column if not exists nombre text;
alter table public.productos add column if not exists descripcion text;
alter table public.productos add column if not exists precio numeric(12, 2);
alter table public.productos add column if not exists stock integer default 0;
alter table public.productos add column if not exists activo boolean default true;
alter table public.productos add column if not exists imagen_url text;
alter table public.productos add column if not exists imagen_ruta text;
alter table public.productos add column if not exists creado_en timestamptz default now();

alter table public.productos enable row level security;
create index if not exists productos_user_id_creado_en_idx
  on public.productos (user_id, creado_en desc);

drop policy if exists "Users can read their products" on public.productos;
create policy "Users can read their products"
  on public.productos for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can create their products" on public.productos;
create policy "Users can create their products"
  on public.productos for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their products" on public.productos;
create policy "Users can update their products"
  on public.productos for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their products" on public.productos;
create policy "Users can delete their products"
  on public.productos for delete to authenticated
  using ((select auth.uid()) = user_id);

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'productos',
  'productos',
  true,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Users can upload product images" on storage.objects;
create policy "Users can upload product images"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'productos'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

drop policy if exists "Users can delete product images" on storage.objects;
create policy "Users can delete product images"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'productos'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );