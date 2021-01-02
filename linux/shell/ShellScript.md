
## RH134-RHEL7-en-1-20140610, p64 範例

```sh
# 若一次性排程工作 > 0, bash 就睡覺吧~
while [ $(atq | wc -l) -gt 0 ]; do sleep 1s; done
```


```bash
# -e: 可以啟用 \ 轉譯
echo -e "\033[31m[ERROR]\033[0m"
# 會印出 紅色字體的 [ERROR]

echo -e "\033[32m [INFO]: hi \033[0m"
# 印出 綠色字體 [INFO]: hi
```


# if

* -r : 讀取權限
* -f : 檔案存在