
# PostgreSQL

- 2019/05/16

```bash
### Run Container - MacOS
$# docker run -d \
    -v ~/docker_data/pg/data:/var/lib/postgresql/data \
    -p 5433:5432 \
    -e POSTGRES_PASSWORD=postgres \
    --name=mypg postgres:11

$# docker run --name mysql57 \
    -p 3306:3306 \
    -v ~/docker_data/mysql57/data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=mysql57 \
    -d mysql:5.7

#   vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv 給裡頭塞組態
    -v ~/docker_data/mysql57/my.cnf:/etc/mysql/my.cnf \
# 不指定密碼, 也可使用 docker logs mysql57 查看 root password

### Run Container - Windows
$# docker run -d -p 5433:5432 -v D:\DockerVolumes\pg_finance\postgres:/var/data/postgres -v D:\DockerVolumes\pg_finance\xlog_archive:/var/data/xlog_archive -v D:\DockerVolumes\pg_finance\backup:/var/data/backup -e POSTGRES_PASSWORD=postgres --name=pg_finance postgres

### ps
$# docker ps
CONTAINER ID  IMAGE     COMMAND                 CREATED        STATUS        PORTS                    NAMES
66f01f9cc264  postgres  "docker-entrypoint.s…"  4 seconds ago  Up 2 seconds  0.0.0.0:54321->5432/tcp  app-postgres

### Usage
$# psql -h <HOST> -p <PORT> -U postgres -W <PASSWORD> <DATABASE>
# 或者, 使用 GUI 登入, 帳號預設為 postgres

### 進入 Shell
$# docker exec -it app-postgres /bin/bash
```

```sql
-- postgresql 產生
CREATE OR REPLACE FUNCTION "public"."gen_random_uuid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/pgcrypto', 'pg_random_uuid'
  LANGUAGE c VOLATILE
  COST 1
```

# CentOS7

```bash
$# docker pull centos:7
$# docker run -itd \
    -p 8080:80 \
    -p 2222:22 \
    --name myos7 \
    --hostname myos7 \
    centos:7
```