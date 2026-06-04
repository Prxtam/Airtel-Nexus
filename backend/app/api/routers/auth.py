from __future__ import annotations

from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm

from app.core.di.auth import get_current_user, get_user_service
from app.infrastructure.db.models.user import User
from app.modules.auth.schemas import MeResponse, TokenResponse, UserLoginRequest, UserRegisterRequest, UserResponse
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


@router.post(
    "/token",
    response_model=TokenResponse,
    status_code=status.HTTP_200_OK,
    summary="OAuth2-compatible token (for Swagger Authorize)",
    include_in_schema=False,
)
def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    service: UserService = Depends(get_user_service),
) -> TokenResponse:
    """Accept OAuth2 form fields (username + password) so Swagger's
    Authorize dialog works natively. Maps 'username' → 'email'."""
    try:
        token = service.authenticate_user(
            email=form_data.username,
            plain_password=form_data.password,
        )
    except InvalidCredentialsError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return TokenResponse(access_token=token.access_token, token_type=token.token_type)


@router.get(
    "/me",
    response_model=MeResponse,
    status_code=status.HTTP_200_OK,
)
def get_me(current_user: User = Depends(get_current_user)) -> MeResponse:
    return MeResponse(
        user=UserResponse(
            id=current_user.id,
            email=current_user.email,
            full_name=current_user.full_name,
            roles=[r.name for r in current_user.roles] if current_user.roles else [],
        ),
        server_time_utc=datetime.now(timezone.utc),
    )


