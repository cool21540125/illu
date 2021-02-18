

```bash

docker build -t zabbix_server:4.0.27 .

docker run -it --rm zabbix_server:4.0.27 bash
```

```dockerfile
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/docker-entrypoint.sh"]

CMD ["/usr/sbin/zabbix_server", "--foreground", "-c", "/etc/zabbix/zabbix_server.conf"]
```



## .env

```
DB_SERVER_HOST=
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
```