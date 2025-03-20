from snippet.models import Snippet, Category, SnippetLabel
from rest_framework.serializers import (
    ModelSerializer,
    ListField,
    CharField,
    ValidationError,
)


class SnippetSerializer(ModelSerializer):
    labels_text = ListField(child=CharField(), required=False)

    class Meta:
        model = Snippet
        fields = [
            "id",
            "text",
            "labels_text",
            "category",
            "owner",
            "created_user",
            "created_dt",
            "updated_dt",
        ]

    def validate(self, attrs):
        self.user = self.context["request"].user
        if Snippet.objects.filter(owner=self.user, text=attrs["text"]).exists():
            raise ValidationError("不能创建重复的片段")
        return super().validate(attrs)

    def create(self, validated_data):
        print(f"----: {validated_data}")

        # labels不存在则创建
        labels_text = validated_data.pop("labels_text")
        for label_text in labels_text:
            label_ins, _ = SnippetLabel.objects.get_or_create(
                owner=self.user,
                name=label_text,
            )
            validated_data["labels"].add(label_ins)

        # user
        validated_data["owner"] = self.user
        validated_data["created_user"] = self.user
        return super().create(validated_data)


class CategorySerializer(ModelSerializer):
    class Meta:
        model = Category
        fields = [
            "id",
            "name",
            "created_dt",
            "updated_dt",
        ]

    def validate(self, attrs):
        self.user = self.context["request"].user
        return super().validate(attrs)

    def create(self, validated_data):
        # user 和 name 一起唯一
        category_ins, _ = Category.objects.get_or_create(
            owner=self.user, name=validated_data["name"]
        )
        return category_ins


class SnippetLabelSerializer(ModelSerializer):
    class Meta:
        model = SnippetLabel
        fields = [
            "id",
            "name",
            "created_dt",
            "updated_dt",
        ]

    def create(self, validated_data):
        label_ins, _ = SnippetLabel.objects.get_or_create(
            owner=self.context["request"].user,
            name=validated_data["name"],
        )
        return label_ins
