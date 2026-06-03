from __future__ import annotations

import os
import sys
from logging.config import fileConfig

from alembic import context
from sqlalchemy import create_engine, pool

# Ensure `backend/` is on sys.path so `import app...` works when running Alembic.
sys.path.insert(0, os.path.abspath(os.getcwd()))

from app.core.config import get_settings  # noqa: E402
from app.infrastructure.db.base import Base  # noqa: E402
import app.infrastructure.db.models  # noqa: F401,E402

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

settings = get_settings()
config.set_main_option("sqlalchemy.url", settings.build_database_url_masked())

target_metadata = Base.metadata


def run_migrations_offline() -> None:
    # Offline migrations don't connect; we still provide a well-formed URL string.
    url = settings.build_database_url()
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,
        compare_server_default=True,
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connectable = create_engine(
        settings.build_database_url_obj(),
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
