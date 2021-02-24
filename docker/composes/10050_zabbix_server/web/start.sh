

docker run -d \
    --name web \
    -e DB_SERVER_HOST="some-mysql-server" \
    -e MYSQL_USER="some-user" \
    -e MYSQL_PASSWORD="some-password" \
    -e ZBX_SERVER_HOST="some-zabbix-server" \
    -e PHP_TZ="Asia/Taipei" \
    --network=zabbix_net \
    --ip=172.30.0.30 \
    zabbix/zabbix-web-nginx-mysql:centos-4.0.27