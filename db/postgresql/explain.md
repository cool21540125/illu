## EXPLAIN (有無使用 index 做 where 搜尋)

```sql
-- Table 裡面資料量 14998 筆
EXPLAIN SELECT * FROM ip_location WHERE routing_ip_number = 193180913;
EXPLAIN ANALYSE SELECT * FROM ip_location WHERE routing_ip_number = 193180913;

-- 情境1. 有 Index(routing_ip_number) 的情況
Index Scan using ix_ip_location_routing_ip_number on ip_location  (cost=0.29..8.30 rows=1 width=52)
  Index Cond: (routing_ip_number = 193180913)

-- 情境2. 無 Index 的情況
Seq Scan on jkb_cache_ip_location  (cost=0.00..297.38 rows=1 width=52)
  Filter: (routing_ip_number = 193180913)

Seq Scan on jkb_cache_ip_location  (cost=0.00..297.38 rows=1 width=52) (actual time=0.024..3.450 rows=1 loops=1)
  Filter: (routing_ip_number = 193180913)
  Rows Removed by Filter: 14998
Planning Time: 0.088 ms
Execution Time: 3.472 ms

-- 說明:
使用 Table Scan, 循序搜尋
cost=0.00..297.38 rows=1 width=52
     AAAA  BBBBBB      C       DD
    A: 估計的啟動成本
    B: 估計總成本
    C: 此計劃節點輸出的估計資料列數量
    D: 此計劃節點輸出的資料列估計的平均資料大小
```


### [善用EXPLAIN](https://docs.postgresql.tw/the-sql-language/performance-tips/using-explain)

```
EXPLAIN SELECT * FROM tenk1;

                         QUERY PLAN
-------------------------------------------------------------
 Seq Scan on tenk1  (cost=0.00..458.00 rows=10000 width=244)
                          ^^^^  ^^^^^^      ^^^^^       ^^^
                           A      B           C          D
A:估計的啟動成本。這是在輸出階段開始之前花費的時間, 例如, 在排序節點中進行排序的時間
B:估計總成本. 這是在假設計劃節點執行完成, 即檢索所有可用資料列的情況下評估的。實際上, 節點的父節點可能會停止讀取所有可用的資料列（請參閱下面的 LIMIT 範例）
C:此計劃節點輸出的估計資料列數量。同樣地, 假定節點完全執行
D:此計劃節點輸出的資料列估計的平均資料大小（以 byte 為單位）
```
