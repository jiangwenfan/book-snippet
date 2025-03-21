from django.db import models
from bs_backend.base_model import BaseModel
from pydantic import BaseModel as PydanticBaseModel


class Snippet(BaseModel):
    """片段"""

    text = models.TextField()
    labels = models.ManyToManyField("SnippetLabel", related_name="snippets")
    category = models.ForeignKey(
        "Category",
        related_name="snippets",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )

    owner = models.ForeignKey(
        "user.User",
        on_delete=models.SET_NULL,
        related_name="snippets",
        null=True,
        blank=True,
    )
    # 创建者
    created_user = models.ForeignKey(
        "user.User",
        related_name="created_snippets",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )

    class Meta:
        db_table = "snippet"
        ordering = ["-id"]

    def __str__(self):
        return f"{self.title} - {self.language}"


class Category(BaseModel):
    """分类"""

    name = models.CharField(max_length=50)
    # 删除用户时，删除自己名下的分类
    owner = models.ForeignKey(
        "user.User",
        related_name="categories",
        on_delete=models.CASCADE,
    )

    class Meta:
        db_table = "snippet_category"
        ordering = ["-id"]

    def __str__(self):
        return self.name


class SnippetLabel(BaseModel):
    """片段标签"""

    name = models.CharField(max_length=50)
    # 删除用户时，删除自己名下的标签
    owner = models.ForeignKey(
        "user.User",
        related_name="labels",
        on_delete=models.CASCADE,
    )

    class Meta:
        db_table = "snippet_label"
        ordering = ["-id"]

    def __str__(self):
        return self.name


class ESDataModel(PydanticBaseModel):
    """ES数据模型"""

    id: str
    title: str
    content: str
    category: str
    labels: list[str]
    created_user: str
    created_time: str
    updated_time: str
