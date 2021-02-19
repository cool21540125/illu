- [Chapter 7 Backup and Recovery](https://dev.mysql.com/doc/refman/8.0/en/backup-and-recovery.html)
- 2020/12/31

`mysqldump` 的指令使用, 參考 [mysqldump — A Database Backup Program](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)
    - 更多關於 SQL Statements, 參考 [Chapter 13 SQL Statements](https://dev.mysql.com/doc/refman/8.0/en/sql-statements.html)
- 關於 InnoDB Backup, 參考 [InnoDB Backup](https://dev.mysql.com/doc/refman/8.0/en/innodb-backup.html)

`MySQL InnoDB Cluster` 是一群 一同做事的 DB 們的集合, 可用來提供 HA solution. 一群 MySQL Servers 可透過 MySQL shell 來配置為同一個 cluster. 
- cluster 內, 僅有唯一的 source, 也稱之為 primary, **acts as the read-write source**, 其餘的 secondary servers are replicas of the source. 
- 若要創建 HA cluster, 最起碼需要 3 台.
- Client application 透過 MySQL Router 連接到 primary. 如果 primary 掛了, secondary 會自動升級為 primary, MySQL Router 會將請求路由到 new primary.

`NDB Cluster` 提供了適用於 分散式環境的 high-availability, high-redundancy. 關於 MySQL NDB Cluster 8.0, 更多資訊參考 [Chapter 23 MySQL NDB Cluster 8.0](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)


區分為 Physical(Raw) 與 Logical Backup
- Physical backups : 由 儲存 database contents 的 raw copies of the directories and files 所組成. 適合 large && important && 需要 recovered quickly 的 DB.
    - 此 backup 由 確切的 database directories and files 所組成. 通常是 部分or所有 MySQL data directory.
    - 比 Logical backup 還快速 (指涉及 file copying, 而不進行 conversion)
    - Output 比 Logical backup 還要 compact.
    - backup speed and compactness 對於 重要的DB 來說非常重要, 若為企業用戶, 參考 [MySQL Enterprise Backup Overview](https://dev.mysql.com/doc/refman/8.0/en/mysql-enterprise-backup.html)
    - backup and restore granularity(粒度) 範圍從 individual files 到 entire data directory. 像是 InnoDB tables 可以各自位於獨立文件中, 或與其他 InnoDB tables 共享文件儲存(share file storage)
    - 除了 DB 以外, backup 還可包含相關的檔案, ex: log && config files
    - Memory tables 則是難以備份, 若有相關問題在來看
    - backups 只能移轉到 相似硬體特性的機器上(難以跨平台的意思吧!?)
    - 若非為企業版, backup 的時候要馬要把 MySQL server stop 或者 要作適當的 locking(避免 backup 的時候, 資料被修改). 企業版則有其他方法, 遇到再說.
    - backup 相關的指令工具, 像是 企業版的 `mysqlbackup`; 或是 OS 內建的 `cp`, `scp`, `tar`, `rsync` for MyISAM tables.
    - 關於 restore:
        - NDB tables 可參考 [ndb_restore](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster-programs-ndb-restore.html)
        - 從 OS file system copy 下來的檔案, 可
- Logical backups : 備份了 DB structure (CREATE DATABASE, CREATE TABLE statements) && content (INSERT statements). 適合 比較少量的資料(可能在其他主機上重新recreate && insert)
    - 藉著查詢 MySQL Server 來獲取 database structure 及 data 來完成 backup
    - 比 Physical Bakup 還慢, 因為 Server 需要 access database information 以及 把它們 convert to logical format.
    - If the output is written on the client side, the server must also send it to the backup program.
    - Output 比 Physical backup 還大, 尤其是儲存程 text format
    - 不管哪種 Storage Engine, backup and restore granularity(粒度) 可選擇使用 Server Level(all DB), DB Level(all tables), Table Level.
    - backup 範圍不包含 log && config files, 以及 database 以外的任何東西
    - backup 儲存為 logical format, 此為 machine independent 且 highly portable
    - backup 過程, MySQL Server 需要維持 running
    - logical backup 相關的指令工具(適用於任何的 Storage Engine):
        - 參考 [mysqldump](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)
        - mysql client, 使用 `SELECT ..L INTO OUTFILES` STATEMENT
    - 關於 Restore:
        - 若為 SQL-format dump file, 藉由 mysql client 來執行
        - 若為 delimited-text files:
            - 參考 [mysqlimport](https://dev.mysql.com/doc/refman/8.0/en/mysqlimport.html)
            - mysql client, 使用 `LOAD DATA` STATEMENT 

---------------------------------------------------------------------------

區分為 Online 及 Offline backups:
- Online backup(俗稱 hot backup), 發生在 MySQL Server running, server 可取得 database information. 
    - 具備較小的侵略性(less intrusive)
    - 必須注意得施加適當的 lock, 避免 backup 過程中 data 被修改損害了備份完整性. (企業版會自動執行這個 lock)
- Offline backup(俗稱 cold backup), 發生在 MySQL Server stopped.
    - 具備侵略性, 服務可能得就此中斷了. 但是, 可透過 replication, 在 replica 上頭作 backup 即可.
    - backup 過程更為簡單, 因為不會受到 client 干擾.

restore 的話, 大致上同 backups, 但是最大的不同在於, restore 期間, 會針對 database 作寫入, 因此應該避免 restore 期間, client 來作訪問 database.

此外, 另一種稱為 warm backup, 發生在 MySQL Server running, 但作 lock

---------------------------------------------------------------------------

區分為 Local 及 Remote Backups. 所謂 Local Backups, 就是在 MySQL Server 執行的那台上面作 backup. 也可藉由 remote host 發起 backup, 然後 backup data 依舊寫入到 Local 端.
- [mysqldump](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html), 可用來連接到 local 或者 remote.
    - 對於 SQL output (CREATE and INSERT), local or remote dumps 會在 client host 產出 backup file.
    - 對於 delimited-text output, 會在 server host 產出 backup file, 參考 [--tab option](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_tab)
    - `SELECT ... INTO OUTFILE` 可在 local or remote 發起, 但 backup file 會建立在 server host.
    - Physical Backup 一般都是在 local host 執行(因此 server 才可作 offline), 但 backup file 可以輸出到 remote.

---------------------------------------------------------------------------

區分為 Full 及 Incremental Backups. 關於 full backup, 參考上述的那些 backup 方法; 關於 incremental backup, 可透過 server's binlog 來完成.

---------------------------------------------------------------------------

Snapshot Backups

Some file system implementations enable “snapshots” to be taken. These provide logical copies of the file system at a given point in time, without requiring a physical copy of the entire file system. (For example, the implementation may use copy-on-write techniques so that only parts of the file system modified after the snapshot time need be copied.) MySQL Server 本身步提供 taking file system snapshots. 但可藉由像是 Veritas, LVM, ZFS 等第三方套件來實現.


後續若資料發生損壞, 資料完整性則遭到破壞. 對於:
- InnoDB, 這並不是個常見的 issue
- MyISAM, 參考 [MyISAM Table Maintenance and Crash Recovery](https://dev.mysql.com/doc/refman/8.0/en/myisam-table-maintenance.html)


最後關於 Backup Scheduling, Compression, Encryption, MySQL 本身沒提供這類服務.


Servers 之間如何作 replication, 最佳實務取決於 **data** && **engine types**



# Binary Log File Position Based Replication

source 會針對 write updates 作為事件, 將此動作記錄到 binlog. Replicas 被配置來閱讀 source 的 binlog, 並在 replica 本地DB 執行. 
    - Replicas 會收到 binlog 的副本. 預設上, 他的任務就是去執行 binlog 所有的 write update. 但可自行配置 僅限於特定DB or tables 作 replication. (但無法配置 那些事件要被記錄到 binlog)
    - 因為 replicas 有紀錄 source 上頭的 log file && position, 所以可以 disconnected, reconnect and then resume processing.
    - source && replica 必須配置 system variable: `server_id` (Unique)
    - replicas 也需要透過 `CHANGE MASTER TO` 來聲明 source 位置. 
        - v8.0.23 (含)以後, 使用 `CHANGE REPLICATION SOURCE TO`
        - v8.0.23 以前,     使用 `CHANGE MASTER TO`
    - Replication 詳細資訊, 會儲存在 replica 上的 metadata repository, 參考 [Relay Log and Replication Metadata Repositories](https://dev.mysql.com/doc/refman/8.0/en/replica-logs.html)


binlog replication 過程中
- All servers, 預設有 enable binary log. replicas 節點上, 沒必要啟用 binlog, 但若啟用, 可用來作 **data backups** && **crash recovery**
- source 需配置 `server_id`, 後續需要重啟服務. 參考 [Setting the Replication Source Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-masterbaseconfig.html)
    - 關於 source 的相關 SQL, 參考 [SQL Statements for Controlling Source Servers](https://dev.mysql.com/doc/refman/8.0/en/replication-statements-master.html)
- replica 需配置 `server_id`, 後續需要重啟服務. 參考 [Setting the Replica Configuration](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-slavebaseconfig.html)
    - 關於 replica 的相關 SQL, 參考 [SQL Statements for Controlling Replica Servers](https://dev.mysql.com/doc/refman/8.0/en/replication-statements-replica.html)
- 針對 replication 過程額外創建一個用戶, 參考 [Creating a User for Replication](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-repuser.html)
- 開始前, source 需紀錄目前的 binlog position, 此用來讓 replicas 知道該從哪邊開始. 參考 [Obtaining the Replication Source Binary Log Coordinates](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-masterstatus.html)
    - replica 的設定指令: `CHANGE MASTER TO`, 參考 [Setting the Source Configuration on the Replica](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-slaveinit.html)
        - 關於 `CHANGE MASTER TO` 更細部的所有指令, 參考 [CHANGE MASTER TO Statement](https://dev.mysql.com/doc/refman/8.0/en/change-master-to.html)
    - 已有 data 在 source 上面 && service running,
        - 先執行 [FLUSH TABLES WITH READ LOCK](https://dev.mysql.com/doc/refman/8.0/en/flush.html#flush-tables-with-read-lock) 來停止 InnoDB 作 COMMIT
        - 開始進行後續配置:
            - 要在已有 data 的 source server, 增加 replica, 必須把 source 上的資料同步到其他 replica 上, 可參考下面作法:
                - 使用 `mysqldump`, 特別是 InnoDB.
                    - 在 source 上面, 使用 `mysqldump --all-databases --master-data > dbdump.db`
                    - --all-databases, 把所有 database dump 出來
                    - --master-data, 一併把 `CHANGE MASTER TO` 的資訊也倒出來, 參考 [--master-data](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_master-data)
                    - 如果只要 dump 特定 DB, 把 `--all-databases` 取代為 [--databases](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_databases)
                    - 若要排除特定 table, 則使用 [--ignore-table](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_ignore-table)
                    - 前提是, 運行的 source server 已經 stop 或者 block 了
                    - 關於使用 mysqldump 來作 DB backup, 參考 [mysqldump — A Database Backup Program](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)
                    - 若資料為 binary, 不要使用 mysqldump. 將 raw data files 複製到 replica 上面(可以省去 overhead of updating indexes as the INSERT statements). Engine 非為 InnoDB, 也別用此方法
                    - 若要把資料 dump 到 Raw Data File, 再進入該網頁, 搜尋 「Creating a Data Snapshot Using Raw Data Files」
            - 若使用 GTIDs, 再進來裡面找 'GTIDs' 看說明, 參考 [Choosing a Method for Data Snapshots](https://dev.mysql.com/doc/refman/8.0/en/replication-snapshot-method.html)
    - 如果使用新DB, 參考 [Setting Up Replication with New Source and Replicas](https://dev.mysql.com/doc/refman/8.0/en/replication-setup-replicas.html#replication-howto-newservers)
        - FIXME: 他奶的... 這邊看不是很懂, 到底在寫三小....
    - 如果要在運行一陣子後的機器增加 replicas, 參考 [Adding Replicas to a Replication Environment](https://dev.mysql.com/doc/refman/8.0/en/replication-howto-additionalslaves.html)
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