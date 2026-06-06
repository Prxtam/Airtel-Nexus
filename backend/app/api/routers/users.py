import uuid
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from app.core.di.auth import get_current_user, get_user_service, RequireRole
from app.core.di.rbac import get_allowed_user_ids
from app.infrastructure.db.models.user import User
from app.modules.auth.service import UserService, InvalidManagerAssignmentError
from app.modules.users.schemas import UserAdminResponse, UserManagerUpdate, UserRoleUpdate, UserStatusUpdate, UserPasswordReset

router = APIRouter(prefix="/users", tags=["users"])

def _user_to_response(user: User) -> UserAdminResponse:
    return UserAdminResponse(
        id=user.id,
        email=user.email,
        full_name=user.full_name,
        is_active=getattr(user, "is_active", True),
        manager_id=getattr(user, "manager_id", None),
        roles=[r.name for r in getattr(user, "roles", [])],
    )

@router.get(
    "",
    response_model=List[UserAdminResponse],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(RequireRole(["admin", "circle_business_head", "zonal_sales_manager"]))]
)
def list_users(
    allowed_user_ids: list[uuid.UUID] | None = Depends(get_allowed_user_ids),
    service: UserService = Depends(get_user_service)
):
    users = service.list_all()
    if allowed_user_ids is not None:
        users = [u for u in users if u.id in allowed_user_ids]
    return [_user_to_response(u) for u in users]

@router.patch(
    "/{user_id}/roles",
    response_model=UserAdminResponse,
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(RequireRole(["admin"]))]
)
def update_user_roles(
    user_id: uuid.UUID,
    role_update: UserRoleUpdate,
    service: UserService = Depends(get_user_service)
):
    try:
        user = service.assign_roles(user_id, [role_update.role])
        return _user_to_response(user)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))

@router.patch(
    "/{user_id}/manager",
    response_model=UserAdminResponse,
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(RequireRole(["admin"]))]
)
def update_user_manager(
    user_id: uuid.UUID,
    payload: UserManagerUpdate,
    service: UserService = Depends(get_user_service)
):
    try:
        user = service.assign_manager(user_id=user_id, manager_id=payload.manager_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except InvalidManagerAssignmentError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    return _user_to_response(user)

@router.patch(
    "/{user_id}/status",
    response_model=UserAdminResponse,
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(RequireRole(["admin"]))]
)
def update_user_status(
    user_id: uuid.UUID,
    status_update: UserStatusUpdate,
    service: UserService = Depends(get_user_service)
):
    try:
        user = service.update_status(user_id, status_update.is_active)
        return _user_to_response(user)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))

@router.post(
    "/{user_id}/reset-password",
    response_model=UserAdminResponse,
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(RequireRole(["admin"]))]
)
def reset_user_password(
    user_id: uuid.UUID,
    reset_update: UserPasswordReset,
    service: UserService = Depends(get_user_service)
):
    try:
        user = service.reset_password(user_id, reset_update.new_password)
        return _user_to_response(user)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
