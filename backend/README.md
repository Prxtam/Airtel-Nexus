# Airtel B2B Sales Assistant (Backend)

Phase 1 scope (backend):
- Authentication (JWT)
- Task Management
- Meeting Notes

This repository is structured as enterprise-style modules (routers/services/repositories/models/schemas).

## Project layout (high-level)
- `app/api` — FastAPI routers + request/response schemas
- `app/modules` — feature modules (auth, tasks, meetings)
- `app/infrastructure` — database + repository implementations
- `app/core` — configuration, security, logging, dependency injection

> Note: In this commit/step we only scaffold structure and database models. API routes/services/auth will be added after approval.
