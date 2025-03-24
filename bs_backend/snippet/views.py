from rest_framework.viewsets import ModelViewSet
from snippet.models import Snippet, Category, SnippetLabel
from snippet.serializers import (
    SnippetSerializer,
    CategorySerializer,
    SnippetLabelSerializer,
)
from django_filters.rest_framework import DjangoFilterBackend

# from rest_framework.filters import SearchFilter
from django_filters.rest_framework import FilterSet, CharFilter
import logging
from snippet.tasks import delete_data_to_es_task
from bs_backend.utils import ESClient


class SnippetFilter(FilterSet):
    category = CharFilter(field_name="category__id", lookup_expr="icontains")
    labels = CharFilter(field_name="labels", method="filter_by_labels")
    search = CharFilter(field_name="text", method="filter_by_search")

    def filter_by_labels(self, queryset, name, value):
        """根据labels过滤,多个labels是and的关系"""
        before_count = queryset.count()

        labels_list = value.split(",")
        labels_queryset = SnippetLabel.objects.filter(name__in=labels_list)

        for label in labels_queryset:
            queryset = queryset.filter(labels=label)

        labels = list(labels_queryset.values_list("name", flat=True))
        logging.info(
            f"过滤前数量:{before_count},过滤后数量：{queryset.count()}, 实际参与过滤:{labels}"
        )

        return queryset

    def filter_by_search(self, queryset, name, value):
        """全文本搜索"""
        user_id = self.request.user.id
        es = ESClient()

        logging.info(f"搜索 user_id:{user_id}, text_key:{value}")
        res = es.search_text_data(user_id=user_id, text_key=value)
        # print("res", res)
        ids = [item["id"] for item in res]
        queryset = queryset.filter(id__in=ids)
        return queryset

    class Meta:
        model = Snippet
        fields = ["category", "labels"]


class SnippetViewSet(ModelViewSet):
    serializer_class = SnippetSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = SnippetFilter

    def get_queryset(self):
        return Snippet.objects.filter(owner=self.request.user)

    def perform_destroy(self, instance):
        ins = super().perform_destroy(instance)
        # 删除es
        delete_data_to_es_task.delay(instance.id)
        return ins


class CategoryViewSet(ModelViewSet):
    serializer_class = CategorySerializer

    def get_queryset(self):
        return Category.objects.filter(owner=self.request.user)


class SnippetLabelViewSet(ModelViewSet):
    serializer_class = SnippetLabelSerializer

    def get_queryset(self):
        return SnippetLabel.objects.filter(owner=self.request.user)
