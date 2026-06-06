from __future__ import annotations

import uuid

from typing import Protocol

from app.infrastructure.db.models.customer import Customer


class CustomerRepository(Protocol):
    def get_by_id(self, customer_id: uuid.UUID) -> Customer | None: ...

    def get_by_name(self, name: str) -> Customer | None: ...

    def list_all(self) -> list[Customer]: ...

    def list_scoped(self, allowed_user_ids: list[uuid.UUID] | None = None) -> list[Customer]: ...

    def create_customer(self, *, name: str, owner_id: uuid.UUID | None = None) -> Customer: ...

    def delete_customer(self, customer: Customer) -> None: ...
