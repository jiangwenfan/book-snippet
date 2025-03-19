from django.contrib import admin
from django.urls import include, path
from rest_framework import routers


router = routers.DefaultRouter()

# TODO 注册路由
# router.register(r'users', UserViewSet)


urlpatterns = [
    path("", include(router.urls)),
    path("admin/", admin.site.urls),
    path("api-auth/", include("rest_framework.urls", namespace="rest_framework")),
]
