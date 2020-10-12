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