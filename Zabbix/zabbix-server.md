# server


## Server 修改完 Agent IP 相關組態 要做快取重啟

若 zabbix-server 更改了網頁上面, Host 的配置(ex: IP 更改為 15.88.66.32). 則 zabbix-server 需要重新 reload 才能套用新的配置: 

```sh
zabbix_server -R config_cache_reload
```


## Server 運行監控腳本有 Timeout 限制

```sh
### 預設為 3 秒 Timeout (就不收資料了)
/etc/zabbix/zabbix_server.conf
```