-- ─── Additional Databases ────────────────────────────────
-- (The workspace is created automatically from POSTGRES_DB)
CREATE DATABASE npm;
CREATE DATABASE nextcloud;
CREATE DATABASE vaultwarden;
CREATE DATABASE jupyter;

-- ─── Workspace db extensions ─────────────────────────────
\c workspace
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
