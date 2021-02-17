

```sql
--#; 讓 session acquire table lock
> LOCK TABLES table_name [READ | WRITE]

--#; 解鎖
> UNLOCK TABLES;
```