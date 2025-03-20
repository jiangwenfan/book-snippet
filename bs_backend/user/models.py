from bs_backend.base_model import BaseModel
from django.db import models
from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.hashers import (
    check_password,
    is_password_usable,
    make_password,
)


class User(BaseModel):
    email = models.EmailField(null=True, blank=True)
    phone = models.CharField(max_length=15, null=True, blank=True)
    password = models.CharField(max_length=50)

    username = models.CharField(max_length=50, null=True, blank=True)
    avatar = models.CharField(
        max_length=255, help_text="头像文件名", null=True, blank=True
    )

    def __str__(self):
        return f"id:{self.pk} > {self.email}-{self.phone}"

    class Meta:
        db_table = "user"
        ordering = ["-id"]

    @property
    def full_avatar_url(self):
        return f"{settings.IMAGE_BASE_URL}{self.avatar}"

    @property
    def is_anonymous(self):
        """
        Always return False. This is a way of comparing User objects to
        anonymous users.
        """
        return False

    @property
    def is_authenticated(self):
        """
        Always return True. This is a way to tell if the user has been
        authenticated in templates.
        """
        return True

    def set_password(self, raw_password):
        self.password = make_password(raw_password)
        self._password = raw_password

    def check_password(self, raw_password):
        """
        Return a boolean of whether the raw_password was correct. Handles
        hashing formats behind the scenes.
        """

        def setter(raw_password):
            self.set_password(raw_password)
            # Password hash upgrades shouldn't be considered password changes.
            self._password = None
            self.save(update_fields=["password"])

        return check_password(raw_password, self.password, setter)
