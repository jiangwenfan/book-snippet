from bs_backend.celery import app
from user.utils import save_image_to_local
from user.models import User


@app.task
def save_image_to_local_task(user_id: int, url: str) -> str:
    avatar = save_image_to_local(url)

    # 更新avatar字段
    user = User.objects.get(pk=user_id)
    user.avatar = avatar
    user.save()

    return f"user:{user_id}, avatar:{avatar} 保存成功"
