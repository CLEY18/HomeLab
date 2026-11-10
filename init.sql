-- ─── Additional Databases ────────────────────────────────
-- (The workspace is created automatically from POSTGRES_DB)
CREATE DATABASE npm;
CREATE DATABASE nextcloud;
CREATE DATABASE vaultwarden;
CREATE DATABASE jupyter;
CREATE DATABASE paperclip;
CREATE DATABASE anythingllm;
CREATE DATABASE librechat_rag;

-- ─── Workspace db extensions ─────────────────────────────
\c workspace
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ─── AI services db extensions ───────────────────────────
\c anythingllm
CREATE EXTENSION IF NOT EXISTS vector;

\c librechat_rag
CREATE EXTENSION IF NOT EXISTS vector;
