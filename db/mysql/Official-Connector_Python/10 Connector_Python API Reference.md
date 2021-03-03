# Chapter 10 Connector/Python API Reference

本章節描述 *Connector/Python* 的 *public API*

NOTE: since *Connector/Python 8.0.24*, 已移除 2.7 的支援

```sh
# mysql.connector 套件及模組結構
mysql.connector
  errorcode
  errors
  connection
  constants
  conversion
  cursor
  dbapi
  locales
    eng
      client_error
  protocol
  utils
```


## 10.1 mysql.connector Module
## 10.2 connection.MySQLConnection Class
## 10.3 pooling.MySQLConnectionPool Class
## 10.4 pooling.PooledMySQLConnection Class
## 10.5 cursor.MySQLCursor Class

`MySQLCursor 實例` 來執行 SQL statements, 藉由 `MySQLConnection 物件` 來與 MySQL Server 互動


## 10.6 Subclasses cursor.MySQLCursor




## 10.7 constants.ClientFlag Class
## 10.8 constants.FieldType Class
## 10.9 constants.SQLMode Class
## 10.10 constants.CharacterSet Class
## 10.11 constants.RefreshOption Class
## 10.12 Errors and Exceptions