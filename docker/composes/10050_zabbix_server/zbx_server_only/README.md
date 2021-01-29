


```sh
CREATE DATABASE zabbix CHARACTER SET utf8mb4;

CREATE USER 'zabbix'@'%' IDENTIFIED BY '5tgb^YHN';
GRANT ALL ON zabbix.* TO 'zabbix'@'%';

# zabbix repo
MYSQL_PASSWORD=
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
yum install zabbix-server-mysql -y
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p${MYSQL_PASSWORD} zabbix

HOSTNAME=hostname.os73.com    # hostnamectl
ZBX_HOSTNAME=zbx_hostname.os73.com
ZBX_SERVER_HOST=zbx_host.os73.com
ZBX_SERVER_NAME=zbx_name.os73.com
DB_SERVER_HOST=172.18.0.3
DB_SERVER_PORT=3306
MYSQL_PASSWORD=5tgb^YHN

d rm --force zabbix

docker run --name zabbix \
    --hostname $HOSTNAME \
    -e ZBX_HOSTNAME=$ZBX_HOSTNAME \
    -e ZBX_SERVER_HOST=$ZBX_SERVER_HOST \
    -e ZBX_SERVER_NAME=$ZBX_SERVER_NAME \
    -e MYSQL_USER="zabbix" \
    -e DB_SERVER_HOST=$DB_SERVER_HOST \
    -e DB_SERVER_PORT=$DB_SERVER_PORT \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    -e PHP_TZ="Asia/Taipei" \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    -d \
    -p 8080:8080 \
    zabbix/zabbix-web-nginx-mysql:centos-4.0-latest

d logs -f zabbix

dex zabbix bash

```