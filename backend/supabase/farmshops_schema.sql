create extension if not exists pgcrypto;

create table if not exists farmshops (
  id uuid primary key default gen_random_uuid(),
  source_key text not null,
  external_id text,
  name text not null,
  country_code text not null,
  country text,
  region text,
  municipality text,
  address text,
  products jsonb not null default '[]'::jsonb,
  website text,
  lat double precision not null,
  lon double precision not null,
  category text,
  phone text,
  opening_hours text,
  maps_url text,
  quality_score integer not null default 0,
  source text not null default 'seed',
  first_seen_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  last_verified_at timestamptz,
  unique (source_key)
);

create index if not exists idx_farmshops_country_region_muni on farmshops (country_code, region, municipality);
create index if not exists idx_farmshops_last_seen on farmshops (last_seen_at desc);

create table if not exists farmshops_area_cache (
  cache_key text primary key,
  country_code text not null,
  region_text text,
  municipality_text text,
  query_text text,
  shops jsonb not null,
  result_count integer not null default 0,
  generated_at timestamptz not null default now(),
  source text not null default 'pipeline'
);

create index if not exists idx_farmshops_area_country on farmshops_area_cache (country_code);
create index if not exists idx_farmshops_area_generated on farmshops_area_cache (generated_at desc);

create table if not exists farmshops_enrich_jobs (
  id uuid primary key default gen_random_uuid(),
  cache_key text not null,
  country_code text,
  region_text text,
  municipality_text text,
  query_text text,
  status text not null default 'queued',
  requested_by text,
  requested_at timestamptz not null default now(),
  started_at timestamptz,
  completed_at timestamptz,
  result_count integer,
  error_message text
);

create index if not exists idx_farmshops_jobs_status_time on farmshops_enrich_jobs (status, requested_at desc);
