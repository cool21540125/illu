# [Run-time Database Configuration](https://docs.mongodb.com/v4.4/administration/configuration/)

[command line](https://docs.mongodb.com/v4.4/reference/program/mongod/) 或 [configuration file](https://docs.mongodb.com/v4.4/reference/configuration-options/) interfaces 提供 DBA 執行相關作業

本文列出常用的配置以及提供最佳實務的 configuration 配置


## Configure the Database

```conf
### 這對於 單主機 使用, 已經相當足夠了
processManagement:
   fork: true  # enables a daemon mode for mongod, 此模式分離了 MongoDB 及 current session
net:
   bindIp: localhost
   port: 27017
storage:
   dbPath: /var/lib/mongo  # MongoDB 用來儲存 data files 的路徑; user:mongod 對此目錄得有完整存取權限
systemLog:
   destination: file
   path: "/var/log/mongodb/mongod.log"
   logAppend: true  # MongoDB start 以後, 不會將原有 Log file 進行覆寫, 而是採用 append
   ## quiet: false
storage:
   journal:
      enabled: true  # 允許啟用 journaling. 用以時現 write-durability. (64-bit OS 預設為啟用, 因此這個可以省略)
```


## Security Considerations

```conf
net:
   bindIp: localhost,10.8.0.10,192.168.4.24,/tmp/mongod.sock  # 記得指開放給 APP Server
security:
   authorization: enabled
```


## Replication and Sharding Configuration

### Replication Configuration

```conf
replication:
   replSetName: set0  # ReplicaSet members 需要配一樣的名稱
security:
   keyFile: /srv/mongodb/keyfile  # 認證方式也可選擇 x.509 等
```

### Sharding Configuration

遇到再說


## Run Multiple Database Instances on the Same System

不建議這麼做, 但若是 開發/測試 則另當別論, 但記得將底下的配置做區隔:

```conf
storage:
   dbPath: /var/lib/mongo/db0/
processManagement:
   pidFilePath: /var/lib/mongo/db0.pid
```

此外可參考 [init script](https://docs.mongodb.com/v4.4/reference/glossary/#term-init-script) 來將啟動方式也做區隔


## Diagnostic Configurations

