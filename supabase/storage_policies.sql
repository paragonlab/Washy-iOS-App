-- Crear el bucket 'avatars' si no existe
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Política para permitir lectura pública de avatares
create policy "Avatares son visibles públicamente"
on storage.objects for select
using ( bucket_id = 'avatars' );

-- Política para permitir que los usuarios autenticados suban sus propios avatares
create policy "Usuarios pueden subir sus propios avatares"
on storage.objects for insert
with check (
    bucket_id = 'avatars'
    and auth.role() = 'authenticated'
    and (storage.foldername(name))[1] = auth.uid()::text
);

-- Política para permitir que los usuarios actualicen sus propios avatares
create policy "Usuarios pueden actualizar sus propios avatares"
on storage.objects for update
using (
    bucket_id = 'avatars'
    and auth.role() = 'authenticated'
    and (storage.foldername(name))[1] = auth.uid()::text
);

-- Política para permitir que los usuarios eliminen sus propios avatares
create policy "Usuarios pueden eliminar sus propios avatares"
on storage.objects for delete
using (
    bucket_id = 'avatars'
    and auth.role() = 'authenticated'
    and (storage.foldername(name))[1] = auth.uid()::text
); 