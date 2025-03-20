from rest_framework.viewsets import ModelViewSet
from snippet.models import Snippet, Category, SnippetLabel
from snippet.serializers import (
    SnippetSerializer,
    CategorySerializer,
    SnippetLabelSerializer,
)
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter
from django_filters.rest_framework import FilterSet, CharFilter
import logging


class SnippetFilter(FilterSet):
    category = CharFilter(field_name="category__id", lookup_expr="icontains")

    labels = CharFilter(field_name="labels", method="filter_by_dtags")

    def filter_by_dtags(self, queryset, name, value):
        before_count = queryset.count()

        labels_list = value.split(",")
        labels_queryset = SnippetLabel.objects.filter(name__in=labels_list)
        # if ditags_queryset.count() != len(labels_list):
        #     logging.info(
        #         f"根据dtags查询数据集时，部分tag不存在，输入dtags数量：{len(labels_list)}，存在tag数量：{ditags_queryset.count()},将以实际找到的tag为准"
        #     )
        for label in labels_queryset:
            queryset = queryset.filter(labels=label)

        logging.info(
            f"实际过滤的dtags: {labels_queryset.values_list('name', flat=True)},过滤前数量:{before_count},过滤后数量：{queryset.count()}"
        )

        return queryset

    class Meta:
        model = Snippet
        fields = ["category", "labels"]


class SnippetViewSet(ModelViewSet):
    queryset = Snippet.objects.all()
    serializer_class = SnippetSerializer
    filter_backends = [DjangoFilterBackend]
    # filterset_fields = ["category"]
    filterset_class = SnippetFilter


class CategoryViewSet(ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


class SnippetLabelViewSet(ModelViewSet):
    queryset = SnippetLabel.objects.all()
    serializer_class = SnippetLabelSerializer
