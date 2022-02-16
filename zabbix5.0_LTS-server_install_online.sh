#!/bin/bash

#说明：

#1.端口 zabbix-server 10051 agent 10050 mysql 3306 nginx 8050 php 9000

#2.开机自启

#3.用户 密码：数据库：zabbix zabbix web: Admin zabbix

#4.访问 http://'$(hostname -i|grep "\K([0-9]{1,3}[.]){3}[0-9]{1,3}")':8050

#关闭防火墙(安装结束以后再调整具体的防火墙的设置)、关闭selinux 防止后面安装过程中出现奇怪问题

clear

echo -e "\033[33m

--------------------------zabbix5.0.17-server-安装条件----------------------

安装zabbix5.0-server标准版(5.0.17)

适用版本：

内核2.6、3.0 测试正常

只支持处理器x86_64

linux OS版本6、7、8

-

Creator:

反馈：mail: pzl960505@163.com

--------------

----------------------------安装方法-----------------------

1.运行脚本

sh zabbix5.0_LTS-server_install_online.sh

2.根据提示输入以下信息，按回车进行下一步

—

===========================-请按提示输入以下信息-============================

\033[0m

"

sleep 5

echo -e "\033[31m【0】请选项你的OS版本(6或者7或者8)并按回车确认：\033[0m"

read OS

echo -e "\033[31m【1】请定义数据库zabbix用户的密码并按回车键确认：\033[0m"

read zabbix_pwd

echo -e "\033[31m【2】请定义web服务nginx的端口(不建议80)并按回车确认：\033[0m"

read nginx_port

echo -e "\033[31m【3】请定义主机名并按回车键确认：\033[0m"

read set_hostname

echo '即将开始自动安装'

clear

sleep 10

echo '第一步：基本环境配置,更改yum源为阿里源，配置防火墙'

yum install wget -y

wget -O etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && yum makecache fast && yum install centos-release-scl -y

sed -i '1c\#!/usr/bin/python2 -Es' usr/sbin/firewalld && sed -i '1c\#!/usr/bin/python2 -Es' usr/bin/firewall-cmd

systemctl stop firewalld && systemctl disable firewalld

sed -i 's/enforcing/disabled/g' etc/selinux/config

setenforce 0

clear

sleep 5

echo '第二步：下载zabbix官方yum源、下载linux软件集合、修改yum源 [zabbix-frontend] enabled=1，开始安装zabbix-server、zabbix-agent、zabbix-nginx'

rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/"$OS"/x86_64/zabbix-release-5.0-1.el"$OS".noarch.rpm

yum clean all

yum install centos-release-scl -y

sed -i '11s/0/1/g' etc/yum.repos.d/zabbix.repo

yum install zabbix-server-mysql.x86_64 zabbix-agent  zabbix-web-mysql-scl zabbix-nginx-conf-scl -y

clear

sleep 5

echo '第三步：安装mysql，建库给权限、导入数据'

yum install mariadb-server -y

systemctl start mariadb

mysql -e "create database zabbix character set utf8 collate utf8_bin;grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by '$zabbix_pwd';flush privileges;"

zcat usr/share/doc/zabbix-server-mysql-*/create.sql.gz |mysql -uzabbix -p$zabbix_pwd zabbix

clear

sleep 5

echo '第四步：修改配置文件,【时区,web用户、zabbix-server配置、nginx配置文件'

sed -i '/# DBName=/aDBName=zabbix\nDBUser=zabbix\nDBPassword=zabbix' /etc/zabbix/zabbix_server.conf

sed -i '$ a\EnableRemoteCommands=1' /etc/zabbix/zabbix_agentd.conf

sed -i '38,117s/^/#/' /etc/opt/rh/rh-nginx116/nginx/nginx.conf

sed -i '/server {/a\        listen          '$nginx_port';\n        server_name     localhost;' /etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf

sed -i '24c\php_value[date.timezone] = Asia/Shanghai' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf

sed -i '6c\listen.acl_users = apache,nginx' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf

clear

sleep 5

echo '第五步：启动服务,更改主机名为zabbix-server'

systemctl restart zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm mariadb

systemctl enable zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm  mariadb

hostnamectl set-hostname $set_hostname

clear

echo '第六步：开启防火墙，放行相关端口。'

sleep 10

systemctl start firewalld

firewall-cmd --add-port=10050/tcp --zone=public --permanent

firewall-cmd --add-port=10051/tcp --zone=public --permanent

firewall-cmd --add-port=$nginx_port/tcp --zone=public --permanent

firewall-cmd --add-port=3306/tcp --zone=public --permanent

firewall-cmd --reload

clear

sleep 6

echo -e "\033[32m

-------------------------安装完成，zabbix-server系统信息如下----------------------------------

-

-

-

-

0.默认防火墙处于enable的状态

1.端口 zabbix-server 10051 agent 10050 mysql 3306 nginx $nginx_port php 9000

2.访问 http://$(hostname -i|grep -oP "\K([0-9]{1,3}[.]){3}[0-9]{1,3}"):$nginx_port

3.数据库密码为$zabbix_pwd

4.web账号Admin 密码zabbix

5.服务启动|停止|重启的方法:

systemctl enable|start|restart|stop  zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm  mariadb

6.server版本信息：

$(/usr/sbin/zabbix_server -V|head -1)

-

=========================================开始在web端进行配置=====================





url: http://$(hostname -i|grep -oP "\K([0-9]{1,3}[.]){3}[0-9]{1,3}"):$nginx_port

-

-

-

-

\033[0m

"

for time in {10..0}

do

  sleep 1

  echo 系统将在”$time“秒以后重启

done

echo '第六步，系统正在重启'

reboot
