from pathlib import Path
from dotenv import dotenv_values, find_dotenv
import logging
import os
from datetime import timedelta
from bs_backend.utils import ESClient

import sentry_sdk


BASE_DIR = Path(__file__).resolve().parent.parent


logging.basicConfig(level=logging.INFO)

# 使用compose的.env文件
env_path = os.path.join(BASE_DIR.parent, ".env")
if find_dotenv(env_path):
    # 从当前.env文件中获取配置
    logging.warning("-----[仅开发]-从.env文件中读取配置-----------")
    env_values = dotenv_values(env_path)
    # MySql
    MYSQL_HOST = env_values.get("MYSQL_HOST")
    MYSQL_PORT = env_values.get("MYSQL_PORT")
    MYSQL_USER = env_values.get("MYSQL_USER")
    MYSQL_PASSWORD = env_values.get("MYSQL_PASSWORD")
    MYSQL_DATABASE = env_values.get("MYSQL_DATABASE")
    # redis
    REDIS_HOST = env_values.get("REDIS_HOST")
    REDIS_PORT = env_values.get("REDIS_PORT")
    REDIS_DB_CELERY = env_values.get("REDIS_DB_CELERY")
    # es
    ES_HOST = env_values.get("ES_HOST")
    ES_PORT = env_values.get("ES_PORT")
    ES_USER = env_values.get("ES_USER")
    ES_PASSWORD = env_values.get("ES_PASSWORD")
    ES_INDEX_NAME = env_values.get("ES_INDEX_NAME")
    # google
    GOOGLE_CLIENT_ID = env_values.get("GOOGLE_CLIENT_ID")
    # url
    IMAGE_BASE_URL = env_values.get("IMAGE_BASE_URL")
    # sentry
    sentry_dsn = env_values.get("SENTRY_DSN")
    DEBUG: bool = env_values.get("DEBUG") == "True"
else:
    # 从环境变量中获取配置
    # MySql
    MYSQL_HOST = os.getenv("MYSQL_HOST")
    MYSQL_PORT = os.getenv("MYSQL_PORT")
    MYSQL_USER = os.getenv("MYSQL_USER")
    MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
    MYSQL_DATABASE = os.getenv("MYSQL_DATABASE")
    # redis
    REDIS_HOST = os.getenv("REDIS_HOST")
    REDIS_PORT = os.getenv("REDIS_PORT")
    REDIS_DB_CELERY = os.getenv("REDIS_DB_CELERY")
    # es
    ES_HOST = os.getenv("ES_HOST")
    ES_PORT = os.getenv("ES_PORT")
    ES_USER = os.getenv("ES_USER")
    ES_PASSWORD = os.getenv("ES_PASSWORD")
    ES_INDEX_NAME = os.getenv("ES_INDEX_NAME")
    # google
    GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")
    # url
    IMAGE_BASE_URL = os.getenv("IMAGE_BASE_URL")
    # sentry
    sentry_dsn = os.getenv("SENTRY_DSN")
    DEBUG: bool = os.getenv("DEBUG") == "True"


SECRET_KEY = "django-insecure-yuf$5dp72akchmepvw1&j^y_q1jw-hste)=1f^c#!gwt*(rvcc"


DEBUG = True

ALLOWED_HOSTS = ["*"]

# 图片存储路径
IMAGE_SAVE_PATH = os.path.join(BASE_DIR, "images")
if not os.path.exists(IMAGE_SAVE_PATH):
    os.makedirs(IMAGE_SAVE_PATH)

es = ESClient()
# check es
es.check_es()
# init es index
es.create_index()

# sentry
if not DEBUG:
    sentry_sdk.init(
        dsn=sentry_dsn,
        # Add data like request headers and IP for users,
        # see https://docs.sentry.io/platforms/python/data-management/data-collected/ for more info
        send_default_pii=True,
    )

# AUTH_USER_MODEL = "user.User"

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",  # rest_framework app
    "django_filters",  # filter app
    "corsheaders",  # cors app
    "django_extensions",  # execute app
    "snippet",
    "user",
]

# 数据库配置
if MYSQL_HOST:
    db_config = {
        "ENGINE": "django.db.backends.mysql",
        "NAME": MYSQL_DATABASE,
        "USER": MYSQL_USER,
        "PASSWORD": MYSQL_PASSWORD,
        "HOST": MYSQL_HOST,
        "PORT": MYSQL_PORT,
    }
else:
    logging.warning("-----[仅开发]-使用sqlite3数据库-----------")
    db_config = {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "my-data.sqlite3",
    }

DATABASES = {
    "default": db_config,
}

# rest配置
REST_FRAMEWORK = {
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
    "DEFAULT_AUTHENTICATION_CLASSES": (
        # "rest_framework_simplejwt.authentication.JWTAuthentication",
        "bs_backend.authentication.BSJWTAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticated",
    ],
}
SIMPLE_JWT = {
    # It will work instead of the default serializer(TokenObtainPairSerializer).
    # "TOKEN_OBTAIN_SERIALIZER": "rest_framework_simplejwt.serializers.MyTokenObtainPairSerializer",
    "ACCESS_TOKEN_LIFETIME": timedelta(days=30),
    # "SIGNING_KEY": SIGN_KEY,
}

# cors配置
CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True
CORS_ALLOW_HEADERS = "*"

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "corsheaders.middleware.CorsMiddleware",  # 跨域中间件
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "bs_backend.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "bs_backend.wsgi.application"


AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


STATIC_URL = "static/"


DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
