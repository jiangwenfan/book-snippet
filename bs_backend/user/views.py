from rest_framework.viewsets import ModelViewSet
from user.models import User
from user.serializers import UserSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from google.oauth2 import id_token
from google.auth.transport import requests
from rest_framework.exceptions import ValidationError
from django.conf import settings
from rest_framework.permissions import AllowAny
import logging
from user.utils import get_user_token
from rest_framework.response import Response


class UserViewSet(ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    # 必须初始化请求才可以在认证之前获取action
    def initialize_request(self, request, *args, **kwargs):
        self.action = self.action_map.get(request.method.lower())
        return super().initialize_request(request, *args, **kwargs)

    def get_permissions(self):
        match self.action:
            case "login_oauth2_google" | "login":
                return [AllowAny()]
            case _:
                return super().get_permissions()

    def get_authenticators(self):
        match self.action:
            case "login_oauth2_google" | "login":
                return []
            case _:
                return super().get_authenticators()

    @action(detail=False, methods=["post"], url_path="login")
    def login(self, request):
        """仅测试用"""
        request_data = request.data
        email = request_data.get("email")
        password = request_data.get("password")

        u, _ = User.objects.get_or_create(email=email, defaults={"password": password})
        token_dict = get_user_token(u)
        return Response(token_dict)

    @action(
        detail=False,
        methods=["get"],
        url_path="login-oauth2-google",
    )
    def login_oauth2_google(self, request):
        """用户通过google登录的回调接口"""
        google_id_token = request.query_params.get("id_token")
        if not google_id_token:
            logging.warning(f"id_token 不能为空: ${google_id_token}")
            raise ValidationError("google id_token 不能为空")

        # 解析、验证google id token
        try:
            google_info = id_token.verify_oauth2_token(
                id_token, requests.Request(), settings.GOOGLE_CLIENT_ID
            )
        except ValueError as e:
            logging.warning(
                f"google id_token:{google_id_token} 验证失败 [格式错误、过期]: ${e}"
            )
            raise ValidationError(
                f"google id_token:{google_id_token} 验证失败[格式错误、过期]"
            )
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

            token_dict = get_user_token(user)
            return Response(token_dict)
