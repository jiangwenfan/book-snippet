from bs_backend.celery import app
from bs_backend.utils import ESClient


@app.task
def insert_data_to_es_task(data: dict) -> str:
    es = ESClient()
    es.insert_data(data)

    return f"数据插入成功"


@app.task
def insert_data_bulk_to_es_task(data: list[dict]) -> str:
    es = ESClient()
    es.insert_data_bulk(data)

    return f"数据批量插入成功"


@app.task
def update_data_to_es_task(data: dict) -> str:
    es = ESClient()
    es.update_data(data)

    return f"数据更新成功"


@app.task
def delete_data_to_es_task(data_id: str) -> str:
    es = ESClient()
    es.delete_data(data_id)

    return f"数据删除成功"
