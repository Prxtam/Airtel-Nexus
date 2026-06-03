from __future__ import annotations

import bcrypt


def _to_bytes(value: str) -> bytes:
    return value.encode("utf-8")


def hash_password(plain_password: str) -> str:
    password_bytes = _to_bytes(plain_password)

    # bcrypt effectively considers only the first 72 bytes.
    # We fail fast to avoid surprising truncation behavior.
    if len(password_bytes) > 72:
        raise ValueError("Password too long for bcrypt (max 72 bytes)")

    salt = bcrypt.gensalt(rounds=12)
    hashed = bcrypt.hashpw(password_bytes, salt)
    return hashed.decode("utf-8")


def verify_password(plain_password: str, password_hash: str) -> bool:
    password_bytes = _to_bytes(plain_password)
    hash_bytes = _to_bytes(password_hash)
    return bcrypt.checkpw(password_bytes, hash_bytes)
