#!/bin/sh
# File:    /root/backup_shell/backup_web.sh
# Author:  lovelucy,Late Winter
# Version: 1.1.1
 
# Some vars
BIN_DIR="/usr/bin"
BCK_DIR="/backup"     #备份文件存储目录
WEB_local_DIR="/usr/local"     #网站目录
WEB_www_DIR="/www"     #网站目录
WEB_conf_DIR="/etc/httpd /etc/nginx"     #配置文件路径
EXCLUDE_DIR="/www/pan/uploads"     #不备份的文件夹
DATE=`date +%F`
DATE_YEAR=`date +%Y`
DATE_MONTH=`date +%m`
 
# Make Dir
if test -d $BCK_DIR/$DATE_YEAR/$DATE_MONTH
then
    echo "directory $BCK_DIR/$DATE_YEAR/$DATE_MONTH exists."
else
    echo "directory $BCK_DIR/$DATE_YEAR/$DATE_MONTH does not exists. make dir..."
    mkdir -p $BCK_DIR/$DATE_YEAR/$DATE_MONTH
fi
 
# Backup
tar -jcvf $BCK_DIR/$DATE_YEAR/$DATE_MONTH/web_local_$DATE.tar.bz2 $WEB_local_DIR --exclude=*.log
tar -jcvf $BCK_DIR/$DATE_YEAR/$DATE_MONTH/web_www_$DATE.tar.bz2 $WEB_www_DIR  --exclude=$EXCLUDE_DIR
tar -jcvf $BCK_DIR/$DATE_YEAR/$DATE_MONTH/web_conf_$DATE.tar.bz2 $WEB_conf_DIR
