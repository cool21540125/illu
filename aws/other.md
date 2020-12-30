# 未分類雜訊


AWS 租機器的方式
- 整台給 $$$
- 不超賣 $$
- 會超賣 $
    - Ondemand
    - Reserved
    - Spot (競拍), 將來可能有人出價較高, 會出現 CPU steal time 的情形
        - note: 實體主機, 多人共享資源, 但主機上就算沒幹嘛, CPU 資源可能被其他人拿去用, 形成 steal time