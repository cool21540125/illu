# [Chapter 17 Replication](https://dev.mysql.com/doc/refman/8.0/en/replication.html)

- 2020/12/30

Replication 可讓一台 MySQL Server(source) copied to 一到多台 MySQL Server(replicas)

Replication 預設為 async. 可透過配置組態, 來 replicate 所有DB, 其中幾個指定的DB, 甚至特定DB的Table

Replication 的作法:
- 傳統方法: Based on replicating events from the source's binary log, 因此需要指定 log-file && position
- 新方法: Based on global transaction identifiers(GTIDs).
    - Replication 使用 GTIDs 來保證 source && replicas 之間的一致性
        - 一旦 source 發生了 transaction commit, 也會一併套用到 replica.

- 如何使用 bin-log file position 來設定 replication, 參考 [Setting Up Binary Log File Position Based Replication](https://dev.mysql.com/doc/refman/8.0/en/replication-howto.html)
- 如何使用 GTIDs transaction 來設定 replication, 參考 [Replication with Global Transaction Identifiers](https://dev.mysql.com/doc/refman/8.0/en/replication-gtids.html)

---------------------------------------------------------------------------

MySQL 支援了不同類型的 replication:
- 傳統方法 : 採用 單向 `async replication`. 也就是一台扮演 source, 其餘扮演 replicas.
- NDB Cluster : 則是採用 sync replication. 參考 [MySQL NDB Cluster](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)
- MySQL8.0 支援了 `semi-sync replication` : source 一旦 commit 之後 (在返回給 session 以前), 會先 block, 直到其中一個 replica 接收到同步 && log transaction, 才會 返回到 session. 
    - 參考 [Semi-sync Replication](https://dev.mysql.com/doc/refman/8.0/en/replication-semisync.html)

如何選擇適當的 replication && 如何使用 replication, 來當作 system failure 的解決方案, 參考 [Replication Solutions](https://dev.mysql.com/doc/refman/8.0/en/replication-solutions.html)

---------------------------------------------------------------------------

[Replication Formats](https://dev.mysql.com/doc/refman/8.0/en/replication-formats.html) 分為 3 種 types(前 2 種為 core type):
- SBR, Statement Based Replication : 會去 replicate 完整的 SQL statements.
- RBR, Row Based Replication : 只會去 replicate 有改變的 rows.
- MBR, Mixed Based Replication : 此機制混合了前 2 種方法.

Replication 藉由一大堆的 options && variables 來控制. 參考 [Replication and Binary Logging Options and Variables](https://dev.mysql.com/doc/refman/8.0/en/replication-options.html)
    - 更多的安全性議題, 參考 [Replication Security](https://dev.mysql.com/doc/refman/8.0/en/replication-security.html)


Servers 之間如何作 replication, 最佳實務取決於 **data** && **engine types**

Replication 一旦開始以後, 需要額外作些許的 administration && monitoring, 相關任務的建議, 參考 [Common Replication Administration Tasks](https://dev.mysql.com/doc/refman/8.0/en/replication-administration.html)


- [Replication 常見 QA](https://dev.mysql.com/doc/refman/8.0/en/faqs-replication.html)
- [Replication 實作細節](https://dev.mysql.com/doc/refman/8.0/en/replication-implementation.html)


# Binary Log File Position Based Replication

source 會針對 write updates 作為事件, 將此動作記錄到 binlog. Replicas 被配置來閱讀 source 的 binlog, 並在 replica 本地DB 執行. 
    - Replicas 會收到 binlog 的副本. 預設上, 他的任務就是去執行 binlog 所有的 write update. 但可自行配置 僅限於特定DB or tables 作 replication. (但無法配置 那些事件要被記錄到 binlog)
    - 因為 replicas 有紀錄 source 上頭的 log file && position, 所以可以 disconnected, reconnect and then resume processing.
    - source && replica 必須配置 system variable: `server_id` (Unique)
    - replicas 也需要透過 `CHANGE MASTER TO ...` 來聲明 source 位置. 
    - Replication 詳細資訊, 會儲存在 replica 上的 metadata repository, 參考 [Relay Log and Replication Metadata Repositories](https://dev.mysql.com/doc/refman/8.0/en/replica-logs.html)

[Setting the Source Configuration on the Replica](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-slaveinit.html)
- 如果要在全新機器上設定 Replication, 參考 [Setting Up Replication with New Source and Replicas](https://dev.mysql.com/doc/refman/8.0/en/replication-setup-replicas.html#replication-howto-newservers)
- 如果要在運行一陣子後的機器增加 replicas, 參考 [Adding Replicas to a Replication Environment](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-additionalslaves.html)

binlog replication 過程中
- All servers, 預設有 enable binary log. replicas 節點上, 沒必要啟用 binlog, 但若啟用, 可用來作 **data backups** && **crash recovery**
- source 需配置 `server_id`, 後續需要重啟服務. 參考 [Setting the Replication Source Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-masterbaseconfig.html)
    - 關於 source 的相關 SQL, 參考 [SQL Statements for Controlling Source Servers](https://dev.mysql.com/doc/refman/8.0/en/replication-statements-master.html)
- replica 需配置 `server_id`, 後續需要重啟服務. 參考 [Setting the Replica Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-slavebaseconfig.html)
    - 關於 replica 的相關 SQL, 參考 [SQL Statements for Controlling Replica Servers](https://dev.mysql.com/doc/refman/8.0/en/replication-statements-replica.html)
- 針對 replication 過程額外創建一個用戶, 參考 [Creating a User for Replication](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-repuser.html)
- 開始前, source 需紀錄目前的 binlog position, 此用來讓 replicas 知道該從哪邊開始. 參考 [Obtaining the Replication Source Binary Log Coordinates](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-masterstatus.html)
    - 如果已有data, 參考 [Choosing a Method for Data Snapshots](https://dev.mysql.com/doc/refman/8.0/en/replication-snapshot-method.html)
    - 如果使用新DB, 參考 [Setting Up Replication with New Source and Replicas](https://dev.mysql.com/doc/refman/8.0/en/replication-setup-replicas.html#replication-howto-newservers)
- 不同的 Database Engine 之間的 replication 流程不進相同, 如下:
    - InnoDB, 參考 [InnoDB and MySQL Replication](https://dev.mysql.com/doc/refman/8.0/en/innodb-and-mysql-replication.html)
    - MyISAM, 遇到再說

---------------------------------------------------------------------------

Replication 相關 issue:

> Dropping a FOREIGN KEY constraint does not work in replication because the constraint may have another name on the replica.

> With statement-based binary logging, the source server writes the executed queries to the binary log. This is a very fast, compact, and efficient logging method that works perfectly in most cases. However, it is possible for the data on the source and replica to become different if a query is designed in such a way that the data modification is nondeterministic (generally not a recommended practice, even outside of replication).

> For example, for INSERT ... SELECT with no ORDER BY, the SELECT may return rows in a different order (which results in a row having different ranks, hence getting a different number in the AUTO_INCREMENT column), depending on the choices made by the optimizers on the source and replica.

> A query is optimized differently on the source and replica only if:
- The table is stored using a different storage engine on the source than on the replica. (It is possible to use different storage engines on the source and replica. For example, you can use InnoDB on the source, but MyISAM on the replica if the replica has less available disk space.)
- MySQL buffer sizes (key_buffer_size, and so on) are different on the source and replica.
- The source and replica run different MySQL versions, and the optimizer code differs between these versions.