# 1 Introduction to MySQL Connector/Python

*MySQL Connector/Python 8.0*:
- 符合 python DBApi2.0 介面
- 支援幾乎所有的 MySQL Server 功能
- 支援 [X DevAPI](https://dev.mysql.com/doc/x-devapi-userguide/en/)
- 自動轉換 python 與 MySQL 的 data types, ex: python datetime -> MySQL DATETIME
- All MySQL extensions to standard SQL syntax.
- Client 與 Server 之間的 data stream 壓縮
- 連線使用 *TCP/IP sockets* && *Unix sockets*
- Secure TCP/IP 連線使用 SSL
- 自成一體的 Driver, 並不會依賴於 *MySQL client library* 或 *Python第三方*

哪種版本的 MySQL 適合使用哪中版本的 Driver, 參考: [Chapter 3 Connector/Python Versions](https://dev.mysql.com/doc/connector-python/en/connector-python-versions.html)