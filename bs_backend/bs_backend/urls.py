from django.contrib import admin
from django.urls import include, path
from rest_framework import routers
from user.views import UserViewSet
from snippet.views import SnippetViewSet, CategoryViewSet, SnippetLabelViewSet


router = routers.DefaultRouter()

router.register(r"users", UserViewSet)
router.register(r"snippets", SnippetViewSet)
router.register(r"categories", CategoryViewSet)
router.register(r"labels", SnippetLabelViewSet)


urlpatterns = [
    path("", include(router.urls)),
    path("admin/", admin.site.urls),
    path("api-auth/", include("rest_framework.urls", namespace="rest_framework")),
]
