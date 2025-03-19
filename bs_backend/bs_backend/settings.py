from pathlib import Path
from dotenv import dotenv_values, find_dotenv
import logging
import os


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
else:
    # 从环境变量中获取配置
    # MySql
    MYSQL_HOST = os.getenv("MYSQL_HOST")
    MYSQL_PORT = os.getenv("MYSQL_PORT")
    MYSQL_USER = os.getenv("MYSQL_USER")
    MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
    MYSQL_DATABASE = os.getenv("MYSQL_DATABASE")


SECRET_KEY = "django-insecure-yuf$5dp72akchmepvw1&j^y_q1jw-hste)=1f^c#!gwt*(rvcc"


DEBUG = True

ALLOWED_HOSTS = []


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
    "app1",
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
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
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
