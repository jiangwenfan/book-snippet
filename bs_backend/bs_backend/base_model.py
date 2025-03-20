from django.db import models


class BaseModel(models.Model):

    created_dt = models.DateTimeField(auto_now_add=True)
    updated_dt = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True
