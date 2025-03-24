from elasticsearch import Elasticsearch
from django.conf import settings
import urllib3
import logging

# from elasticsearch.helpers import bulk

# 屏蔽 urllib3 的 InsecureRequestWarning
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class ESClient:
    def __init__(self):
        self.es = Elasticsearch(
            [f"{settings.ES_HOST}:{settings.ES_PORT}"],
            verify_certs=False,
            basic_auth=(settings.ES_USER, settings.ES_PASSWORD),
        )
        self.index_name = settings.ES_INDEX_NAME

    def check_es(self):
        if self.es.ping():
            logging.info("连接es成功")
        else:
            raise Exception("连接es失败")

    def create_index(self):
        if not self.es.indices.exists(index=self.index_name):
            self.es.indices.create(index=self.index_name)
            logging.info(f"创建es索引: {self.index_name} 成功")

    def insert_data(self, data: dict):
        """
        插入数据
        data: {
            "id": "1"
        }
        """
        response = self.es.index(index=self.index_name, id=data["id"], document=data)
        if response["result"] != "created":
            logging.error(f"插入数据:{data} 失败: {response}")
        logging.info(f"插入数据:{data} 成功: {response}")

    def insert_data_bulk(self, data: list[dict]):
        """
        批量插入数据
        """
        actions = [
            {"_index": self.index_name, "_id": d["id"], "_source": d} for d in data
        ]
        # bulk(es, actions)
        response = self.es.bulk(body=actions)

        if response["errors"]:
            logging.error(f"批量插入数据:{len(data)} 失败: {response}")
        logging.info(f"批量插入数据:{len(data)} 成功: {response}")

    def update_data(self, data: dict):
        """
        更新数据
        data: {
            "id": "1",

        }
        """
        response = self.es.update(index=self.index_name, id=data["id"], document=data)
        if response["result"] != "updated":
            logging.error(f"更新数据:{data} 失败: {response}")
        logging.info(f"更新数据:{data} 成功: {response}")

    def delete_data(self, data_id: str):
        """删除数据
        data: "1"
        """
        response = self.es.delete(index="my_index", id=data_id)
        if response["result"] != "deleted":
            logging.error(f"删除数据:{data_id} 失败: {response}")
        logging.info(f"删除数据:{data_id} 成功: {response}")

    def search_text_data(self, user_id: int, text_key: str) -> list[dict]:
        """搜索该用户下的 text字段的数据
        query: {
            "query": {
                "match_all": {}
            }
        }
        """
        query = {
            "query": {
                # 使用 "bool" 复合查询，允许组合多个查询条件
                "bool": {
                    "must": [{"match": {"text": text_key}}],
                    "filter": [{"term": {"user_id": user_id}}],
                }
            }
        }

        response = self.es.search(index=self.index_name, body=query)

        # 含有es信息的数据
        res: list[dict] = response["hits"]["hits"]

        # 匹配到的数据
        source_res = [hit["_source"] for hit in res]

        return source_res
