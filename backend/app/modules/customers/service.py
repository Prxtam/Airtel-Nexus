from __future__ import annotations

import uuid

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.infrastructure.db.models.customer import Customer
from app.modules.customers.repository import CustomerRepository
from app.core.di.rbac import is_in_rbac_scope


class CustomerNotFoundError(Exception):
    pass


class CustomerAlreadyExistsError(Exception):
    pass


class CustomerService:
    def __init__(self, db: Session, customers: CustomerRepository):
        self._db = db
        self._customers = customers

    def create_customer(self, *, name: str, owner_id: uuid.UUID | None = None) -> Customer:
        existing = self._customers.get_by_name(name.strip())
        if existing is not None:
            raise CustomerAlreadyExistsError("Customer with this name already exists")

        try:
            customer = self._customers.create_customer(name=name.strip(), owner_id=owner_id)
            self._db.commit()
            self._db.refresh(customer)
            return customer
        except IntegrityError:
            self._db.rollback()
            raise CustomerAlreadyExistsError("Customer with this name already exists")

    def list_customers(self, allowed_user_ids: list[uuid.UUID] | None = None) -> list[Customer]:
        return self._customers.list_scoped(allowed_user_ids)

    def get_customer(self, *, customer_id: uuid.UUID, allowed_user_ids: list[uuid.UUID] | None) -> Customer:
        customer = self._customers.get_by_id(customer_id)
        if customer is None or not is_in_rbac_scope(customer.owner_id, allowed_user_ids):
            raise CustomerNotFoundError("Customer not found")
        return customer

    def update_customer(self, *, customer_id: uuid.UUID, allowed_user_ids: list[uuid.UUID] | None, name: str | None) -> Customer:
        customer = self._customers.get_by_id(customer_id)
        if customer is None or not is_in_rbac_scope(customer.owner_id, allowed_user_ids):
            raise CustomerNotFoundError("Customer not found")

        if name is not None:
            stripped = name.strip()
            existing = self._customers.get_by_name(stripped)
            if existing is not None and existing.id != customer_id:
                raise CustomerAlreadyExistsError("Customer with this name already exists")
            customer.name = stripped

        self._db.commit()
        self._db.refresh(customer)
        return customer

    def delete_customer(self, *, customer_id: uuid.UUID, allowed_user_ids: list[uuid.UUID] | None) -> None:
        customer = self._customers.get_by_id(customer_id)
        if customer is None or not is_in_rbac_scope(customer.owner_id, allowed_user_ids):
            raise CustomerNotFoundError("Customer not found")

        self._customers.delete_customer(customer)
        self._db.commit()
