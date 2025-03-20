from bs_backend.base_model import BaseModel
from django.db import models
from django.conf import settings


class User(BaseModel):
    email = models.EmailField()
    phone = models.CharField(max_length=15)
    password = models.CharField(max_length=50)

    username = models.CharField(max_length=50)
    avatar = models.CharField(max_length=255, help_text="头像文件名")

    def __str__(self):
        return f"id:{self.pk} > {self.email}-{self.phone}"

    class Meta:
        db_table = "user"
        ordering = ["-id"]

    @property
    def full_avatar_url(self):
        return f"{settings.IMAGE_BASE_URL}{self.avatar}"
