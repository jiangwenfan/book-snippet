FROM python:3.12.9-bullseye
RUN apt update && apt install -y gettext

WORKDIR /backend

COPY ./requirements.txt /objectApplication/requirements.txt
RUN pip install --prefix=/pip-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY . /objectApplication


CMD ["/bin/sh", "start.sh"]
