# [Chapter 5 MySQL Server Administration](https://dev.mysql.com/doc/refman/8.0/en/server-administration.html)



關於 MySQL connection:
- 所有平台:
    - 1 manager thread 處理 TCP/IP conn req
    - 1 thread 可能被啟用來接收 administrative TCP/IP conn req. 而此 thread 也可與上述 manager thread 合併
- Unix: 同上 thread, 也處理 Unix socket file conn req
- Win: 
    - 1 manager thread 處理 shared-memory conn req
    - 1 thread 處理 named-pipe conn req