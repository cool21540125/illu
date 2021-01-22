

```conf
### 此為 /etc/my.cnf
[mysqld]  # 套用到 mysql server 配置


[mysql]  # 套用到 mysql client 配置


[client]  # 會被 all MySQL distributions 的 client programs 讀取
password="123"  # 任何用戶的預設密碼, 可免輸入(這樣好嗎...?)


[mysqldump]  # 
```