# 磁碟分割
- 2018/04/21
- 硬梆梆...


# 概念

磁區(Sector) : 最小物理儲存單位, 分別有 `512 Bytes(早期)` 、 `4K Bytes(近代)`.


    磁碟分割表分為兩種
    1. 早期的 MBR分割表 (512 Bytes)    
        |- 非第 1 磁區
        |- 第 1 磁區 (這邊壞了硬碟就掛了)
            |- 主要開機區 (Master boot record, MBR) - 446 Bytes
            |- 分割表 (Partition Table) - 64 Bytes
    2. 近代的 GPT分割表 (支援 2TB 以上硬碟)




# MBR (max 2.2TB)
- MBR底下, `Primary Partition` 與 `Extended Partition` 最多只能有 4個(硬碟限制)(each 16 Bytes)
- `Extended Partition` 最多只能有 1個(作業系統限制), 用來為 `邏輯分割區(Logical Partition)` 作定址
- `Logical Partition` 是由 `Extended Partition` 持續切割出來的分割槽.
- 能夠被格式化後, 拿來存資料的是 `Primary Partition` 及 `Logical Partition`. (`Extended Partition` 無法格式化)
- `Logical Partition` 數量, 依作業系統而不同. Linux系統, SATA硬碟可以突破 63個以上了~
- 把 `Extended Partition` 想像成他只是個指向 `Logical Partition`的空殼. 裏頭還會指向 **尚未被分割的分割槽**.

