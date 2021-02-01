# 紀錄 python 的一些有趣的小細節

### Ellipsis

```py
>>> ...
Ellipsis

>>> type(...)
<class 'ellipsis'>

# ↓ ... 為獨體物件
>>> bool(...)
True
>>> id(...)
140319404492464
>>> id(...)
140319404492464

# ↓ 在 python3 內, 可用 ... 代替 pass. 在 Number 內, 它是語法糖
>>> def nothing():
...     ...
... 
>>>
```



### 小整數池

python 的世界, 任何東西都是誤件, 因此為了避免記憶體被耗盡

底層會偷偷事先建立好 [-5, 256] 這些整數小數池.

```py
>>> a=8
>>> b=8
>>> a is b
True

>>> a=1000
>>> b=1000
>>> a is b
False

# ↓ 因為在同一行, python interpreter 知道他們是一樣的
>>> a=1000;b=1000
>>> a is b
True
```
