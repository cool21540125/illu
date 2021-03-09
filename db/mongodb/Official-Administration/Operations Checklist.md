# [Operations Checklist](https://docs.mongodb.com/v4.4/administration/production-checklist-operations/)

底下為 生產環境 的 MongoDB 建議閱讀的議題


## Filesystem

- `dbPath` 避免使用 *NFS drives*(性能差&不穩定). 詳情參考: [Remote Filesystems ](https://docs.mongodb.com/manual/administration/production-notes/#production-nfs)
- Linux 的 Disk Format 建議使用 XFS
    - 對於 `WiredTiger storage engine`, 強烈建議使用 XFS


## Replication

- 對於所有的 *non-hidden replica set members*, 應配置相同的 RAM, CPU, disk, network, ...
- 依照使用情境, 配置 [oplog size](https://docs.mongodb.com/manual/tutorial/change-oplog-size/)
    - `replication oplog window` 應涵蓋 *normal maintenance* 及 *downtime windows*, 避免 *full resync*
    - `replication oplog window` 應涵蓋 *the time needed to restore a replica set member from the last backup*
        - v3.4 以後, 不需要再這樣做了. 詳情遇到再說
- 起碼需要 3 個運行 journaling 的 Hosts, 並且發出帶有 `w:"majority" write concern` 來確保 可用性 & 持久性
- 使用 hostname 而非 IP, 且可解析到彼此
- 確保所有運行 mongod 的 Instances 之間網路雙向暢通
- 確保 ReplicaSet 包含 奇數 的 `voting members`
- 確保 `mongod instance` 有 0 or 1 votes
- 為了 HA, 將 ReplicaSet 至少部署到 3 個 data centers


## Sharding

遇到再說


## Journaling: WiredTiger Storage Engine

- 確保所有 Instances 都使用 [journaling](https://docs.mongodb.com/manual/core/journaling/)
- 把 journal 放置在 低延遲的 disk 以因應 *write-intensive workloads*
    - NOTE: 這將會影像 snapshot-style backups, 因為 DB狀態的構成文件 將留駐在 separate volumes (看不懂)


## Hardware

- Use RAID10 && SSD 來最佳化效能
- SAN & 虛擬化: (遇到再說)


## Deployments to Cloud Hardware

遇到再說


## Operating System Configuration

- 關閉 [Disable Transparent Huge Pages (THP)](https://docs.mongodb.com/manual/tutorial/transparent-huge-pages/)
- 調整 [readahead settings](https://docs.mongodb.com/manual/administration/production-notes/#readahead)
    - 除非有經過其它測試證明有效, 否則建議設定在 8~32
    - 商業版有其他支援, 遇到再說
- 使用 `noop` 或 `deadline` 的 disk schedulers for SSD drives
- 在 `dbPath` mount point 底下使用 `noatime`
- 確保系統有配置 `swap space`
- 確保 system default TCP keepalive 正確配置
    - ReplicaSet 及 Sharded Clusters 配置 300 效果通常會不錯
        - 參考 [Does TCP keepalive time affect MongoDB Deployments?](https://docs.mongodb.com/manual/faq/diagnostics/#faq-keepalive)


## Backups

定期排程來對 backup & restore process 進行測試, 並且評估耗時, 並驗證其功能


## Monitoring

- 錢多的話, 可考慮 MongoDB Cloud Manager 或 MongoDB Enterprise Advanced
- 應特別注意 `disk usage`, `CPU`, `disk space`, 此外還有:
    - replication lag
    - replication oplog window
    - assertions
    - queues
    - page faults
- 在沒有 disk space monitoring 的情況下的因應措施:
    - 在 `storage.dbPath` 底下建立一個 dummy file, 快爆掉的時候再來移除它 && 增加容量
    - 也可單純使用 `cron + df` 的方式來監控儲存空間, 乾~ 超鳥~


## Load Balancing

- 配置 load balancer 來啟用 `sticky sessions` 或 `client affinity`, 並為連線提供足夠的 timeout
- 避免再 MongoDB Cluster 或 ReplicaSet 之間放置 Load Balancing