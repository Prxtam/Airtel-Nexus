# Configuration

`settings.py` provides strongly-typed configuration using Pydantic v2 + pydantic-settings.

Sources (in order):
- Environment variables
- Optional `.env` file (for local development only)

Key variables:
- `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`
- `DATABASE_URL` (optional override)

The DB URL is constructed as `postgresql+psycopg://...` to use psycopg3.
