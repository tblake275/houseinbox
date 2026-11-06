-- House In Box schema v1
-- Pre-review tool + ground truth (MCRs) + grading.

create extension if not exists vector;

-- Jurisdictions and code -------------------------------------------------

create table jurisdictions (
  id text primary key,                      -- 'austin', 'round-rock'
  name text not null,
  irc_edition text,                          -- '2024'
  portal text,                               -- 'AB+C', 'MGO Connect'
  has_city_ai_precheck boolean default false,
  notes text,
  created_at timestamptz default now()
);

create table code_sections (
  id bigserial primary key,
  jurisdiction_id text references jurisdictions(id),
  code text not null,                        -- 'IRC', 'LDC 25-2'
  edition text,
  section text not null,                     -- 'R310.2.1', '25-2-1424'
  title text,
  body text,
  embedding vector(1024),
  unique (jurisdiction_id, code, edition, section)
);

create table rules (
  id text primary key,                       -- 'aus.zon.front_setback'
  jurisdiction_id text references jurisdictions(id),
  tier smallint not null check (tier in (1, 2, 3)),
  l1 text not null,
  l3 text,
  code_section text,
  description text not null,
  inputs jsonb,                              -- extracted fields the rule needs
  version int not null default 1,
  active boolean default true
);

-- Projects and plan sets ---------------------------------------------------

create table projects (
  id text primary key,                       -- 'AUS-0001'
  jurisdiction_id text references jurisdictions(id),
  permit_number text,
  pr_case_number text,
  parcel_id text,
  zoning text,
  overlays text[],
  unit_count smallint,
  work_class text,                           -- 'new', 'addition', 'remodel'
  source text,                               -- 'ahfh', 'partner', 'pia', 'user'
  split text check (split in ('calib', 'test')),
  created_at timestamptz default now()
);

create table plan_sets (
  id bigserial primary key,
  project_id text references projects(id) on delete cascade,
  cycle smallint not null,                   -- 0 = U0 first submittal
  storage_path text not null,
  page_count int,
  submitted_date date,
  unique (project_id, cycle)
);

create table sheets (
  id bigserial primary key,
  plan_set_id bigint references plan_sets(id) on delete cascade,
  page int not null,
  sheet_id text,                             -- 'A1.1'
  sheet_type text,                           -- 'site', 'floor', 'elevation', 'structural', 'energy'
  extracted jsonb,                           -- dimensions, areas, notes
  unique (plan_set_id, page)
);

-- Ground truth: Master Comment Reports ---------------------------------------

create table mcr_reports (
  id bigserial primary key,
  project_id text references projects(id) on delete cascade,
  cycle smallint not null,
  report_date date,
  storage_path text,
  disciplines_reviewed text[],               -- L1 codes whose review ran this cycle
  unique (project_id, cycle)
);

create table mcr_comments (
  id bigserial primary key,
  mcr_report_id bigint references mcr_reports(id) on delete cascade,
  comment_ref text,                          -- 'RZ03'
  prefix text,                               -- 'RZ'
  body text not null,
  code_citation text,                        -- optional
  l1 text,
  l2 text check (l2 in ('a','b','c','d','e')),
  l3 text,
  sheet_ref text,
  status text check (status in ('new','remains','cleared')),
  labeled_by text,                           -- 'human', 'model'
  created_at timestamptz default now()
);

-- Tool output and grading ------------------------------------------------------

create table review_runs (
  id bigserial primary key,
  plan_set_id bigint references plan_sets(id) on delete cascade,
  tool_version text not null,                -- git sha or tag
  started_at timestamptz default now(),
  finished_at timestamptz
);

create table findings (
  id bigserial primary key,
  review_run_id bigint references review_runs(id) on delete cascade,
  source text check (source in ('rule','llm')),
  rule_id text references rules(id),
  l1 text, l2 text, l3 text,
  sheet_ref text,
  code_citation text,
  body text not null,
  suggested_fix text,
  confidence real check (confidence between 0 and 1)
);

create table feedback (
  id bigserial primary key,
  finding_id bigint references findings(id) on delete cascade,
  mark text check (mark in ('correct','wrong','unsure')),
  note text,
  user_id uuid,
  created_at timestamptz default now()
);

create table grades (
  id bigserial primary key,
  finding_id bigint references findings(id) on delete cascade,
  mcr_comment_id bigint references mcr_comments(id),
  result text check (result in ('match','no_match','unverified')),
  grader text,                               -- 'human', 'grader-v1'
  created_at timestamptz default now()
);

create table eval_runs (
  id bigserial primary key,
  tool_version text not null,
  split text check (split in ('calib','test')),
  precision_l1 real, recall_l1 real,
  precision_l1l3 real, recall_l1l3 real,
  takeoff_pass_rate real,
  decision text check (decision in ('ship','block')),
  notes text,
  created_at timestamptz default now()
);

-- Takeoffs ---------------------------------------------------------------------

create table takeoff_items (
  id bigserial primary key,
  project_id text references projects(id) on delete cascade,
  source text check (source in ('estimator','tool')),
  tool_version text,
  assembly text not null,                    -- matches eval/takeoff_tolerances.yaml
  quantity numeric not null,
  unit text not null
);

-- Security: no public access. Service role only until the app adds auth policies.
alter table jurisdictions enable row level security;
alter table code_sections enable row level security;
alter table rules enable row level security;
alter table projects enable row level security;
alter table plan_sets enable row level security;
alter table sheets enable row level security;
alter table mcr_reports enable row level security;
alter table mcr_comments enable row level security;
alter table review_runs enable row level security;
alter table findings enable row level security;
alter table grades enable row level security;
alter table feedback enable row level security;
alter table eval_runs enable row level security;
alter table takeoff_items enable row level security;

insert into jurisdictions (id, name, irc_edition, portal, has_city_ai_precheck) values
  ('austin', 'City of Austin', '2024', 'AB+C', true),
  ('round-rock', 'City of Round Rock', null, 'Trimble Cityworks', false),
  ('georgetown', 'City of Georgetown', null, 'MGO Connect', false),
  ('kyle', 'City of Kyle', null, 'Tyler EnerGov CSS', false);
