- [Chapter 17 Replication](https://dev.mysql.com/doc/refman/8.0/en/replication.html)

Replication 可讓一台 MySQL Server(source) copied to 一到多台 MySQL Server(replicas)

Replication 預設為 async. 可透過配置組態, 來 replicate 所有DB, 其中幾個指定的DB, 甚至特定DB的Table

Replication 的作法:
- 傳統方法: Based on replicating events from the source's binary log(也就是 `binlog`), 因此需要指定 log-file && position
- 新方法: Based on global transaction identifiers(GTIDs).
    - Replication 使用 GTIDs 來保證 source && replicas 之間的一致性
        - 一旦 source 發生了 transaction commit, 也會一併套用到 replica.

MySQL 支援了不同類型的 replication:
- 傳統方法 : 採用 單向 `async replication`. 也就是一台扮演 source, 其餘扮演 replicas.
- NDB Cluster : 則是採用 sync replication. [MySQL NDB Cluster](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)
- MySQL8.0 也支援了 `semi-sync replication` : `semi-sync replication` 的機制就是, source 一旦 commit 之後 (在返回給 session 以前), 會先 block, 直到其中一個 replica 接收到同步 && log transaction, 才會 返回到 session. [Semi-sync Replication](https://dev.mysql.com/doc/refman/8.0/en/replication-semisync.html)

Servers 之間如何作 replication, 最佳實務取決於 **data** && **engine types**, 更多的資訊參考[Setting Up Binary Log File Position Based Replication](https://dev.mysql.com/doc/refman/8.0/en/replication-howto.html)

如何選擇適當的 replication && 如何使用 replication, 來當作 system failure 的解決方案, 參考 [Replication Solutions](https://dev.mysql.com/doc/refman/8.0/en/replication-solutions.html)

------

[Replication Formats](https://dev.mysql.com/doc/refman/8.0/en/replication-formats.html) 分為 2 種 core types:
- Statement Based Replication(SBR) : 會去 replicate 完整的 SQL statements.
- Row Based Replication(RBR) : 只會去 replicate 有改變的 rows.
- Mixed Based Replication(MBR) : 此機制混合了前 2 種方法.

Replication 藉由一大堆的 options && variables 來控制. 參考[Replication and Binary Logging Options and Variables](https://dev.mysql.com/doc/refman/8.0/en/replication-options.html), 更多的安全性議題, 參考[Replication Security](https://dev.mysql.com/doc/refman/8.0/en/replication-security.html)

- [Replication 常見 QA](https://dev.mysql.com/doc/refman/8.0/en/faqs-replication.html)
- [Replication 實作細節](https://dev.mysql.com/doc/refman/8.0/en/replication-implementation.html)
