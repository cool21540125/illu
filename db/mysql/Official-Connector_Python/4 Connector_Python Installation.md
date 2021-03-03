# 4 Connector/Python Installation

`Connector/Python` 安裝的時候及使用:
- if pure, 依賴 *python standard library* && *Python Protobuf>=3.0.0*
    - CentOS7 & U16.04 不支援 C *Python Protobuf 3+*
    - 取而代之使用 *C Extension variant*, 需使用 `--force`, 但可能不使用 `use_pure=True` (這段話不太確定在說啥)
- if not pure, 藉由使用 *MySQL C client library* 實作的 *C Extension* 介面
    - 但是取而代之, 也可使用 MySQL Server 提供的 library, 參考[MySQL C API Implementations](https://dev.mysql.com/doc/c-api/8.0/en/c-api-implementations.html)

無論是 client/server protocol 的實作, 都沒依賴第三方, 但若打算使用 SSL, python 編譯安裝時期需要加入 *OpenSSL* libraries

底下區分為, 使用 binary 或 src code 來安裝 *Connector/Python*


## 4.1 Obtaining Connector/Python

到 [這邊](https://dev.mysql.com/downloads/connector/python/) 抓 *Connector/Python 8.0.x*


## 4.2 Installing Connector/Python from a Binary Distribution

- 若要使用這個, 必須先有 MySQL Server 提供的 *C client library*. (因為這個安裝的 *C Extension* 會 link 到它)
- Pyton 安裝: `pip install mysql-connector-python` 
- YUM 安裝: 
    - 加入 MySQL Yum Repo
    - `yum update mysql-community-release`
    - `yum install mysql-connector-python`
- RPM 安裝:
    - `rpm -i XXX.rpm`
        - Connector/Python 8.0.22 以前, *C extension implementation* 的 RPM package 名字裡頭有 "cext"
- Win, Debian, Mac 安裝:
    - 遇到再說

> Connector/Python 8.0.22 以前, *C extension* 及 *pure Python implementations* 分成 2 個安裝包. *C extension implementation* 的套件名稱裡頭有 "cext" 字眼


## 4.3 Installing Connector/Python from a Source Distribution

- platform:
    - Linux 需要 `gcc`
    - Windows 需要 VS2010 for Python3.3
- Protobuf C++ 細節需要再來參考
- *Python development files*

或是使用 pure python 的安裝方式: 

```bash
python setup.py install \
    --with-protobuf-include-dir=/dir/to/protobuf/include \
    --with-protobuf-lib-dir=/dir/to/protobuf/lib \
    --with-protoc=/path/to/protoc/binary \
    --with-mysql-capi="path_name"
# --with-mysql-capi 為此 lib 路徑
```

其它細節, 遇到再說


## 4.4 Verifying Your Connector/Python Installation

```python
from distutils.sysconfig import get_python_lib
print(get_python_lib())
```