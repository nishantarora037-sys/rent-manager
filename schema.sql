-- Rent Manager schema. Run once in Supabase: SQL Editor > New query > Run.
create table members(email text primary key, role text not null check (role in ('owner','editor','viewer')));
create function role_of() returns text language sql stable security definer set search_path=public as $$ select role from members where email=lower(auth.jwt()->>'email') $$;
create function touch() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
alter table members enable row level security;
create policy m_self on members for select using (email=lower(auth.jwt()->>'email'));
create policy m_owner on members for all using (role_of()='owner') with check (role_of()='owner');

do $$ declare t text; begin
foreach t in array array['props','ten','bills','pays','logs','settings'] loop
 execute format('create table %I(id text primary key, data jsonb not null, updated_at timestamptz not null default now(), updated_by text)',t);
 execute format('create trigger %I before update on %I for each row execute function touch()','touch_'||t,t);
 execute format('alter table %I enable row level security',t);
 execute format('create policy %I on %I for select using (role_of() is not null)',t||'_r',t);
 execute format('create policy %I on %I for insert with check (role_of() in (''owner'',''editor''))',t||'_i',t);
 execute format('create policy %I on %I for update using (role_of() in (''owner'',''editor'')) with check (role_of() in (''owner'',''editor''))',t||'_u',t);
 execute format('create policy %I on %I for delete using (role_of()=''owner'')',t||'_d',t);
 execute format('alter publication supabase_realtime add table %I',t);
end loop; end $$;

-- Add yourself as owner (change the email), then add family later the same way:
insert into members(email,role) values ('YOUR_EMAIL@example.com','owner');
-- insert into members(email,role) values ('wife@example.com','editor');  -- or 'viewer'
