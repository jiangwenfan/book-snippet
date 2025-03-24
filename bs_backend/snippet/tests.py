from bs_backend.tests import AppTestCase
from django.urls import reverse
from snippet.models import Category, Snippet, SnippetLabel
from unittest.mock import patch


class SnippetTestCase(AppTestCase):
    def test_list_snippet(self):
        """获取该用户的 所有片段列表"""
        self.client.force_authenticate(user=self.e_user)
        response = self.client.get(reverse("snippet-list"))
        res = response.json()
        # self.format_output_json(res)

        self.assertEqual(response.status_code, 200)
        # 断言 输出的都是该用户的片段
        snippets_id = [item["owner"] for item in res["results"]]
        self.assertEqual(set(snippets_id), set([self.e_user.pk]))
        self.assertEqual(response.json()["count"], 1)

    def test_list_snippet_by_category(self):
        """获取该用户的 某个分类下的片段列表"""
        self.client.force_authenticate(user=self.e_user)

        # 增加另一个分类的片段
        Snippet.objects.create(
            text="测试片段222",
            category=self.category2,
            owner=self.e_user,
            created_user=self.e_user,
        )

        response1 = self.client.get(reverse("snippet-list"))
        res1 = response1.json()
        # self.get_request_full_path(response1)
        # self.format_output_json(res1)
        self.assertEqual(res1["count"], 2)

        response2 = self.client.get(
            reverse("snippet-list"), {"category": self.category.pk}
        )
        res = response2.json()
        # self.get_request_full_path(response2)
        # self.format_output_json(res)
        self.assertEqual(response2.status_code, 200)
        self.assertEqual(res["count"], 1)

        # 断言 输出的都是该分类的片段
        self.assertEqual(res["results"][0]["category"], self.category.name)

    def test_list_snippet_by_labels(self):
        """获取该用户的 某个标签下的片段列表"""
        self.client.force_authenticate(user=self.e_user)

        snippet3 = Snippet.objects.create(
            text="测试片段3",
            category=self.category2,
            owner=self.e_user,
            created_user=self.e_user,
        )
        label3 = SnippetLabel.objects.create(name="测试标签3", owner=self.e_user)
        snippet3.labels.add(label3)
        # 额外增加一个标签1
        snippet3.labels.add(self.label)

        # 1. 直接搜索期望是2个
        response1 = self.client.get(reverse("snippet-list"))
        res1 = response1.json()
        # self.get_request_full_path(response1)
        # self.format_output_json(res1)

        self.assertEqual(res1["count"], 2)

        # 2. 搜索单个
        response2 = self.client.get(
            reverse("snippet-list"), {"labels": self.label.name}
        )
        res2 = response2.json()
        # self.get_request_full_path(response2)
        # self.format_output_json(res2)

        self.assertEqual(response2.status_code, 200)
        self.assertEqual(res2["count"], 2)

        # 3. 搜索多个
        response3 = self.client.get(
            reverse("snippet-list"),
            {"labels": f"{self.label.name},{label3.name}"},
        )
        res3 = response3.json()
        # self.get_request_full_path(response3)
        # self.format_output_json(res3)

        self.assertEqual(response3.status_code, 200)
        self.assertEqual(res3["count"], 1)
        # # 断言 输出的都是该分类的片段
        # self.assertEqual(res["results"][0]["category"], self.category.pk)

    @patch("snippet.views.ESClient")
    def test_list_snippet_by_search(self, MockESClient):
        """搜索该用户的 text字段的数据"""
        self.client.force_authenticate(user=self.e_user)
        # 创建mock对象
        mock_es_ins = MockESClient.return_value
        # Mock search_text_data 方法 和 返回值
        mock_es_ins.search_text_data.return_value = [
            {
                "id": self.snippet.id,
                "text": self.snippet.text,
                "category": 1,
                "labels": [1, 2],
            }
        ]

        search_key = "测试片段"
        response2 = self.client.get(reverse("snippet-list"), {"search": search_key})
        res = response2.json()
        # self.get_request_full_path(response2)
        # self.format_output_json(res)

        self.assertEqual(response2.status_code, 200)
        # 断言 search_text_data 只被调用一次，并且使用特定的参数
        mock_es_ins.search_text_data.assert_called_once_with(
            user_id=self.e_user.id, text_key=search_key
        )
        # 断言输出结果
        self.assertEqual(res["results"][0]["id"], self.snippet.id)

    @patch("snippet.serializers.insert_data_to_es_task.delay")
    def test_create_snippet(self, mock_insert_data_to_es_task_delay):
        """创建片段"""
        self.client.force_authenticate(user=self.e_user)
        exist_labels = SnippetLabel.objects.filter(owner=self.e_user).count()
        data = {
            "text": "测试片段",
            "category": self.category.pk,
            "labels": ["测试标签100", "测试标签200"],
        }
        response = self.client.post(
            reverse("snippet-list"),
            data,
        )
        res = response.json()
        # self.format_output_json(res)

        self.assertEqual(response.status_code, 201)
        self.assertIn(data["text"], res["text"])
        self.assertIn(self.category.name, res["category"])
        self.assertEqual(
            SnippetLabel.objects.filter(owner=self.e_user).count(), exist_labels + 2
        )
        mock_insert_data_to_es_task_delay.assert_called_once_with(
            {
                "id": res["id"],
                "text": res["text"],
                "category": res["category"],
                "labels": res["labels"],
                "owner_id": res["owner"],
            }
        )