其餘細節, [去看鳥哥](http://linux.vbird.org/linux_basic/0130designlinux.php#partition_table), 並搜尋關鍵字「所以邏輯分割槽的裝置名稱號碼就由5號開始了」, 有個不錯的範例. 重點在於, 為什麼「/dev/sda2」之後就跳成「/dev/sda5」了...


    /dev/sd[a-p][1-128] : 實體磁碟 的 磁碟檔名
    /dev/vd[a-p][1-128] : 虛擬磁碟 的 磁碟檔名




# GPT
將磁碟所有區塊以 LBA區塊來記錄分割資訊. 第一個 LBA稱為 `LBA0`. GPT使用了 34個 LBA區塊來記錄分割資訊(相較於 MBR, 只使用一個), GPT除了前面 34個 LBA之外, 整個磁碟的最後 33個 LBA也拿來做為另一個備份. 

部分磁碟為了與 MBA兼容, 會將 LBA預設為 512bytes.

![鳥哥 - GPT分割表](http://linux.vbird.org/linux_basic/0130designlinux/gpt_partition_1.jpg)
圖片來源: 鳥哥

上圖, 分為3個部分說明:

1. LBA0 (MBR相容區塊)

    基本上同MBR, 存了 `開機管理程式` 及 特殊標誌的分割(單純用來表示此磁碟為 GPT格式).
    此磁區是受到保護的.

2. LBA1 (GPT表頭紀錄)
    
    記錄了`分割表本身的位置與大小`, 同時也記錄 備份用的 GPT分割放置的位置, 以及 檢驗機制碼(CRC32).

3. LBA2-33 (實際紀錄分割資訊處)

    這些區塊, 每個 LBA都可以記錄 4筆分割紀錄, 預設可以有 4*32=128筆 分割紀錄. 而每筆紀錄用到 128bytes的空間, 扣除其他必要紀錄的欄位, **GPT在每筆紀錄中分別提供了 64 bits來記載 開始/結束 的磁區號碼**, 經過一般人看不懂的計算後, 最終作業系統可以認識 *8ZB* 的磁碟.



# 檔案系統 Filesystem, 底下都以 fs 表示

> 一般來說, `一個分割槽(partition)` 只能裝 `一個 fs`. 但因為後續的新技術, ex: LVM, 軟體磁碟陣列(RAID), `一個分割槽`, 可以裝 `多個 fs 了`, 所以 ~~針對 partition 來格式化~~, `一個可被掛載的資料 = 一個 fs (而非分割槽)`

Linux fs 通常把 `檔案權限(rwx)` 與 `檔案屬性(owner, group, time, ...)` 存到不同區塊

- `block` : 實際檔案內容. 若檔案太大, 會占用多個 block
- `inode` : 紀錄檔案屬性. 一個檔案占用一個 inode, 並記錄 `data block 號碼`
- `superblock` : fs 整體資訊. 包括 inode/block 的總量, 使用量, 剩餘量.

## Linux 支援的檔案系統
- 傳統 fs : ext2 / minix / MS-DOS / FAT 等
- 日誌式 fs : ext3 / ext4 / ReiserFS / Windows' NTFS / SGI's XFS / ZFS 等
- 網路 fs : NFS / SMBFS

> 從 `CentOS7 開始`, 拋棄了對 Linux 支援度最廣的 ext家族, `投入了 xfs 的懷抱`. 有一大堆原因啦!!  ex : ext家族 格式化時採用 `預先配置`(大硬碟會弄超久~~ 而 `xfs 採用 動態配置`)、還有其他我看不懂的... 參考 [鳥哥-XFS檔案系統簡介](http://linux.vbird.org/linux_basic/0230filesystem.php#harddisk-xfs).

> journal功能 : 檔案系統裏頭, 如果有說明支援 `日誌功能(System Log)` , 表示如果哪天出了問題, 重開機的時候, 不用作 Disk Scan, 而是直接去檢查 syslog 之類的東西, 然後開始作修復 or 還原.

> Linux VFS (Virtual Filesystem Switch) : Linux 認識的 fs 都是在 VFS 進行管理. 簡單來說, Linux裏頭可以同時存在多個不同的 fs, User在作檔案存取時, 根本不需要理會目前操作的檔案的 fs 式殺虫, 因為 VFS 以將幫忙處理了. VFS流程圖可以看 [鳥哥-VFS檔案系統的示意圖](http://linux.vbird.org/linux_basic/0230filesystem.php#harddisk-other)

```sh
# 查看 Linux 支援的檔案系統有哪些
$ ls -l /lib/modules/$(uname -r)/kernel/fs

# 查看 已經載入到 Memory 中支援的 fs
$ cat /proc/filesystems
nodev   tmpfs
nodev   sockfs
nodev   autofs
nodev   pstore
nodev   selinuxfs
        xfs
...(略)... # 約30個

# xfs 檔案系統 查看 superblock的方式
$ xfs_info <掛載點|裝置檔名>

# /boot 底下的 superblock
$ df -hT /boot
檔案系統       類型  容量  已用  可用 已用% 掛載點
/dev/sda1      xfs  1014M  242M  773M   24% /boot

# 這我看不懂, 鳥哥寫的解說我也不想看懂 @@" 用到再來談了...
$ xfs_info /dev/sda1
meta-data=/dev/sda1              isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks # 0 表示沒使用 磁碟陣列
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```



# 查硬碟容量 df 與 du

## 1. df
> 列出 檔案系統 的 整體磁碟使用量 : `df` ,針對整個檔案系統, 讀取範圍主要是在 Superblock 內的資訊(速度快). `※「/」容量剩下很小的話, 就代表快出事了!`

```sh
$ df [-ahikHTm] <目錄 or 檔案>
# a : 所有的檔案系統, 包含「/proc」(都在記憶體裡面, 不佔用磁碟空間)
# h : 已 kb, mb, gb, tb...表示  (預設以 bytes呈現)
# T : 列出該 partition的 filesystem名稱, ex: xfs
# i : 已 inode代替 磁碟容量

$ df -hT
# Filesystem         Type      1K-blocks  Used  Avail  Use%   Mounted on
檔案系統              類型      容量       已用   可用    已用%  掛載點
/dev/mapper/cl-root  xfs        80G      9.3G    71G   12%    /
devtmpfs             devtmpfs  1.8G         0   1.8G    0%    /dev
tmpfs                tmpfs     1.9G      7.9M   1.8G    1%    /dev/shm # 記憶體模擬(快); 通常是 總記憶體/2
tmpfs                tmpfs     1.9G       33M   1.8G    2%    /run
tmpfs                tmpfs     1.9G         0   1.9G    0%    /sys/fs/cgroup
/dev/sda1            xfs      1014M      242M   773M   24%    /boot
/dev/mapper/cl-var   xfs        50G       15G    36G   30%    /var
/dev/mapper/cl-home  xfs        80G       13G    68G   16%    /home
tmpfs                tmpfs     370M       44K   370M    1%    /run/user/1000
# 檔案系統(Filesystem) : 所在 partition (裝置名稱)
```

## 2. du

> 評估 檔案系統 的 磁碟使用量(目錄所佔容量) : `du`, 會實際到 檔案系統 內搜尋所有的 檔案資料(費時).

```sh
$ du [-ahskm] <檔案 or 目錄>
# a : 列出所有的檔案與目錄容量(預設只有統計檔案數量)
# S : 不包含子目錄下的統計
# s : 只列出總容量
# h : 人看得懂的 kb, mb, gb, ...
# m : 以 MBytes 顯示
# k : 以 KBytes 顯示

$ du -a | head -3
0	./.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/langpack-zh-TW@firefox.mozilla.org.xpi
4	./.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/.fedora-langpack-install
4	./.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}

# --max-depth=1, 最多到第一層子目錄的空間使用情形
$ du ~ -h --max-depth=1 | head -3
21M	/home/tony/.mozilla
662M	/home/tony/.cache
536M	/home/tony/.config
```



# 其他

- 磁碟管理工具, 老牌的 `fdisk` 不認識 GPT, 需要用 `gdisk` 或 `parted`
- 開機管理程式, `grub` 不認識 GPT, 需要用 `grub2`
- 並非所有作業系統都認識 GPT, 也並非所有硬體都認識 GPT.
- NTFS 是 `windows 2000` 以後的產物

是否能讀寫 GPT 與 `開機的檢測程式(BIOS 與 UEFI)` 有關.