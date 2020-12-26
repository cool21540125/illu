# EC2

- 2020/10/10


### Initialize

```bash
sudo -i
hostnamectl set-hostname ec2-vm1


### Python3
yum install -y python3


### Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
docker pull python:3
docker pull redis:alpine
docker pull drone/drone:1
docker pull drone/agent:1

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# 此時root因PATH 依然找不到 docker-compose, 但 ec2-user 可


### Certbot
wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/
rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-*.rpm
yum-config-manager --enable epel*
yum install -y certbot python2-certbot-nginx


### Nginx
amazon-linux-extras install -y nginx1
nginx -v  # nginx version: nginx/1.18.0
systemctl start nginx
systemctl enable nginx


### ssh-keygen
exit
ssh-keygen -C "tony@ec2-vm1" -f ~/.ssh/id_rsa -P ''
cat ~/.ssh/id_rsa.pub

mkdir proj
mkdir -p composes/drone composes/redis
```


### AMI spec

- i系列: (資源昂貴又有限)支援 `NVMe`, IOPS 超巨大. 但是開機之後 data 就不見了(被AWS回收了)
- v系列: Memory優化


### EBS spec

- io: 優化磁碟 IO 操作, 可達 64000 iOPS, 但 $ 分成 `容量` && `IO數` 來計費
    - io1
    - io2
- gp: IOPS 隨著 `容量` 增加(無法彈性選擇), 且 IOPS 最高也只有到 16000
    -gp1 這種的好像已經沒了(2020/12)
    -gp2
    -gp3


# Other

額外補充(不知道該不該寫在這)

AWS 似乎有支援 `ceph`(檔案系統), 可支援 `Object Storage` && `Block Storage`