class SnippetLabelTestCase(AppTestCase):
    def test_list_label(self):
        """获取该用户的 所有标签列表"""
        self.client.force_authenticate(user=self.e_user)

        response = self.client.get(reverse("label-list"))
        res = response.json()
        # self.format_output_json(res)

        self.assertEqual(response.status_code, 200)
        # 断言 输出的都是该用户的标签
        labels_id = [item["owner"] for item in res["results"]]
        self.assertEqual(set(labels_id), set([self.e_user.pk]))
        self.assertEqual(response.json()["count"], 1)
        # 断言 该标签下的片段数量
        self.assertEqual(res["results"][0]["count"], 1)

    def test_create_label(self):
        """创建标签"""
        self.client.force_authenticate(user=self.e_user)
        exist_label = SnippetLabel.objects.filter(owner=self.e_user).count()

        data = {"name": "测试标签100"}
        response = self.client.post(
            reverse("label-list"),
            data,
        )
        res = response.json()
        # self.format_output_json(res)

        self.assertEqual(response.status_code, 201)
        self.assertIn(data["name"], res["name"])
        self.assertEqual(
            SnippetLabel.objects.filter(owner=self.e_user).count(), exist_label + 1
        )


class CategoryTestCase(AppTestCase):
    def test_list_category(self):
        """获取该用户的 所有分类列表"""
        self.client.force_authenticate(user=self.e_user)

        response = self.client.get(reverse("category-list"))
        res = response.json()
        # self.format_output_json(res)

        self.assertEqual(response.status_code, 200)
        # 断言 输出的都是该用户的分类
        category_id = [item["owner"] for item in res["results"]]
        self.assertEqual(set(category_id), set([self.e_user.pk]))
        self.assertEqual(response.json()["count"], 1)
        # 断言 该分类下的片段数量
        self.assertEqual(res["results"][0]["count"], 1)

    def test_create_category(self):
        """创建分类"""
        self.client.force_authenticate(user=self.e_user)
        exist_category = Category.objects.filter(owner=self.e_user).count()

        data = {"name": "测试分类100"}
        response = self.client.post(
            reverse("category-list"),
            data,
        )
        res = response.json()
        # self.format_output_json(res)

        self.assertEqual(response.status_code, 201)
        self.assertIn(data["name"], res["name"])
        self.assertEqual(
            Category.objects.filter(owner=self.e_user).count(), exist_category + 1
        )
