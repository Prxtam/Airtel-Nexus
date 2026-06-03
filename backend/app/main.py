from __future__ import annotations

from contextlib import asynccontextmanager
import logging

import anyio
from fastapi import FastAPI

from app.api.routers.health import router as health_router
from app.core.config import get_settings
from app.core.config.diagnostics import env_file_diagnostics, resolve_postgres_setting_sources
from app.core.logging.setup import configure_logging
from app.infrastructure.db.health import validate_database_connectivity
from app.infrastructure.db.session import get_engine


@asynccontextmanager
async def lifespan(app: FastAPI):
    settings = get_settings()

    configure_logging(settings.debug)
    logger = logging.getLogger("app.startup")

    if settings.startup_diagnostics:
        logger.info("Startup diagnostics enabled")
        diag = env_file_diagnostics(settings)
        logger.info("Settings working directory (cwd): %s", diag["cwd"])
        logger.info("Configured env_file entries: %s", diag["configured_env_files"])
        logger.info("Resolved env_file paths: %s", diag["resolved_env_paths"])
        logger.info("Existing env_file paths: %s", diag["existing_env_paths"])

        resolved = resolve_postgres_setting_sources(settings)
        for key in ["POSTGRES_HOST", "POSTGRES_PORT", "POSTGRES_DB", "POSTGRES_USER", "POSTGRES_PASSWORD"]:
            r = resolved[key]
            logger.info("Resolved %s=%s (source=%s)", r.key, r.value, r.source)

        logger.info("Final SQLAlchemy URL (masked): %s", settings.build_database_url_masked())

    if settings.db_validate_on_startup:
        engine = get_engine()
        await anyio.to_thread.run_sync(validate_database_connectivity, engine)

    yield


def create_app() -> FastAPI:
    settings = get_settings()

    configure_logging(settings.debug)

    app = FastAPI(
        title=settings.app_name,
        debug=settings.debug,
        lifespan=lifespan,
    )

    app.include_router(health_router)

    return app


app = create_app()
