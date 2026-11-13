-- VISUAL ARCHIVE: run this entire script in Supabase Dashboard → SQL Editor.
-- Creates one private JSON workspace per authenticated user and a private image bucket.
create table if not exists public.workspace_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"images":[],"collections":[],"projects":[],"board":[]}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.workspace_data enable row level security;
drop policy if exists "Users can read their own workspace" on public.workspace_data;
drop policy if exists "Users can create their own workspace" on public.workspace_data;
drop policy if exists "Users can update their own workspace" on public.workspace_data;
create policy "Users can read their own workspace" on public.workspace_data for select to authenticated using (auth.uid() = user_id);
create policy "Users can create their own workspace" on public.workspace_data for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can update their own workspace" on public.workspace_data for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('visual-archive-images', 'visual-archive-images', false, 10485760, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public=false, file_size_limit=10485760, allowed_mime_types=excluded.allowed_mime_types;
drop policy if exists "Users can read their own archive images" on storage.objects;
drop policy if exists "Users can upload their own archive images" on storage.objects;
drop policy if exists "Users can delete their own archive images" on storage.objects;
create policy "Users can read their own archive images" on storage.objects for select to authenticated using (bucket_id = 'visual-archive-images' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Users can upload their own archive images" on storage.objects for insert to authenticated with check (bucket_id = 'visual-archive-images' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Users can delete their own archive images" on storage.objects for delete to authenticated using (bucket_id = 'visual-archive-images' and (storage.foldername(name))[1] = auth.uid()::text);
