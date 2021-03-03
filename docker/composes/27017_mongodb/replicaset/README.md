
# MongoDB ReplicaSet

- 2021/03/03


```env
# auth to admin Database for administrator
# vvvvvvvvvvvvvvvvvvvvvvvvvv
MONGO_INITDB_ROOT_USERNAME=root
MONGO_INITDB_ROOT_PASSWORD=1qaz@WSX
# ^^^^^^^^^^^^^^^^^^^^^^^^^^
# DON'T USE THEM
# Bug issue: https://github.com/docker-library/mongo/issues/323

# vvvvvvvvvvvvvvvvvvvvv 
ADMIN_USER=root
ADMIN_PASSWORD=1qaz@WSX
# ^^^^^^^^^^^^^^^^^^^^^
# Use this instead

#MONGO_INITDB_DATABASE=admin

replSetName=rs0

# APP Token
APP_TOKEN=123

# App user auth
APP_USER=tony
APP_PASSWD=5tgb^YHN
```

### ReplicaSet 完成後再來執行

```js
rs.initiate({
    _id: "rs0",
    members: [
        { _id: 0, host: "mongodb01:27017" },
        { _id: 1, host: "mongodb02:27017" },
        { _id: 2, host: "mongodb03:27017" }
    ]
});
rs.status();

admin = db.getSiblingDB("admin");
admin.createUser(
    {
        user: "root",
        pwd: "1qaz@WSX",
        roles: [{ role: "root", db: "admin" }]
    }
);
admin.auth('root', '1qaz@WSX');

demo = db.getSiblingDB("demo_mongo");
demo.meta.insert({
    _id: '12345',
    accountName: 'tony',
    token: "123",
});
demo.createUser(
    {
        user: "tony",
        pwd: "5tgb^YHN",
        roles: [{
            role: "readWrite",
            db: "demo_mongo"
        }]
    }
);
demo.auth('tony', '5tgb^YHN');
```