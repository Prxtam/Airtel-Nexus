from __future__ import annotations

from sqlalchemy import MetaData
from sqlalchemy.orm import DeclarativeBase

from app.infrastructure.db.naming_convention import NAMING_CONVENTION


class Base(DeclarativeBase):
    metadata = MetaData(naming_convention=NAMING_CONVENTION)
