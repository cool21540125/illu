# [Journaling](https://docs.mongodb.com/v4.4/core/journaling/)

為了能在故障時提供 durability, MongoDB 使用了 `write ahead logging (預寫日誌)` 到 on-disk journal files

至於寫到哪邊? 分成了底下 2 種 Storage Engine

## Journaling and the WiredTiger Storage Engine

NOTE: 底下提到的 "log" 指的是 `WiredTiger write-ahead log`(也就是 journal), 並非是 MongoDB log file

- WiredTiger 使用 checkpoints 來提供 disk 數據的一致性. 並允許 MongoDB 從上一個 checkpoint 來做恢復
    - 若 MongoDB 在 checkpoints 之間意外退出, 則需要搭配 journal 來處理自從最近一次 checkpoint 以後的恢復
- MongoDB 4.0+, 使用 `WiredTiger` 的 ReplicaSet members, 無法再使用 `--nojournal` 或 `storage.journal.enabled: false`


### Journaling Process

- WiredTiger 使用 `in-memory buffering` 來儲存 *journal records*
    - Threads coordinate to allocate and copy into their portion of the buffer. 
    - 最多可 cache 128 KB 的 journal records
- 下底下的任何一種情況會把 buffered journal records 同步回 disk:
    - 對於 Replica Set members (底下這 2 點沒讀懂):
        - If there are operations waiting for oplog entries. Operations that can wait for oplog entries include: 
            - forward scanning queries against the oplog
            - read operations performed as part of causally consistent sessions
        - Additionally for secondary members, after every batch application of the oplog entries.
    - 執行的 write operation, 包含了 `j: true`
    - 預設每 100 毫秒執行一次, 參考 [storage.journal.commitIntervalMs](https://docs.mongodb.com/manual/reference/configuration-options/#storage.journal.commitIntervalMs)
    - 超過目前這份 Journal File 的 Max Size



#### Journal Files

- MongoDB 會在 `dbPath` dir 底下建立一個 journal 的 subdir, 用來放置 WiredTiger Journal Log Files
    - 以 `WiredTigerLog.<sequence>` 的方式命名
    - 預設最大為 100MB, 一旦超過會記錄到下一份
- WiredTiger 會自動刪除自上一個 checkpoint 以前的 old jourlan files


#### Journal Records

- Journal files 裡頭的 record 涵蓋了每個 client 執行的 write operation
    - Journal record 包含了自 initial write 引發的後續所有的 internal write operations, 例如: 
        - Update a document, 若異動到 index, 則這筆 journal record 會包含 *update operation* && *index modification*
- 每一筆 `Journal record` 都具有 `unique identifier`
- 會對 journaling record 進行 *snappy compression(快速壓縮)*
    - WiredTiger mininum journal record size 為 128 bytes, 若小於 mininum journal record size, 則不進行壓縮
        - 若要改變此配置, 使用 `storage.wiredTiger.engineConfig.journalCompressor`
        - 預到再來看  [Change WiredTiger Journal Compressor](https://docs.mongodb.com/manual/tutorial/manage-journaling/#manage-journaling-change-wt-journal-compressor)


## Journaling and the In-Memory Storage Engine

Since MongoDB Enterprise version 3.2.6+

沒錢就別想用它!