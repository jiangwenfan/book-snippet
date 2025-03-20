FROM python:3.12.9-bullseye
RUN apt update && apt install -y gettext

WORKDIR /bs_backend

COPY ./requirements.txt ./requirements.txt
RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY . /bs_backend


CMD ["/bin/sh", "start.sh"]
