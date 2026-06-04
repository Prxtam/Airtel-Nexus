from __future__ import annotations

from fastapi import Depends
from sqlalchemy.orm import Session

from app.core.di.db import get_db_session
from app.infrastructure.repositories.customer_repository import SqlAlchemyCustomerRepository
from app.modules.customers.service import CustomerService


def get_customer_repository(db: Session = Depends(get_db_session)) -> SqlAlchemyCustomerRepository:
    return SqlAlchemyCustomerRepository(db)


def get_customer_service(
    db: Session = Depends(get_db_session),
    customers: SqlAlchemyCustomerRepository = Depends(get_customer_repository),
) -> CustomerService:
    return CustomerService(db=db, customers=customers)
