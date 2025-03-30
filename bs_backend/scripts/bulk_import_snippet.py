import requests


def bulk_import_snippet(token, snippet_data, api_url="http://localhost:8080/snippets/"):
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    for snippet in snippet_data:
        response = requests.post(api_url, headers=headers, json=snippet)
        if response.status_code != 201:
            print(
                f"导入失败: {snippet['text']} - {response.status_code} {response.text}"
            )


bulk_import_snippet(
    token="",
    snippet_data=[
        {
            "text": "未经审视的人生不值得度过。",
            "category": 9,
            "labels": ["苏格拉底", "人生哲学", "自我反思"],
        },
        {
            "text": "人不能两次踏进同一条河流，因为河流已经不同，他也不同。",
            "category": 9,
            "labels": ["赫拉克利特", "变化哲学", "流变"],
        },
        {
            "text": "人是万物的尺度，是存在者如何存在的尺度，也是非存在者如何不存在的尺度。",
            "category": 9,
            "labels": ["普罗泰戈拉", "相对主义", "人本主义"],
        },
        {
            "text": "上帝死了！上帝依然死着！是我们杀死了他！",
            "category": 9,
            "labels": ["尼采", "无神论", "价值重估"],
        },
        {
            "text": "世界上一切事物都只是意志和表象。",
            "category": 9,
            "labels": ["叔本华", "悲观主义", "意志论"],
        },
        {
            "text": "知识即美德。",
            "category": 9,
            "labels": ["苏格拉底", "道德哲学", "智慧"],
        },
        {
            "text": "人是注定要自由的，因为人一旦被抛入世界，就要为自己的一切负责。",
            "category": 9,
            "labels": ["萨特", "存在主义", "自由"],
        },
        {
            "text": "我思故我在。",
            "category": 9,
            "labels": ["笛卡尔", "理性主义", "自我意识"],
        },
        {
            "text": "人生而自由，却无往不在枷锁之中。",
            "category": 9,
            "labels": ["卢梭", "社会契约", "自由"],
        },
        {
            "text": "现实的就是合理的，合理的就是现实的。",
            "category": 9,
            "labels": ["黑格尔", "辩证法", "历史哲学"],
        },
        {
            "text": "最大多数人的最大幸福，是道德与立法的基础。",
            "category": 9,
            "labels": ["边沁", "功利主义", "伦理学"],
        },
        {
            "text": "人类历史就是阶级斗争的历史。",
            "category": 9,
            "labels": ["马克思", "历史唯物主义", "社会变革"],
        },
    ],
)
