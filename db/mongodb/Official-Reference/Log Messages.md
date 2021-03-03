[Log Messages](https://docs.mongodb.com/manual/reference/log-messages/)

MongoDB 維護的 log events 包括了: incoming connections, commands run, and issues encountered

從 MongoDB 4.4 開始, `mongod` 及 `mongos` log 變更為 JSON format

``` jsonc
{
    "t": < Datetime > ,              // timestamp
    "s": < String > ,                // severity
    "c": < String > ,                // component
    "ctx": < String > ,              // context
    "id": < String > ,               // unique identifier
    "msg": < String > ,              // message body
    "attr": < Object >               // additional attributes (optional)
        "tags": < Array of strings > // tags (optional)
        "truncated": < Object >      // truncation info (if truncated)
        "size": < Integer >          // original size of entry (if truncated)
}
```


##

關於 Log config 的 `maxLogSizeKB`(預設 10KB), 若單一筆 Log 超過此大小, 會被截斷
