from __future__ import annotations

from sqlalchemy import Engine, text


def validate_database_connectivity(engine: Engine) -> None:
    """Raise an exception if the DB is not reachable.

    This is used both at application startup (fail-fast) and by the health endpoint.
    """

    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))
