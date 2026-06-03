from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, status

from app.core.di.auth import get_user_service
from app.modules.auth.schemas import TokenResponse, UserLoginRequest, UserRegisterRequest, UserResponse
from app.modules.auth.service import InvalidCredentialsError, UserAlreadyExistsError, UserService

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
def register_user(payload: UserRegisterRequest, service: UserService = Depends(get_user_service)) -> UserResponse:
    try:
        user = service.register_user(
            email=payload.email,
            plain_password=payload.password,
            full_name=payload.full_name,
        )
    except UserAlreadyExistsError as exc:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(exc))

    return UserResponse(
        id=user.id,
        email=user.email,
        full_name=user.full_name,
        roles=[r.name for r in getattr(user, "roles", [])] if getattr(user, "roles", None) else [],
    )


@router.post(
    "/login",
    response_model=TokenResponse,
    status_code=status.HTTP_200_OK,
)
def login_user(payload: UserLoginRequest, service: UserService = Depends(get_user_service)) -> TokenResponse:
    try:
        token = service.authenticate_user(
            email=payload.email,
            plain_password=payload.password,
        )
    except InvalidCredentialsError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return TokenResponse(access_token=token.access_token, token_type=token.token_type)

