# [Replica Set Oplog](https://docs.mongodb.com/v4.4/core/replica-set-oplog/)

- `oplog` 記錄著 對 database 的所有 *變更操作* 會維持一個滾動紀錄(rolling record) 的特殊 `capped collection`
- v4.0 以前, 對於 oplog 有些不同, 遇到再說
- v4.4+, 開始支援以 小時 為單位的 最小操作日誌保留期. 且只在以下情況做日誌刪除:
    - oplog 以達到配置大小的上限
    - oplog entry 早於配置的小時數
- MongoDB 將資料操作套用到 primary, 然後將這些操作記錄到 *primary's oplog*.
- 後續 secondary members 異步地 Copy & Apply 這些操作到他們身上
- 所有的 ReplicaSet members 都有一份 oplog, 這東西配置在 `local.oplog.rs` collection, which allows them to maintain the current state of the database
    - 
- 為了促進 replication, 所有的 ReplicaSet members 都會發送 heartbeats(ping) 所尤其它成員. 任何 Secondary member 都可從彼此身上 import oplog
    - oplog 的操作紀錄都是寡等操作


## Oplog Size

針對不同的 Storage Engine(Unix, Windows) 有不同的預設大小:

- In-Memory Storage Engine: (不想鳥它= =)
- WiredTiger Storage Engine: defaults to 5% of free disk space. 範圍從 990MB ~ 50GB

> A larger oplog can give a replica set a greater tolerance for lag, and make the set more resilient. 
> The oplog should be long enough to hold all transactions for the longest downtime you expect on a secondary. At a minimum, an oplog should be able to hold minimum 24 hours of operations; however, many users prefer to have 72 hours or even a week's work of operations.

```js
// 進入 ReplicaSet member 的 MongoShell, 查看 oplog size
rs.printReplicationInfo()
```

其他細節懶得看了, 遇到再說