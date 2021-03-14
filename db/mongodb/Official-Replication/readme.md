# [Replication](https://docs.mongodb.com/v4.4/replication/)

- ReplicaSet 只能有一個 Primary, capable of confirming writes with `{w: "majority"}` write concern
    - 在某些情況下(原 primary 失聯, 經投票程序後選出新 primary), 另一個 mongod instance 可能會暫時認為自己也是 primary
- Primary 會記錄所有 data sets 變更的 operation log, 也就是所謂的 `oplog`
- *Secondary* 執行 Rplications 的時候做了下列動作:
    - replicate *primary's oplog*
    - 將操作套用到 data sets, 以使 *secondary server* 的 data sets 反映 *primary server* 的 data sets
- 組成 ReplicaSet, 最起碼需要有 3 個 Nodes, 但如果有預算考量, 也可組成 1M1S1A, 其中一個 Node 為 Arbiter
    - Arbiter 基本上跟個占用空間的廢誤沒兩樣, 只有投票功能

## Automatic Failover

- 當 Primary 與 secondaries 超過了 `electionTimeoutMillis`(預設10秒) 無法聯繫, secondaries 及 arbiter(若有的話), 會開始進行投票選出新的 primary
    - 直到選出新的 primary 以前, 整個 ReplicaSet 無法執行 `write operation`
    - 而 `read operation` 則可在 primary 掛掉尚未選出候補前 && 有允許 read on secondaries 的情況下做查詢

