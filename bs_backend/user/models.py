from bs_backend.base_model import BaseModel
from django.db import models
from django.conf import settings
from django.contrib.auth.hashers import (
    check_password,
    make_password,
)
from django.contrib.auth.models import AbstractUser, UserManager


class MyUserManager(UserManager):
    def create_phone_user(
        self, phone: str, raw_password: str, username: str | None = None
    ):
        """phone用户注册"""
        # 生成用户名
        if not username:
            username = phone

        # 生成密码
        password = make_password(raw_password)

        user = User.objects.create(phone=phone, password=password, username=username)
        return user

    def create_email_user(
        self, email: str, raw_password: str, username: str | None = None
    ):
        """email用户注册"""
        # 生成用户名
        if not username:
            username = email

        # 生成密码
        password = make_password(raw_password)

        user = User.objects.create(email=email, password=password, username=username)
        return user


class User(BaseModel):
    email = models.EmailField(null=True, blank=True)
    phone = models.CharField(max_length=15, null=True, blank=True)
    password = models.CharField(max_length=200)

    username = models.CharField(max_length=50)
    avatar = models.CharField(
        max_length=255, help_text="头像文件名", null=True, blank=True
    )

    def __str__(self):
        return f"id:{self.pk} > {self.email}-{self.phone}"

    @property
    def full_avatar_url(self):
        return f"{settings.IMAGE_BASE_URL}{self.avatar}"

    objects = MyUserManager()

    class Meta:
        db_table = "user"
        ordering = ["-id"]

    @property
    def is_anonymous(self):
        return False

    @property
    def is_authenticated(self):
        return True

    def check_password(self, raw_password) -> bool:
        def setter(raw_password):
            self.set_password(raw_password)
            # Password hash upgrades shouldn't be considered password changes.
            self._password = None
            self.save(update_fields=["password"])

        return check_password(raw_password, self.password, setter)
