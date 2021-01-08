
## [Setting the Replication Source Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-masterbaseconfig.html)

```sh
### /etc/my.cnf

[mysqld]
# For the greatest possible durability and consistency in a replication setup using InnoDB with transactions
innodb_flush_log_at_trx_commit=1
sync_binlog=1

# 若設置為0, 也在合理範圍內, 但此不允許 replicas 來作 replication
server_id=1
# 使用 server_id OR server-id, 有一樣的結果

# 務必確保底下這個沒有被 ON 起來(default OFF)
# skip_networking=OFF
```


## [Setting the Replica Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-slavebaseconfig.html)

```sh
### /etc/my.cnf
server_id=2
```


## 相關指令

```sql
SET GLOBAL server_id = 21;    --#; MySQL run time 改變server_id
SHOW VARIABLES LIKE 'server_id';

--#; 建立 專門用來做 Replication 的用戶
CREATE USER 'repl'@'%.example.com' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.example.com';
```
