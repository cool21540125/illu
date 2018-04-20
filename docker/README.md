# Docker

## Linux環境
- 2018/04/15後, 改用 **18.03版**
```sh
$ uname -a
Linux tonynb 3.10.0-693.21.1.el7.x86_64 #1 SMP Wed Mar 7 19:03:37 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

$ hostnamectl
   Static hostname: tonynb
         Icon name: computer-laptop
           Chassis: laptop
        Machine ID: e5c76287078c4e5fb54034d3d8b26e76
           Boot ID: 1190e532d0ff4faf81cbd7b730bb38a3
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-693.21.1.el7.x86_64
      Architecture: x86-64

$ cat /etc/centos-release
CentOS Linux release 7.4.1708 (Core)

$ rpm --query centos-release
centos-release-7-4.1708.el7.centos.x86_64
```


## Docker版本 
```sh
$ docker --version
Docker version 18.03.0-ce, build 0520e24
```


## Path
- Docker Container Local Storage Area: /var/lib/docker/
- Docker running Container: /var/lib/docker/containers/


## 名詞對應 (依照 Google翻譯...)

Docker image: Docker鏡像

Docker layer: Docker圖層

copy-on-write (CoW) strategy: 寫時復制策略
