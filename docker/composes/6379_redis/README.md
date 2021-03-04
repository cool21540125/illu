
# 使用 Docker 安裝 redis

- 2021/03/04
- [docker_redis](https://hub.docker.com/_/redis/)
- [redis-compose](https://peihsinsu.gitbooks.io/docker-note-book/content/redis_user_guide.html)
- [在 Docker Compose file 3 下限制 CPU 與 Memory](https://blog.yowko.com/docker-compose-3-cpu-memory-limit/)
- 2020/03/27, latest = 5.0.8
- 2021/03/04, latest = 6.2.21

```bash
docker pull redis:6.0

### 正式使用 (persistent storage)
docker run -d \
    -p 6379:6379 \
    --name redis \
    redis \
    redis-server --appendonly yes

### 若 v3 以上的 compose 指定資源限制, 需加上 --compatibility
$# docker-compose --compatibility up -d
```


## Note

所謂 `persistent storage`, 資料會存放到 `VOLUME /data`, 也就是說可以使用 `-v ./redis_data:/data`.

當 Container 停掉之後, 會嘗試把 in memory 的資料寫入到此 volume 位置, 裡頭會有一個 `dump.rdb` 的檔案, 下次啟動後, 此資料會被 redis 載入

所以資料不會遺失哦!!

關於更多 Redis Persistence, [參考官網](https://redis.io/topics/persistence#redis-persistence)
