-- Users Table
create table public.users (
  id uuid default gen_random_uuid() primary key,
  email text unique not null,
  password text not null, -- For mock auth simplicity
  name text not null,
  role text not null check (role in ('student', 'admin', 'operator')),
  balance numeric not null default 0,
  department text,
  "assignedPrinterId" text
);

-- Printers Table
create table public.printers (
  id text primary key,
  name text not null,
  location text not null,
  status text not null check (status in ('online', 'offline', 'busy')),
  queue integer not null default 0
);

-- Print Jobs Table
create table public.print_jobs (
  id uuid default gen_random_uuid() primary key,
  "userId" uuid references public.users(id) not null,
  "userName" text not null,
  "fileName" text not null,
  pages integer not null,
  copies integer not null,
  "colorMode" text not null check ("colorMode" in ('bw', 'color')),
  "paperSize" text not null check ("paperSize" in ('A4', 'Letter')),
  "printerName" text not null,
  status text not null check (status in ('pending', 'printing', 'completed', 'failed')),
  cost numeric not null,
  timestamp timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS (Row Level Security) - Optional but good practice. For now we will allow all access to mimic local storage behavior.
alter table public.users enable row level security;
alter table public.printers enable row level security;
alter table public.print_jobs enable row level security;

-- Policies to allow full access for mock frontend testing
create policy "Allow all operations on users" on public.users for all using (true) with check (true);
create policy "Allow all operations on printers" on public.printers for all using (true) with check (true);
create policy "Allow all operations on print_jobs" on public.print_jobs for all using (true) with check (true);

-- Insert Default Data
insert into public.users (email, password, name, role, balance, "assignedPrinterId") values
  ('admin@college.edu', 'admin123', 'System Administrator', 'admin', 0, null),
  ('coop.operator@college.edu', 'operator123', 'Cooperative Store Operator', 'operator', 0, '1'),
  ('cse.operator@college.edu', 'operator123', 'CSE Department Operator', 'operator', 0, '2'),
  ('library.operator@college.edu', 'operator123', 'Library Operator', 'operator', 0, '3');

insert into public.printers (id, name, location, status, queue) values
  ('1', 'Cooperative Store Printer (Main)', 'Cooperative Store', 'online', 0),
  ('2', 'CSE Department', 'Computer Science Department', 'online', 0),
  ('3', 'Library', 'College Library', 'online', 0);
