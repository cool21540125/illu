# printscreen

- command + shift + 3 > 畫面儲存到桌面 （printscreen)
- command + 
- command + shift + 4 > 選取區塊, 存到桌面

# 安裝 homebrew

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```



```bash
### 從 Catalina 不知道哪版開始, default login shell 改為 zsh
### ~/.bash_profile -> ~/.zshrc
alias ls='ls -G'
alias ll='ls -lG'
alias lla='ll -a'

alias dpsa='docker ps -a'
alias dc='docker-compose'

# 下面這個是 bash 寫法
PS1='[\u@\h \W]\$ '

# zsh 寫法如下
PS1='[%n@%m %1~]$ '
# 更多 zsh 的教學可參考這邊: https://wiki.gentoo.org/wiki/Zsh/Guide 
# 或者直接參考 /etc/zshrc 裡面的寫法
```


```bash
### ~/.vimrc
set expandtab
set tabstop=4
set shiftwidth=4
set nu
set ai
set autoindent
set nocompatible
```



```bash
### 這在幹嘛的我忘了
==> openssl
A CA file has been bootstrapped using certificates from the SystemRoots
keychain. To add additional certificates (e.g. the certificates added in
the System keychain), place .pem files in
  /usr/local/etc/openssl/certs

and run
  /usr/local/opt/openssl/bin/c_rehash

openssl is keg-only, which means it was not symlinked into /usr/local,
because Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries.

If you need to have openssl first in your PATH run:
  echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.bash_profile

For compilers to find openssl you may need to set:
  export LDFLAGS="-L/usr/local/opt/openssl/lib"
  export CPPFLAGS="-I/usr/local/opt/openssl/include"
```


## Tips for mac

```bash
### 修改畫面截圖路徑
$# defaults write com.apple.screencapture location ~/Desktop

### 修改 finder 顯示的 標題名稱 -> 完整路徑檔名
$# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; killall Finder

### jq
$# brew install jq
$# curl https://randomuser.me/api/ | jq  # 交由 jq 做解析(會做 beauty)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1179    0  1179    0     0   1548      0 --:--:-- --:--:-- --:--:--  1547
{
  "results": [
    {
      "gender": "female",
      "name": {
        "title": "Mrs",
        "first": "Crystal",
        "last": "Garcia"
      },
      "location": {
        "street": {
          "number": 2127,
...(略)...

$# $ curl https://randomuser.me/api/ | jq '.results[0].name'  # 可作 filter
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1147    0  1147    0     0   1525      0 --:--:-- --:--:-- --:--:--  1523
{
  "title": "Miss",
  "first": "Mia",
  "last": "Smith"
}
```

```bash
### 自簽憑證位置
/Users/tony/Library/Application Support/Certificate Authority
```


## ACL

- 2020/10/26
- [Set default directory and file permissions](https://discussions.apple.com/thread/4805409)

macbook 至今依舊沒有 Linux 上的 `setfacl` 功能,  可用底下方式代替

```zsh
chmod -R +a "group:GroupName allow read,write,append,readattr,writeattr,readextattr,writeextattr" /Path-To-Shared-Directory

chmod -R +a "group:tony allow read,write,append,readattr,writeattr,readextattr,writeextattr" /var/log
chmod  -R +a 'tony allow write,delete,file_inherit,directory_inherit,add_subdirectory' /var/log
```