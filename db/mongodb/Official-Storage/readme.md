# Storage

MongoDB 管理資料的主要原件之一 - Storage Engine

journal 是用來幫助 DB 意外 shutdown 的一種 log, 用來實現 `performance` & `reliability` 之間取得平衡

`GridFS` 適合用來處理大文件(超過 16MB) 的一種通用存儲系統