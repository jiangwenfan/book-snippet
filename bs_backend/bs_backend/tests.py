from rest_framework.test import APITestCase
from user.models import User
from snippet.models import Snippet, SnippetLabel, Category
import json
import urllib.parse


class AppTestCase(APITestCase):
    def format_output_json(self, data):
        """格式化输出json"""
        print(json.dumps(data, ensure_ascii=False, indent=2))

    def get_request_full_path(self, response):
        """获取请求的完整路径"""
        url = response.wsgi_request.build_absolute_uri()
        decoded_url = urllib.parse.unquote(url)

        print("请求路径:", decoded_url)

    def setUp(self):
        # 初始化 email用户
        self.email_user = "abc@123.com"
        self.email_user_password = "123456"
        self.e_user = User.objects.create_email_user(
            email=self.email_user, raw_password=self.email_user_password
        )

        # 初始化 phone用户
        self.phone_user = "12345678901"
        self.phone_user_password = "123456"
        self.p_user = User.objects.create_phone_user(
            phone=self.phone_user, raw_password=self.phone_user_password
        )

        # 初始化分类
        self.category_name = "测试分类1"
        self.category = Category.objects.create(
            name=self.category_name, owner=self.e_user
        )
        self.category_name2 = "测试分类2"
        self.category2 = Category.objects.create(
            name=self.category_name2, owner=self.p_user
        )

        # 初始化标签
        self.label_name = "测试标签1"
        self.label = SnippetLabel.objects.create(
            name=self.label_name, owner=self.e_user
        )
        self.label_name2 = "测试标签2"
        self.label2 = SnippetLabel.objects.create(
            name=self.label_name2, owner=self.p_user
        )

        # 初始化片段
        self.text = "测试片段1"
        self.snippet = Snippet.objects.create(
            text=self.text,
            category=self.category,
            owner=self.e_user,
            created_user=self.e_user,
        )
        self.snippet.labels.add(self.label)

        self.text2 = "测试片段2"
        self.snippet2 = Snippet.objects.create(
            text=self.text2,
            category=self.category2,
            owner=self.p_user,
            created_user=self.p_user,
        )
        self.snippet2.labels.add(self.label2)
