這個章節講解 MySQL Group Replication 以及它的 安裝 & 組態 & monitor groups

MySQL Group Replication 可建立 elastic, HA, fault-tolerant replication topologies

*Groups* 可以運行在 `single-primary mode with automatic primary election`, 也可以運行在 `multi-primary mode` (簡單的說就是一主, 也可以多主)

Group Replication 保證服務是 *continuously available* (當然是在多主的情況下)

> ... if one of the group members becomes unavailable, the clients connected to that group member must be redirected, or failed over, to a different server in the group, using a connector, load balancer, router, or some form of middleware. Group Replication does not have an inbuilt method to do this. For example, see MySQL Router 8.0.

Group Replication 屬於 MySQL Server 的一款 plugin

另一種用來部署 group of MySQl Server instances 可參考 InnoDB Cluster