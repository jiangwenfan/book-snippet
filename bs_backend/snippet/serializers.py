from snippet.models import Snippet, Category, SnippetLabel
from rest_framework.serializers import (
    ModelSerializer,
    ListField,
    CharField,
    ValidationError,
    ManyRelatedField,
    SerializerMethodField,
)
from snippet.models import ESDataModel
from snippet.tasks import insert_data_to_es_task, update_data_to_es_task


class MyListField(ListField):
    def to_representation(self, value):
        # print("----value", value, type(value))
        # 因为多对多不能直接序列化，所以这里返回空列表，跳过
        # super().to_representation(value)
        return []


class SnippetSerializer(ModelSerializer):
    labels = MyListField(child=CharField())

    class Meta:
        model = Snippet
        fields = [
            "id",
            "text",
            "labels",
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
        # print(f"----: {validated_data}")

        # labels不存在则创建
        labels_text = validated_data.pop("labels")

        # user
        validated_data["owner"] = self.user
        validated_data["created_user"] = self.user
        ins = super().create(validated_data)

        # 添加标签关系
        for label_text in labels_text:
            label_ins, _ = SnippetLabel.objects.get_or_create(
                owner=self.user,
                name=label_text,
            )
            ins.labels.add(label_ins)

        # 保存到es
        es_data = ESDataModel(
            id=ins.id,
            text=ins.text,
            category=ins.category.name,
            labels=[label.name for label in ins.labels.all()],
            owner_id=ins.owner.id,
        )
        # print("-----", es_data, es_data.model_dump(), type(es_data.model_dump()))
        insert_data_to_es_task.delay(es_data.model_dump())
        return ins

    def update(self, instance, validated_data):
        ins = super().update(instance, validated_data)
        # 更新到es
        update_data_to_es_task.delay(validated_data)
        return ins

    def to_representation(self, instance):
        res = super().to_representation(instance)
        res["labels"] = [label.name for label in instance.labels.all()]
        res["category"] = instance.category.name
        return res


class CategorySerializer(ModelSerializer):
    count = SerializerMethodField()

    class Meta:
        model = Category
        fields = [
            "id",
            "name",
            "owner",
            "created_dt",
            "updated_dt",
            "count",
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

    def get_count(self, obj):
        """获取分类下的片段数量"""
        return obj.snippets.count()


class SnippetLabelSerializer(ModelSerializer):
    count = SerializerMethodField()

    class Meta:
        model = SnippetLabel
        fields = [
            "id",
            "name",
            "owner",
            "created_dt",
            "updated_dt",
            "count",
        ]

    def create(self, validated_data):
        label_ins, _ = SnippetLabel.objects.get_or_create(
            owner=self.context["request"].user,
            name=validated_data["name"],
        )
        return label_ins

    def get_count(self, obj):
        """获取标签下的片段数量"""
        return obj.snippets.count()
