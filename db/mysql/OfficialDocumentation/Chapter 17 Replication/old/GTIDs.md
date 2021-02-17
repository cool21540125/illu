
## 知識架構

- [MySQL 自动故障转移工具--mysqlfailover](https://blog.csdn.net/leshami/article/details/52848327)
- [基于mysqldump搭建gtid主从](https://blog.csdn.net/leshami/article/details/52755472)
- [配置MySQL GTID 主从复制](https://blog.csdn.net/leshami/article/details/50630691)

- 配置MySQL GTIDs 主叢
    - 配置 MySQL GTIDs Master/Slave Replication

> Global Transaction Identifiers, 全局事務標示.

GTIDs 是基於 MySQL Server 生成的一個已經被成功執行的 **Global Transaction ID**. 

**Global Transaction ID** 由 **Server ID** 及 **Transaction ID** 組成. 

**Global Transaction ID** 在 Master/Slave Replication 架構中為 Unique. 既然為 Unique, 在作 MySQL Master/Slave Replication 將會變得單純許多, 且數據庫一致性也將變得可靠.


GTID 用來代替 *傳統的 Replication(也就是 bin-log Replication)*. 不再使用 *MASTER_LOG_FILE* + *MASTER_LOG_POS*, 而改為使用 *MASTER_AUTO_POSITION=1* 的方式來作 Replication

