# Alembic migrations

Alembic is configured to:
- Load the database URL from Pydantic settings (`app.core.config.settings`)
- Autogenerate migrations from `Base.metadata`

Expected commands (later, once requirements + venv are ready):
- `alembic revision --autogenerate -m "init"`
- `alembic upgrade head`

Run Alembic from the `backend/` directory so imports resolve correctly.
