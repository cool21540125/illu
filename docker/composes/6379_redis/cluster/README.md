
```bash
docker exec -it redis01 bash

redis-cli --cluster create \
    NODE_1_IP:6379 \
    NODE_1_IP:6379 \
    NODE_1_IP:6379 \
    NODE_2_IP:6380 \
    NODE_2_IP:6380 \
    NODE_2_IP:6380 \
    --cluster-replicas 1
```