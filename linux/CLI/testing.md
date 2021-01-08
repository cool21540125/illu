

## 讓 CPU 飆升的測試

```sh
### 計算圓周率, 計算到小數點以下8000位
echo "scale=8000; 4*a(1)" | bc -l -q >> /dev/null
# 另一個 Terminal 再 htop
```