

```conf
### 此為 /etc/my.cnf
[mysqld]  # 套用到 mysql server 配置

### 密碼加密方式
default_authentication_plugin=mysql_native_password
# 8.0 預設 caching_sha2_password, 效能較 sha256_password 佳, 也較 mysql_native_password 安全
# 5.7 預設 mysql_native_password
#          sha256_password, 比 mysql_native_password 安全


[mysql]  # 套用到 mysql client 配置


[client]  # 會被 all MySQL distributions 的 client programs 讀取
password="123"  # 任何用戶的預設密碼, 可免輸入(這樣好嗎...?)


[mysqldump]  # 
```