# [Chapter 7 Backup and Recovery](https://dev.mysql.com/doc/refman/8.0/en/backup-and-recovery.html)

- 2020/12/30

MySQL 官方論壇, 參考 [MySQL Forums](https://forums.mysql.com/list.php?28)

`mysqldump` 的指令使用, 參考 [mysqldump — A Database Backup Program](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)
    - 更多關於 SQL Statements, 參考 [Chapter 13 SQL Statements](https://dev.mysql.com/doc/refman/8.0/en/sql-statements.html)
- 關於 InnoDB Backup, 參考 [InnoDB Backup](https://dev.mysql.com/doc/refman/8.0/en/innodb-backup.html)

`MySQL InnoDB Cluster` 是一群 一同做事的 DB 們的集合, 可用來提供 HA solution. 一群 MySQL Servers 可透過 MySQL shell 來配置為同一個 cluster. 
- cluster 內, 僅有唯一的 source, 也稱之為 primary, **acts as the read-write source**, 其餘的 secondary servers are replicas of the source. 
- 若要創建 HA cluster, 最起碼需要 3 台.
- Client application 透過 MySQL Router 連接到 primary. 如果 primary 掛了, secondary 會自動升級為 primary, MySQL Router 會將請求路由到 new primary.

`NDB Cluster` 提供了適用於 分散式環境的 high-availability, high-redundancy. 關於 MySQL NDB Cluster 8.0, 更多資訊參考 [Chapter 23 MySQL NDB Cluster 8.0](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)

---------------------------------------------------------------------------

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
