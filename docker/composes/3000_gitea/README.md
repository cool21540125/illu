# Gitea with MySQL

- [Docker-gitea](https://hub.docker.com/r/gitea/gitea/)
- [Source-gitea](https://github.com/go-gitea/gitea)
- [環境變數設定方式](https://github.com/go-gitea/gitea/tree/master/contrib/environment-to-ini)
- 2021/03/03, latest = 1.13.2



# SELinux Problem

- [Gitea with SELinux](https://github.com/gidcs/gitea-selinux-policy/blob/master/README.md)

```bash
### 基本上用這個就可以了 (如果有用 nginx 反代 80 -> 3000)
semanage port -a -t http_port_t -p tcp 3000
```