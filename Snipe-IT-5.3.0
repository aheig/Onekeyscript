#/bin/bash
#NGINX+PHP8.0+MYSQL8.0

function System-version(){
    systemver=`cat /etc/*release* 2>/dev/null | awk 'NR==1{print}' |sed -r 's/.* ([0-9]+)\..*/\1/'`
    if [[ $systemver = "6" ]];then
        echo "当前是CentOS6系统"
        echo "此脚本仅支持CentOS7系统！！！"
        exit 1
    elif [[ $systemver = "7" ]];then
        echo "当前是CentOS7系统，开始安装..."
    else    
        echo "此脚本仅支持CentOS7系统！！！"
        exit 1
    fi
}
function echo_green {
        echo -e "\033[32m$1\033[0m"
}
System-version

echo '
       _____       _                  __________
      / ___/____  (_)___  ___        /  _/_  __/
      \__ \/ __ \/ / __ \/ _ \______ / /  / /
     ___/ / / / / / /_/ /  __/_____// /  / /
    /____/_/ /_/_/ .___/\___/     /___/ /_/
                /_/
'

echo ""
echo "  Welcome to Snipe-IT Inventory Installer for CentOS7!"
echo ""

# 配置系统环境
setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
tar -czvf /etc/yum.repos.d/repos.tgz /etc/yum.repos.d/
rm -f /etc/yum.repos.d/*.repo /etc/yum.repos.d/*/*.repo
curl -o /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum -y install epel-release wget vim
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum -y install aria2   #aira2c -x8 -o epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum -y install yum-utils net-tools ntpdate expect gcc unzip zlib zlib-devel pcre-devel openssl openssl-devel
cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && ntpdate time1.aliyun.com


# 安装Nginx及PHP8.0
cat > /etc/yum.repos.d/Remi-7.repo << EOF
[Remi]
name=Remi's RPM repository for Enterprise Linux 7 - $basearch
baseurl=https://mirrors.aliyun.com/remi/enterprise/7/safe/\$basearch/
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=http://rpms.remirepo.net/RPM-GPG-KEY-remi

[remi-php80]
name=Remi's PHP 8.0 RPM repository for Enterprise Linux 7 - $basearch
baseurl=https://mirrors.aliyun.com/remi/enterprise/7/php80/\$basearch/
#mirrorlist=http://cdn.remirepo.net/enterprise/7/php80/mirror
enabled=1
gpgcheck=1
gpgkey=http://rpms.remirepo.net/RPM-GPG-KEY-remi

EOF
#yum --showduplicates list nginx | expand   #查看nginx可用的安装包
yum remove -y php-common
yum install -y nginx php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-json php-redis php-ldap php-fileinfo php-intl php-opcache php-mcrypt php-xmlrpc php-sysvsem php-soap php-posix
systemctl start nginx && systemctl enable nginx
systemctl start php-fpm && systemctl enable php-fpm


# 安装MySQL8.0
rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum -y install https://mirrors.aliyun.com/mysql/MySQL-8.0/mysql-community-client-8.0.26-1.el7.x86_64.rpm https://mirrors.aliyun.com/mysql/MySQL-8.0/mysql-community-common-8.0.26-1.el7.x86_64.rpm https://mirrors.aliyun.com/mysql/MySQL-8.0/mysql-community-devel-8.0.26-1.el7.x86_64.rpm https://mirrors.aliyun.com/mysql/MySQL-8.0/mysql-community-libs-8.0.26-1.el7.x86_64.rpm https://mirrors.aliyun.com/mysql/MySQL-8.0/mysql-community-server-8.0.26-1.el7.x86_64.rpm https://mirrors.aliyun.com/mysql/MySQL-8.0/mysql-community-libs-compat-8.0.26-1.el7.x86_64.rpm https://mirrors.aliyun.com/mysql/MySQL-8.0/mysql-community-client-plugins-8.0.26-1.el7.x86_64.rpm 
#yum -y install mysql-server mysql mysql-devel mysql-client mysql-common mysql-libs
#sudo chown -R root:root /var/lib/mysql
#sudo chmod -R 755 /var/lib/mysql
systemctl start mysqld && systemctl enable mysqld
#grep "password is generated" /var/log/mysqld.log | awk '{print $NF}' > /root/mysql-password #提取mysql初始密码

