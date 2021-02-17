# zabbix

- 2019/07/23
- 監控用的


## Ports

- 80:    Web GUI
- 10050: **Passive Agent** 使用. Server 藉由 10050 Port 訪問 Agent, Agent 回報監控數據
- 10051: **Active Agent** 使用. Agent 自動向 Server 10051 Port 提交監控數據


# 結構

```bash
/etc/
    /zabbix/
        /zabbix-server.conf         # zabbix 設定主檔
/usr/share/zabbix/include/classes/api/services/     # api-history
```
