from __future__ import annotations

import uuid

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.infrastructure.db.models.customer import Customer


class SqlAlchemyCustomerRepository:
    def __init__(self, db: Session):
        self._db = db

    def get_by_id(self, customer_id: uuid.UUID) -> Customer | None:
        return self._db.get(Customer, customer_id)

    def get_by_name(self, name: str) -> Customer | None:
        stmt = select(Customer).where(Customer.name == name)
        return self._db.execute(stmt).scalar_one_or_none()

    def list_all(self) -> list[Customer]:
        stmt = select(Customer).order_by(Customer.name.asc())
        return list(self._db.execute(stmt).scalars().all())

    def list_scoped(self, allowed_user_ids: list[uuid.UUID] | None = None) -> list[Customer]:
        stmt = select(Customer)
        if allowed_user_ids is not None:
            stmt = stmt.where(Customer.owner_id.in_(allowed_user_ids))
        stmt = stmt.order_by(Customer.name.asc())
        return list(self._db.execute(stmt).scalars().all())

    def create_customer(self, *, name: str, owner_id: uuid.UUID | None = None) -> Customer:
        customer = Customer(name=name, owner_id=owner_id)
        self._db.add(customer)
        self._db.flush()
        return customer

    def delete_customer(self, customer: Customer) -> None:
        self._db.delete(customer)
        self._db.flush()
