from rest_framework_simplejwt.tokens import AccessToken, RefreshToken
from user.models import User


def get_user_token(user: User) -> dict:
    """生成用户token"""
    refresh_token: RefreshToken = RefreshToken.for_user(user)
    refresh_token["user_name"] = user.username
    access_token: AccessToken = refresh_token.access_token
    token: str = str(access_token)
    return {
        "token": token,
    }
