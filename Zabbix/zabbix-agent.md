# agent

每次調整完組態, 都要記得重啟服務

```sh
/etc/zabbix/*.conf
/etc/zabbix/zabbix-agentd/*.conf
```
裡面可能會定義一些 `UserParameter`, 就需要 `systemctl restart zabbix-agent`
