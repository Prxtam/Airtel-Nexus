from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends, HTTPException, status

from app.core.di.auth import get_current_user
from app.core.di.customers import get_customer_service
from app.infrastructure.db.models.user import User
from app.modules.customers.schemas import (
    CustomerCreateRequest,
    CustomerListResponse,
    CustomerResponse,
    CustomerUpdateRequest,
)
from app.modules.customers.service import CustomerAlreadyExistsError, CustomerNotFoundError, CustomerService

router = APIRouter(prefix="/customers", tags=["customers"])


def _customer_to_response(customer) -> CustomerResponse:
    return CustomerResponse(
        id=customer.id,
        name=customer.name,
        created_at=customer.created_at,
        updated_at=customer.updated_at,
    )


@router.post(
    "",
    response_model=CustomerResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_customer(
    payload: CustomerCreateRequest,
    current_user: User = Depends(get_current_user),
    service: CustomerService = Depends(get_customer_service),
) -> CustomerResponse:
    try:
        customer = service.create_customer(name=payload.name)
    except CustomerAlreadyExistsError as exc:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(exc))

    return _customer_to_response(customer)


@router.get(
    "",
    response_model=CustomerListResponse,
    status_code=status.HTTP_200_OK,
)
def list_customers(
    current_user: User = Depends(get_current_user),
    service: CustomerService = Depends(get_customer_service),
) -> CustomerListResponse:
    customers = service.list_customers()
    items = [_customer_to_response(c) for c in customers]
    return CustomerListResponse(customers=items, count=len(items))


@router.get(
    "/{customer_id}",
    response_model=CustomerResponse,
    status_code=status.HTTP_200_OK,
)
def get_customer(
    customer_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: CustomerService = Depends(get_customer_service),
) -> CustomerResponse:
    try:
        customer = service.get_customer(customer_id=customer_id)
    except CustomerNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")

    return _customer_to_response(customer)


@router.patch(
    "/{customer_id}",
    response_model=CustomerResponse,
    status_code=status.HTTP_200_OK,
)
def update_customer(
    customer_id: uuid.UUID,
    payload: CustomerUpdateRequest,
    current_user: User = Depends(get_current_user),
    service: CustomerService = Depends(get_customer_service),
) -> CustomerResponse:
    try:
        customer = service.update_customer(customer_id=customer_id, name=payload.name)
    except CustomerNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")
    except CustomerAlreadyExistsError as exc:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(exc))

    return _customer_to_response(customer)


@router.delete(
    "/{customer_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_customer(
    customer_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: CustomerService = Depends(get_customer_service),
) -> None:
    try:
        service.delete_customer(customer_id=customer_id)
    except CustomerNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")
