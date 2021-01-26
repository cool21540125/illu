# MariaDB

mariadb 的一些指令**好像**跟 Oracle MySQL 有些許不同 (不是很確定)

```sql
--#; 修改密碼
UPDATE mysql.user SET authentication_string = PASSWORD('zabbix') WHERE User = 'root' AND Host = '127.0.0.1';
FLUSH PRIVILEGES;

SELECT USER, HOST FROM mysql.user;

SELECT USER(), CURRENT_USER();

SHOW GRANTS for root@localhost;

--#; 建立 zabbix 用戶
CREATE USER 'zabbix'@'*' IDENTIFIED BY 'myadmin';
GRANT ALL PRIVILEGES on zabbix.* to zabbix@localhost;

--#; 修改密碼

UPDATE mysql.user SET authentication_string = PASSWORD('zabbix') WHERE User = 'zabbix' AND Host = 'localhost';
--#; ↑ 不知道為什麼, 沒出錯, 但失敗

SET PASSWORD FOR 'zabbix'@'localhost' = PASSWORD('zabbix');
--#; ↑ 這個可以, 但好像會有某些問題??

FLUSH PRIVILEGES;
SHOW GRANTS for zabbix@localhost;

```