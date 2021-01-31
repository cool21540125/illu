

Zabbix Server 元件:

1. mariadb
2. zabbix server
3. zabbix web


# 1. MariaDB

```sh
CREATE DATABASE zabbix;
CREATE USER 'zabbix'@'%' IDENTIFIED BY '5tgb^YHN';
GRANT ALL PRIVILEGES on zabbix.* to 'zabbix'@'%';
```

NOTE: 172.18.0.3


# 2. Zabbix Server

```sh
CREATE DATABASE zabbix CHARACTER SET utf8mb4;

CREATE USER 'zabbix'@'%' IDENTIFIED BY '5tgb^YHN';
GRANT ALL ON zabbix.* TO 'zabbix'@'%';

# zabbix repo
MYSQL_PASSWORD=
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
yum install zabbix-server-mysql -y
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p${MYSQL_PASSWORD} zabbix


### Zabbix Server
# https://hub.docker.com/r/zabbix/zabbix-server-mysql

d pull zabbix/zabbix-server-mysql:centos-4.0-latest

NAME=zabbix
DB_SERVER_HOST=172.18.0.3
DB_SERVER_PORT=3306
MYSQL_USER=zabbix
MYSQL_PASSWORD=5tgb^YHN

d rm --force $NAME

d run -d \
    --name ${NAME} \
    --hostname ${NAME} \
    -e DB_SERVER_HOST=${DB_SERVER_HOST} \
    -e DB_SERVER_PORT=${DB_SERVER_PORT} \
    -e MYSQL_USER=${MYSQL_USER} \
    -e MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    zabbix/zabbix-server-mysql:centos-4.0-latest
```
NOTE: 172.18.0.2


# 3. Zabbix Web

```sh


### Zabbix Web
# https://hub.docker.com/r/zabbix/zabbix-web-nginx-mysql

NAME=zabbix_web
ZBX_SERVER_HOST=172.18.0.2           # default to 'zabbix-server'
ZBX_SERVER_PORT=10051                # default to 10051
DB_SERVER_HOST=172.18.0.3
DB_SERVER_PORT=3306
MYSQL_USER=zabbix
MYSQL_PASSWORD=5tgb^YHN
ZBX_SERVER_NAME=web.zabbix.os73.com  # Browser 看到的 Title && 解析訪問

d rm --force ${NAME}

d run -d \
    --name ${NAME} \
    --hostname ${HOSTNAME} \
    -e ZBX_SERVER_HOST=${ZBX_SERVER_HOST} \
    -e ZBX_SERVER_PORT=${ZBX_SERVER_PORT} \
    -e DB_SERVER_HOST=$DB_SERVER_HOST \
    -e DB_SERVER_PORT=$DB_SERVER_PORT \
    -e MYSQL_USER=${MYSQL_USER} \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e ZBX_SERVER_NAME=$ZBX_SERVER_NAME \
    -e PHP_TZ="Asia/Taipei" \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    -p 8080:8080 \
    zabbix/zabbix-web-nginx-mysql:centos-4.0.27-latest

dl ${NAME}

dex zabbix bash
```
NOTE: 172.18.0.4