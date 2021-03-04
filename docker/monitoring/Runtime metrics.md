# [Runtime metrics](https://docs.docker.com/config/containers/runmetrics/)
- 2021/03/05


## Docker stats

使用 `docker stats` 監控 Containers `CPU, memory usage, memory limit, network IO metrics` 的即時串流指標 

![docker stats](../img/docker-stats.png)


## Control groups

Linux Containers 依賴底層的 *CGroup*, 這些 *CGroup* 揭露了 `processes`, `CPU, memory, block I/O usage` 的 metrics

> This is relevant for `pure` LXC containers, as well as for Docker containers.
^ 三小...

- *CGroup* 透過 `pseudo-filesystem` 的形式來現身
    - 舊系統可能掛載在 `/cgroup`, 無明顯的結構層次. 裡頭有點雜亂, 甚至還有 running container
    - 較近代的系統東西基本上放在 `/sys/fs/cgroup`, 底下的資料夾, 對應於不同的 *CGroup* 結構層次

```bash
### 系統上的 *CGroups* 究竟掛載在哪裡
$# grep cgroup /proc/mounts
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
# 以上來自 ec2 免費的 VM.... (僅節錄部分)
```

若藉由 `grep cgroup /proc/mounts` 查詢的結果有看到 `/sys/fs/cgroup/cgroup.controllers`, 表示使用的是 `CGroup v2`, 否則為 `CGroup v1`

NOTE: aws 免費的 EC2 看起來是 v2, 但是以現在電腦環境來說, 得做些升級才能讓 Docker 使用 CGroup v2...


### CGROUP V1

```bash
### 查看 OS 已知的 CGroup subsystems
$# cat /proc/cgroups
#subsys_name    hierarchy   num_cgroups enabled
cpuset  9   5   1
cpu 4   68  1
cpuacct 4   68  1
blkio   7   68  1
memory  3   106 1
devices 10  68  1
freezer 2   5   1
net_cls 8   5   1
perf_event  5   5   1
net_prio    8   5   1
hugetlb 11  5   1
pids    6   68  1

### 可查看 /proc/<PID>/cgroup, 來得知 Process 屬於哪些 CGroups
$# cat /proc/1/cgroup 
11:hugetlb:/
10:devices:/
9:cpuset:/
8:net_cls,net_prio:/
7:blkio:/
6:pids:/
5:perf_event:/
4:cpu,cpuacct:/
3:memory:/
2:freezer:/
1:name=systemd:/
# CGroup 用相對於 / 的相對路徑來呈現他們的 mountpoint
# 若為 /, 表示這個 Process 並不屬於任何 group
# ex: /lxc/pumpkin 則可看出, 這個 Process 是名為 pumpkin 的 Container 的成員之一
```

### CGROUP V2

`/proc/cgroups` 沒有意義. 取而代之應去查看 `/sys/fs/cgroup/`


## Changing cgroup version

這邊引導如何把 OS 由 *CGroup v1* -> *CGroup v2*

遇到再說

## Running Docker on cgroup v2

由 *Docker 20.10* 開始實驗性的支援 v2. 有底下版本的基本要求:

- containerd: v1.4+
- runc: v1.0.0-rc91+
- Kernel: v4.15+ (但建議 v5.2+)

其餘細節遇到再說


## Find the cgroup for a given container

看不懂這章節在說啥...


## Metrics from cgroups: memory, CPU, block I/O

NOTE: 在閱讀文件的今天, 這部分依舊在講的是 Docker using CGroup v1

對於每個 subsystem (memory, CPU, block I/O), 存在了 一或多個 pseudo-files, 並包含了統計資訊

### Memory metrics: `MEMORY.STAT`


### CPU metrics: `cpuacct.stat`


#### BLOCK I/O METRICS


### Network metrics


# Tips for high-performance metric collection


# Collect metrics when a container exits


