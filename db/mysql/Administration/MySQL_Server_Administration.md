# [Chapter 5 MySQL Server Administration](https://dev.mysql.com/doc/refman/8.0/en/server-administration.html)

- startup option : Server running 的配置, 可透過 config && cli
- server system variables : server running 的 startup options value && current state
- server status variables : run time 的 counter && statistics


```sh
### MySQL Server 目前所使用的配置 (將近3000筆...)
$ mysqld --verbose --help

### 目前 Server 運行中的系統配置 && 統計參數
mysql> SHOW VARIABLES;
mysql> SHOW STATUS;
```


對於更詳盡的 command options && system variables && status variables, 參考底下:
- [Server Command Options](https://dev.mysql.com/doc/refman/8.0/en/server-options.html)
- [Server System Variables](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)
- [Server Status Variables](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html)
- 更詳盡的 監控資訊, 參考 [MySQL Performance Schema](https://dev.mysql.com/doc/refman/8.0/en/performance-schema.html)
    - 也可透過 sys schema, 來查看 Performance Schema 的統計資訊, 參考 [MySQL sys Schema](https://dev.mysql.com/doc/refman/8.0/en/sys-schema.html)

MySQL Admin 相關作業議題:
- server config
- mysql 這個 Database 的 schema
- server log
- multiple servers
- security
- backup & recovery
- replication

# Connections

關於 MySQL connection:
- 所有平台:
    - 1 manager thread 處理 TCP/IP conn req
    - 1 thread 可能被啟用來接收 administrative TCP/IP conn req. 而此 thread 也可與上述 manager thread 合併
- Unix: 同上 thread, 也處理 Unix socket file conn req
- Win: 
    - 1 manager thread 處理 shared-memory conn req
    - 1 thread 處理 named-pipe conn req