from __future__ import annotations

from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy.engine import URL, make_url


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=(".env", "../.env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    app_env: str = Field(default="local", validation_alias="APP_ENV")
    debug: bool = Field(default=False, validation_alias="APP_DEBUG")

    app_name: str = Field(default="Airtel B2B Sales Assistant", validation_alias="APP_NAME")
    api_v1_prefix: str = Field(default="/api/v1", validation_alias="API_V1_PREFIX")

    db_validate_on_startup: bool = Field(default=True, validation_alias="DB_VALIDATE_ON_STARTUP")
    startup_diagnostics: bool = Field(default=False, validation_alias="STARTUP_DIAGNOSTICS")

    jwt_secret_key: str = Field(default="change_me", validation_alias="JWT_SECRET_KEY")
    jwt_algorithm: str = Field(default="HS256", validation_alias="JWT_ALGORITHM")
    jwt_access_token_expires_minutes: int = Field(default=60, validation_alias="JWT_ACCESS_TOKEN_EXPIRES_MINUTES")

    postgres_host: str = Field(default="localhost", validation_alias="POSTGRES_HOST")
    postgres_port: int = Field(default=5432, validation_alias="POSTGRES_PORT")
    postgres_db: str = Field(default="airtel_sales_assistant", validation_alias="POSTGRES_DB")
    postgres_user: str = Field(default="airtel_app", validation_alias="POSTGRES_USER")
    postgres_password: str = Field(default="change_me", validation_alias="POSTGRES_PASSWORD")

    database_url: str | None = Field(default=None, validation_alias="DATABASE_URL")

    sqlalchemy_echo: bool = Field(default=False, validation_alias="SQLALCHEMY_ECHO")
    sqlalchemy_pool_size: int = Field(default=10, validation_alias="SQLALCHEMY_POOL_SIZE")
    sqlalchemy_max_overflow: int = Field(default=20, validation_alias="SQLALCHEMY_MAX_OVERFLOW")

    def build_database_url_obj(self) -> URL:
        """Return a SQLAlchemy URL object.

        Using a URL object avoids subtle bugs when parsing string URLs that contain
        special characters (e.g., '@' in passwords).
        """

        if self.database_url:
            return make_url(self.database_url)

        return URL.create(
            "postgresql+psycopg",
            username=self.postgres_user,
            password=self.postgres_password,
            host=self.postgres_host,
            port=self.postgres_port,
            database=self.postgres_db,
        )

    def build_database_url(self) -> str:
        return self.build_database_url_obj().render_as_string(hide_password=False)

    def build_database_url_masked(self) -> str:
        return self.build_database_url_obj().render_as_string(hide_password=True)


@lru_cache
def get_settings() -> Settings:
    return Settings()
