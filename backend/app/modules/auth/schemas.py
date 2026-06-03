from __future__ import annotations

import uuid
from datetime import datetime

from pydantic import BaseModel, Field


class UserRegisterRequest(BaseModel):
    email: str = Field(min_length=5, max_length=320)
    password: str = Field(min_length=8, max_length=128)
    full_name: str | None = Field(default=None, max_length=200)


class UserLoginRequest(BaseModel):
    email: str = Field(min_length=5, max_length=320)
    password: str = Field(min_length=1, max_length=128)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    id: uuid.UUID
    email: str
    full_name: str | None = None
    roles: list[str] = Field(default_factory=list)


class MeResponse(BaseModel):
    user: UserResponse
    server_time_utc: datetime
