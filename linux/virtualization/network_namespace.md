# Network Namespace

- 2020/08/30

## 摘要

Linux 從 v2.4.19 開始納入 **namespace** 的概念 用來 *隔離核心資源*

- mount namespace   : 檔案系統掛載點 (since v2.4.19)
- UTS namespace     : 主機名
- IPC namespace     : POSIX 程序間通訊消息隊列
- PID namespace     : 程序 PID 空間
- user namespace    : User ID 空間 (since v3.8)
- network namespace : IP位址 (since v2.6) (此篇重點!)

    
## Network Namespace

- 用來隔離 系統設備 && IP Address, port, route table, firewall rules, ...
- 每個 namespace 都有自己的 `/proc/net/`
- C語言 透過調用 Linux 的 `clone(CLONE_NEWNET)` (UNIX `fork()` 的延伸) 來建立 namespace; 或者, 可透過 `ip` CLI 來實作 操作 namespace
- 如果 namespace 裡面想要與 外界(除了 lo 以外的其他網卡) 溝通, 需要在 ns 裡面建立 `veth pair` (就像是 Linux 的 `pipe`)

```bash
### 建立名為 netns1 的 network namespace
$# ip netns add netns1
# 會在 /var/run/netns 建立一個 掛載點
# 上述 掛載點, 方便對 ns 管理 && 使 ns 即使沒有程序運行也能繼續存在

### 進入名為 netns1 的 ns, 查詢 ip 配置
$# ip netns exec netns1 ip link list

# 裡面只有一個 DOWN 的 lo

### 系統內有哪些 network namespace
$# ip netns list

### 刪除名為 netns1 的 network namespace
$# ip netns delete netns1
# 並非真實移除, 只是移除了他的 掛載點 (裡面有程序運行著的話, 它就會一直存在)

### 進入 netns1, ping localhost
$# ip netns exec netns1 ping 127.0.0.1

### 進入 netns1, 啟用 lo 
$# ip netns exec netns1 ip link set dev lo up



```

