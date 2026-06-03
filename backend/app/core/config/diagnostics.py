from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from dotenv import dotenv_values

from app.core.config.settings import Settings


@dataclass(frozen=True)
class SettingResolution:
    key: str
    value: str
    source: str  # "os_env" | "dotenv:<path>" | "default" | "unknown"


def _resolve_env_file_paths(env_files: Iterable[str]) -> list[Path]:
    cwd = Path(os.getcwd())
    resolved: list[Path] = []
    for env_file in env_files:
        candidate = (cwd / env_file).resolve()
        resolved.append(candidate)
    return resolved


def resolve_postgres_setting_sources(settings: Settings) -> dict[str, SettingResolution]:
    """Best-effort resolution of where postgres settings came from.

    Pydantic-settings precedence is generally OS environment > dotenv file(s) > defaults.
    This function reports which source *likely* provided each key by checking:
    - `os.environ`
    - contents of configured dotenv files (first match wins)
    - otherwise assumes defaults

    It does not log sensitive values (password is not included here).
    """

    env_files = settings.model_config.get("env_file") or ()
    if isinstance(env_files, str):
        env_files = (env_files,)

    env_paths = _resolve_env_file_paths(env_files)
    dotenv_maps: list[tuple[Path, dict[str, str | None]]] = []
    for path in env_paths:
        if path.exists() and path.is_file():
            dotenv_maps.append((path, dotenv_values(path)))

    def source_for(key: str) -> str:
        if key in os.environ:
            return "os_env"
        for path, values in dotenv_maps:
            if key in values and values.get(key) is not None:
                return f"dotenv:{path}"
        return "default"

    resolved: dict[str, SettingResolution] = {}

    resolved["POSTGRES_HOST"] = SettingResolution(
        key="POSTGRES_HOST",
        value=settings.postgres_host,
        source=source_for("POSTGRES_HOST"),
    )
    resolved["POSTGRES_PORT"] = SettingResolution(
        key="POSTGRES_PORT",
        value=str(settings.postgres_port),
        source=source_for("POSTGRES_PORT"),
    )
    resolved["POSTGRES_DB"] = SettingResolution(
        key="POSTGRES_DB",
        value=settings.postgres_db,
        source=source_for("POSTGRES_DB"),
    )
    resolved["POSTGRES_USER"] = SettingResolution(
        key="POSTGRES_USER",
        value=settings.postgres_user,
        source=source_for("POSTGRES_USER"),
    )

    # Optional but helpful: show where password was sourced from without printing it.
    resolved["POSTGRES_PASSWORD"] = SettingResolution(
        key="POSTGRES_PASSWORD",
        value="***",
        source=source_for("POSTGRES_PASSWORD"),
    )

    return resolved


def env_file_diagnostics(settings: Settings) -> dict[str, object]:
    """Return which dotenv files were configured and which exist."""

    env_files = settings.model_config.get("env_file") or ()
    if isinstance(env_files, str):
        env_files = (env_files,)

    env_paths = _resolve_env_file_paths(env_files)

    return {
        "cwd": str(Path(os.getcwd()).resolve()),
        "configured_env_files": list(env_files),
        "resolved_env_paths": [str(p) for p in env_paths],
        "existing_env_paths": [str(p) for p in env_paths if p.exists() and p.is_file()],
    }
