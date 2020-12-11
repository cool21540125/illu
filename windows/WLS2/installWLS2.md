# WLS2

- 2020/12/11


## 想安裝 venv for python3

- [“E: Unable to locate package python-pip” on Ubuntu 18.04](https://stackoverflow.com/questions/55422929/e-unable-to-locate-package-python-pip-on-ubuntu-18-04)
- [Installing venv for python3 in WSL (Ubuntu)](https://stackoverflow.com/questions/61528500/installing-venv-for-python3-in-wsl-ubuntu)

```bash
# Python 3.8.2
sudo apt-get install -y software-properties-common
sudo apt-add-repository universe
sudo apt-get update
sudo apt-get install -y python3-pip
sudo python3 -m pip install virtualenv
# 建立 virtualenvs 的家
mkdir ~/.storevirtualenvs

# 上面都是一次式

# 建立各種虛擬環境目錄
virtualenv -p python3 <YourVenvName>

# 啟用虛擬環境
source <YourVenvName>/bin/activate

# 離開許你環境
deactivate
```