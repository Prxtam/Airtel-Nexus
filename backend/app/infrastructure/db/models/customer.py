from __future__ import annotations

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.infrastructure.db.base import Base
from app.infrastructure.db.models.mixins import TimestampMixin, UUIDPrimaryKeyMixin


class Customer(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "customers"

    name: Mapped[str] = mapped_column(String(250), nullable=False, unique=True, index=True)

    meetings = relationship(
        "Meeting",
        back_populates="customer",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )
