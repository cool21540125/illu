# 5 Connector/Python Coding Examples

直接列出幾個範例與法, 細節懶得寫了=.=

```python
### Conn ----------------------------------------
# 法1
import mysql.connector
cnx = mysql.connector.connect(user='scott', password='password',
                              host='127.0.0.1',
                              database='employees')
from mysql.connector import (connection)
# 法2
cnx = connection.MySQLConnection(user='scott', password='password',
                                 host='127.0.0.1',
                                 database='employees')

# 上兩者都行
cursor = cnx.cursor()

cursor.execute("SQL String")

# 查詢時, 若有多筆資料, 可透過 for-in 來 iterate cursor
# cursor 查詢後是個 iterator

# 增刪改, 預設 Connector/Python 的 autocommit=off
cnx.commit()
cnx.rollback()

cursor.close()
cnx.close()

# ErrCode ----------------------------------------
from mysql.connector import errorcode
```