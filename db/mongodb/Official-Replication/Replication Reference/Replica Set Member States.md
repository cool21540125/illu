# [Replica Set Member States](https://docs.mongodb.com/v4.4/reference/replica-states/)

ReplicaSet member 有下列的 state:

Number | Name            | Description
------ | --------------- | --------------------
0      | STARTUP         | 正在讀取配置, 此階段尚未成為 replica set 成員
1      | PRIMARY         | 
2      | SECONDARY       | 
3      | RECOVERING      | 
5      | STARTUP2        | 
6      | UNKNOWN         | 
7      | ARBITER         | 
8      | DOWN            | 
9      | ROLLBACK        | 
10     | REMOVED         | 

