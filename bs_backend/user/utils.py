from rest_framework_simplejwt.tokens import AccessToken, RefreshToken
from user.models import User
import uuid
import requests
import os
import logging
from django.conf import settings


def get_user_token(user: User) -> dict:
    """生成用户token"""
    refresh_token: RefreshToken = RefreshToken.for_user(user)
    refresh_token["user_name"] = user.username
    access_token: AccessToken = refresh_token.access_token
    token: str = str(access_token)
    return {
        "token": token,
    }


def save_image_to_local(url: str) -> str:
    """保存图片到本地，返回保存到本地的文件名
    当下载失败时，返回空字符串
    """
    local_file_name = uuid.uuid4()
    url_file_extension = os.path.splitext(url)[1]
    local_file_full_name = f"{local_file_name}{url_file_extension}"

    # 保存图片
    try:
        response = requests.get(url)
    except Exception as e:
        logging.error(f"下载图片失败，连接异常: {e}, url: {url}")
        return ""
    else:
        if response.status_code != 200:
            print(f"下载图片失败,状态异常 code: {response.status_code},url: {url}")
            return ""

        image = response.content

        write_path = os.path.join(settings.IMAGE_SAVE_PATH, local_file_full_name)
        with open(write_path, "wb") as f:
            f.write(image)

        return local_file_full_name
