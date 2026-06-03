from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from typing import Any

from jose import JWTError, jwt

from app.core.config import get_settings


@dataclass(frozen=True)
class JwtToken:
    access_token: str
    token_type: str = "bearer"


def create_access_token(*, subject: str, roles: list[str] | None = None, expires_minutes: int | None = None) -> JwtToken:
    """Create a signed JWT access token.

    - `subject` is typically the user id (UUID as string).
    - `roles` is included for future RBAC support.
    """

    settings = get_settings()

    now = datetime.now(timezone.utc)
    ttl_minutes = expires_minutes if expires_minutes is not None else settings.jwt_access_token_expires_minutes
    expires_at = now + timedelta(minutes=ttl_minutes)

    payload: dict[str, Any] = {
        "sub": subject,
        "iat": int(now.timestamp()),
        "exp": int(expires_at.timestamp()),
    }

    if roles:
        payload["roles"] = roles

    token = jwt.encode(payload, settings.jwt_secret_key, algorithm=settings.jwt_algorithm)
    return JwtToken(access_token=token)


def decode_access_token(token: str) -> dict[str, Any]:
    """Decode and validate a JWT access token.

    Returns the payload dict. Raises `JWTError` on invalid/expired tokens.
    """

    settings = get_settings()
    return jwt.decode(token, settings.jwt_secret_key, algorithms=[settings.jwt_algorithm])


def try_decode_access_token(token: str) -> dict[str, Any] | None:
    """Decode token but return None instead of raising for invalid tokens."""

    try:
        return decode_access_token(token)
    except JWTError:
        return None
