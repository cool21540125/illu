


```bash
docker run -d   -p 28017:28017 -p 27018:27017  --restart=always   -e TZ=Asia/Shanghai   --name mongo   mongo:3.4   mongod --httpinterface
# 3.6 版此功能已經被疑除了
```