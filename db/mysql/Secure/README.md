

MySQL 8.0 預設使用 `caching_sha2_password`


- caching_sha2_password (效能較 `sha256_password` 佳)
- sha256_password
- mysql_native_password (5.7以前預設的方式)

此轉變會影響:

- `libmysqlclient` client library
- server


```sql
> SHOW VARIABLES LIKE 'default_authentication_plugin';
+-------------------------------+-----------------------+
| Variable_name                 | Value                 |
+-------------------------------+-----------------------+
| default_authentication_plugin | caching_sha2_password |
+-------------------------------+-----------------------+
1 row in set (0.00 sec)
```


```sql
--#; 修改 密碼認證 方式
ALTER USER user
  IDENTIFIED WITH caching_sha2_password
  BY 'password';
```

NOTE: 如果 server 使用 `caching_sha2_password`, 比較舊的 clients 及 connectors 可能不認識這種加密方式.