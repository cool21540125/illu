# [Quickstart: Compose and Django](https://docs.docker.com/compose/django/)

- 2019/07/22

對於 docker-compose 來說, 需要在一個空的資料夾, 新增(以 Python-Django 為例):

- Dockerfile
- Python dependencies file
- docker-compose.yml

```bash
### 資料夾架構
/compose-dir            # App image 的 context (應該只包含 Resources to build the image)
    /Dockerfile                 # 定義了 app image content
    /python dependencies files  #
    /docker-compose.yml         #
```



```bash
### 在 Terminal 上執行~
$ docker-compose run web django-admin startproject proj .

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',
        'USER': 'postgres',
        'HOST': 'db',
        'PORT': 5432,
    }
}
# ↑↑↑↑↑ 如上 ↑↑↑↑↑
# 如果要改預設密碼的話, 參考這邊吧 https://hub.docker.com/_/postgres

### 最後, 因為是使用 Default Docker Bridge
$ vim proj/settings.py
# ↓↓↓↓↓ 如下 ↓↓↓↓↓
ALLOWED_HOSTS = ['*']   # 可改成 Docker host IP 或 *(較不安全)
# ↑↑↑↑↑ 如上 ↑↑↑↑↑

### 可看目前 compose 底下有哪些 container
$# docker-compose ps
       Name                      Command               State           Ports
-------------------------------------------------------------------------------------
composetest_redis_1   docker-entrypoint.sh redis ...   Up      6379/tcp
composetest_web_1     flask run                        Up      0.0.0.0:5000->5000/tcp
```