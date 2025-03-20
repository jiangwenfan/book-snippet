from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.settings import api_settings
from rest_framework_simplejwt.exceptions import AuthenticationFailed, InvalidToken
import logging
from user.models import User


class BSJWTAuthentication(JWTAuthentication):
    def get_user(self, validated_token):
        """
        Attempts to find and return a user using the given validated token.
        """
        try:
            user_id = validated_token[api_settings.USER_ID_CLAIM]
            # user_id
            logging.error(f"----u:{api_settings.USER_ID_CLAIM} user_id: {user_id}")
        except KeyError:
            raise InvalidToken("Token contained no recognizable user identification")

        try:
            # print(f"-- {{api_settings.USER_ID_FIELD: user_id}}")
            # user = self.user_model.objects.get(**{api_settings.USER_ID_FIELD: user_id})
            # user = self.user_model.objects.get(**{"id": user_id})
            user = User.objects.get(**{"id": user_id})
        except self.user_model.DoesNotExist:
            raise AuthenticationFailed("User not found", code="user_not_found")

        # if not user.is_active:
        #     raise AuthenticationFailed("User is inactive", code="user_inactive")

        return user
