-- ============================================================
-- SCHEMA PARA PANEL PROYECTO POO (Supabase SQL Editor)
-- Copia y pega todo este script en el SQL Editor y dale a RUN.
-- ============================================================

-- 1. Tabla de Tareas
create table if not exists tasks (
  id bigint primary key generated always as identity,
  title text not null,
  description text default '',
  assignee_id integer not null,
  status text default 'TODO',
  priority text default 'MEDIUM',
  due_date date,
  category text default 'General',
  links jsonb default '[]'::jsonb,
  comments jsonb default '[]'::jsonb,
  blocked_reason text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. Tabla de Historial
create table if not exists history (
  id bigint primary key generated always as identity,
  task_id bigint,
  action text not null,
  details text,
  author_id integer not null,
  created_at timestamptz default now()
);

-- 3. Tabla de Notas Compartidas
create table if not exists notes (
  id bigint primary key generated always as identity,
  content text not null,
  author_id integer not null,
  pinned boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 4. Habilitar Tiempo Real en todas las tablas
alter publication supabase_realtime add table tasks;
alter publication supabase_realtime add table history;
alter publication supabase_realtime add table notes;

-- 5. Habilitar Row Level Security (RLS) público para la API anon
alter table tasks enable row level security;
create policy "acceso_publico_tasks" on tasks for all using (true) with check (true);

alter table history enable row level security;
create policy "acceso_publico_history" on history for all using (true) with check (true);

alter table notes enable row level security;
create policy "acceso_publico_notes" on notes for all using (true) with check (true);
