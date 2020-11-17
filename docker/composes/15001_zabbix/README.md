# zabbix

- 2020/11/10
- [DockerHub-zabbix](https://hub.docker.com/r/zabbix/zabbix-server-mysql)


```bash
docker pull zabbix/zabbix-server-mysql

docker run --name some-zabbix-server-mysql \
    -e DB_SERVER_HOST="some-mysql-server" \
    -e MYSQL_USER="some-user" \
    -e MYSQL_PASSWORD="some-password" \
    -d zabbix/zabbix-server-mysql
```