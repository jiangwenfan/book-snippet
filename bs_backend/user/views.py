from rest_framework.viewsets import ModelViewSet
from user.models import User
from user.serializers import UserSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from google.oauth2 import id_token
from google.auth.transport import requests
from rest_framework.exceptions import ValidationError
from django.conf import settings
import logging


class UserViewSet(ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    @action(
        detail=False,
        methods=["get"],
        url_path="login-oauth2-google",
    )
    def login_oauth2_google(self, request):
        """用户通过google登录的回调接口"""
        google_id_token = request.query_params.get("google_id_token")
        if not google_id_token:
            logging.warning(f"google code不能为空,google_id_token: ${google_id_token}")
            raise ValidationError("google id_token 不能为空")

        # 解析、验证google id token
        try:
            google_info = id_token.verify_oauth2_token(
                id_token, requests.Request(), settings.GOOGLE_CLIENT_ID
            )
        except ValueError as e:
            logging.warning(f"google id_token验证失败 [格式错误、过期]: ${e}")
            raise ValidationError("google id_token验证失败[格式错误、过期]")
        else:
            logging.info(f"google_info: ${google_info}")

            # 获取到解析的值
            email = google_info["email"]
            name = google_info.get("name", "")
            avatar_url = google_info.get("picture", "")

            # 保存用户信息
            user, _ = User.objects.update_or_create(
                email=email,
                defaults={
                    "username": name,
                    "avatar": avatar_url,
                },
            )

            # 生成用户token
            from rest_framework_simplejwt.tokens import AccessToken, RefreshToken

            refresh_token: RefreshToken = RefreshToken.for_user(user)
            refresh_token["user_name"] = user.username
            access_token: AccessToken = refresh_token.access_token
            token: str = str(access_token)
            return {"token": token}
