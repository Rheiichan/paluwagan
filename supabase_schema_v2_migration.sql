-- Paluwagan Tracker — migration v2
-- Run AFTER supabase_schema.sql, in the SQL editor.
-- Adds: per-member username/password login, and actual amount paid per cutoff.

alter table paluwagan_members
  add column if not exists username text unique,
  add column if not exists password text;

alter table paluwagan_contributions
  add column if not exists c15_amount numeric not null default 0,
  add column if not exists c30_amount numeric not null default 0;

-- Optional: backfill existing members with a placeholder login so the app
-- doesn't break for rows created before this migration. Update these in
-- the admin "Member Accounts" tab afterward.
update paluwagan_members
set username = coalesce(username, lower(regexp_replace(name, '[^a-zA-Z0-9]', '', 'g')) || floor(random()*900+100)::text),
    password = coalesce(password, 'changeme' || floor(random()*900+100)::text)
where username is null;
