# [Chapter 17 Replication](https://dev.mysql.com/doc/refman/8.0/en/replication.html)

- 2020/12/30

Replication 可讓一台 MySQL Server(`source`) copied to 一到多台 MySQL Server(`replicas`)

Replication 預設為 async. 可透過配置組態, 來 replicate *all DB*, *specific DBs*, *certain tables of DB*

Replication 的作法:
- binlog(傳統方法): Based on replicating events from the source's binary log, 因此需要指定 log-file && position
- GTIDs: Based on global transaction identifiers(GTIDs), 因為是基於 transaction, 讓 replication task 變得更加單純
    - Replication 使用 GTIDs 來保證 source && replicas 之間的一致性
        - 一旦 source 發生了 transaction commit, 也會一併套用到 replica.

MySQL 支援了 different types of replication:
- 傳統方法 : 採用 單向 `async replication`. 也就是一台扮演 source, 其餘扮演 replicas.
- NDB Cluster : 則是採用 `sync replication`. 參考 [Chapter 23, MySQL NDB Cluster 8.0](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)
- MySQL8.0 支援了 `semi-sync replication` : source 一旦 commit 之後 (在返回給 session 以前), 會先 block, 直到其中一個 replica 接收到同步 && log transaction, 才會 返回到 session. 
    - 參考 [Semi-sync Replication](https://dev.mysql.com/doc/refman/8.0/en/replication-semisync.html)

[Replication Formats](https://dev.mysql.com/doc/refman/8.0/en/replication-formats.html) 分為 3 種 types(前 2 種為 core type):
- SBR, Statement Based Replication : 會去 replicate 完整的 SQL statements.
- RBR, Row Based Replication : 只會去 replicate 有改變的 rows.
- MBR, Mixed Based Replication : 此機制混合了前 2 種方法.