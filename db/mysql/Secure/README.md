

MySQL 8.0 預設使用 `caching_sha2_password`

MySQL 已經內建了原生的身分驗證方式: `mysql_native_password` (5.7版以前). 他其實只是把 **hash(密碼)** 儲存到 DB 內, 所以其實安全性很糟糕.

- caching_sha2_password: 效能較 `sha256_password` 佳; 8.0版的預設方式
- sha256_password
- mysql_native_password:
  - Server-Side:
    - 這東西已經內建在 MySQL Server 裡面, 無法被卸載或拔掉
  - Client-Side:
    - 內建在任何的 `libmysqlclient` client library 之中.



```sql
--#; 底下是 8.0 版預設
> SHOW VARIABLES LIKE 'default_authentication_plugin';
+-------------------------------+-----------------------+
| Variable_name                 | Value                 |
+-------------------------------+-----------------------+
| default_authentication_plugin | caching_sha2_password |
+-------------------------------+-----------------------+
1 row in set (0.00 sec)
```

```bash
### 可透過明確指定方式來透過 mysql client 登入
$ mysql --default-auth=mysql_native_password ...
```


```sql
--#; 修改 密碼認證 方式
ALTER USER user
  IDENTIFIED WITH caching_sha2_password
  BY 'password';
```

NOTE: 如果 server 使用 `caching_sha2_password`, 比較舊的 clients 及 connectors 可能不認識這種加密方式.