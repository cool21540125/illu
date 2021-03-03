# 2 Guidelines for Python Developers

- 為了安全起見, 不要在代碼中 hardcode 連線資訊, 取而代之, 寫到 *config.py* 模組內
- Python scripts often build up and tear down large data structures in memory, up to the limits of available RAM. Because MySQL often deals with data sets that are many times larger than available memory, techniques that optimize storage space and disk I/O are especially important. For example, in MySQL tables, you typically use numeric IDs rather than string-based dictionary keys, so that the key values are compact and have a predictable length. This is especially important for columns that make up the primary key for an InnoDB table, because those column values are duplicated within each secondary index.
- 盡可能地避免 DB 接觸到 *bad data*. Server-side 善用像是 *unique constraints* && *NOT NULL constraints*; Client-side 則是善用 *try except*
- 永遠對 User input 作驗證, 小心 client 使用特殊字元, ex: 「"」,「;」,「%」,「_」,「*」
- 若能對查詢結果作預期:
    - 確定只有一筆, `fetchone()`
    - 確定會有多筆, `fetchall()`
    - 無法確定查詢結果, `fetchmany()`
- ※ 針對 SELECT 的結果, 因為都是在 RAM 作運算, 善用 aggregation function && WHERE, 或 適時的修改配置: `innodb_buffer_pool_size`(用來 caching query result)
- 為了快速: 
    - CREATE TABLE 善用 `innodb engine`, 增加 read-write 效能
    - 建議對每個 Table 使用 numeric PK(查詢最有效率)

其實這章節多半在講開發方面的建議, 所以僅節錄目前還沒內化的摘要.
