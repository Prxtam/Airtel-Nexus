# Database design (Phase 1)

This folder contains the SQLAlchemy ORM models for Phase 1:
- Authentication: `users`, `roles`, `user_roles`
- Tasks: `tasks`
- Meeting notes: `customers`, `meetings`, `meeting_notes`

Design choices:
- UUID primary keys (PostgreSQL `uuid`)
- `created_at`/`updated_at` timestamps (UTC via `timestamptz`)
- FK `ondelete` rules chosen to match expected behavior:
  - Deleting a user cascades their tasks; meeting history is retained (`RESTRICT`) unless explicitly deleted.

Alembic migrations will be wired in the next step after your approval.