# 清空数据库Root密码
echo 'skip-grant-tables' >> /etc/my.cnf && systemctl restart mysqld
mysql -e "
use mysql;
flush privileges;
set global validate_password.policy=0;
set global validate_password.length=4;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
use mysql;
update user set authentication_string = '' where user = 'root';
flush privileges;
"
sed -i '/^skip-grant-tables$/d' /etc/my.cnf && systemctl restart mysqld
mysql -uroot -e "
set global validate_password.policy=0;
set global validate_password.length=4;
flush privileges;
"
mysql -uroot -e "show databases;"   #查看数据表


# 修改PHP配置
sed -i 's#;date.timezone =#date.timezone = Asia/Shanghai#' /etc/php.ini
sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 20M#' /etc/php.ini
sed -i 's/;listen.owner = php/listen.owner = nginx/' /etc/php-fpm.d/www.conf
sed -i 's/;listen.group = php/listen.group = nginx/' /etc/php-fpm.d/www.conf
sed -i 's/;listen.mode = 0660/listen.mode = 0660/' /etc/php-fpm.d/www.conf
sed -i 's#user = apache#user = nginx#' /etc/php-fpm.d/www.conf
sed -i 's#group = apache#group = nginx#' /etc/php-fpm.d/www.conf
#sed -i 's#listen = 127.0.0.1:9000#listen = /dev/shm/php-fpm.sock#' /etc/php-fpm.d/www.conf
systemctl restart php-fpm && systemctl restart nginx


# 询问是否继续部署网站
echo_green "基础软件安装完毕，是否部署Snipe-IT资产管理系统？(y/n)："
read answer
if [ "$answer" == "y" ]; then
    echo_green "开始部署Snipe-IT资产管理系统"
else
    echo_green "拜拜了"
    exit
fi


# 部署网站业务系统
mkdir /www
wget -O /www/snipe-it-5.3.0.zip https://hub.fastgit.org/snipe/snipe-it/archive/refs/tags/v5.3.0.zip
unzip /www/snipe-it-5.3.0.zip -d /www/
if [ -d "/www/snipe-it-5.3.0" ];then
  echo "下载完成"
else
  echo "snipe-it-5.3.0.zip下载失败"
  exit
fi
mv /www/snipe-it-5.3.0 /www/snipe-it
cd /www/snipe-it
curl -sS https://getcomposer.org/installer | php
cp composer.phar /usr/bin/composer
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
yes | php composer.phar install --no-dev --prefer-source
yes | php composer.phar install --no-dev --prefer-source --ignore-platform-reqs
yes | composer global require laravel/installer
chown -R nginx:nginx storage public/uploads
chmod -R 755 storage public/uploads
cp .env.example .env
IPADDR = $(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | head -n 1)
sed -i "s#APP_URL=null#APP_URL=${IPADDR}#" .env   #修改为本机IP或域名
sed -i "s#APP_TIMEZONE='UTC'#APP_TIMEZONE='Asia/Shanghai'#" .env
sed -i 's#APP_LOCALE=en#APP_LOCALE=zh-CN#' .env
sed -i 's#DB_DATABASE=null#DB_DATABASE=snipe_it#' .env
sed -i 's#DB_USERNAME=null#DB_USERNAME=snipe_it#' .env
sed -i 's#DB_PASSWORD=null#DB_PASSWORD=123456#' .env
php artisan key:generate --force
php artisan migrate --force

cat > /etc/nginx/conf.d/snipe-it.conf << EOF
server {
    listen 80;
    server_name localhost;
 
    root /www/snipe-it/public;
    index index.php index.html index.htm;
    client_max_body_size 20M;
    access_log  /www/wwwlogs/snipeit.log;
    error_log  /www/wwwlogs/snipeit.error.log;  
 
    location =/.env{ 
        return 404; 
    } 
 
    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }
 
    location ~ \.php\$ {
        root /www/snipe-it/public;
        try_files \$uri \$uri/ =404;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
    }
}
EOF
mkdir /www/wwwlogs/ && chown -R nginx:nginx /www
systemctl restart nginx

# 创建数据库、用户及授权
mysql -uroot -e "
create database if not exists snipe_it default charset utf8mb4 collate utf8mb4_unicode_ci;
create user snipe_it@localhost identified by '123456';
grant all privileges on snipe_it.* to snipe_it@localhost;
flush privileges;
"
mysql -uroot -e "show databases;"   #查看数据表
mysql -uroot -e "select user,host from mysql.user;"   #查看数据库用户
