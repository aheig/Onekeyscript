#!/bin/sh
# File:    /root/backup_shell/backup_db.sh
# Author:  lovelucy,Late Winter
# Version: 1.1.1
 
# Database info
DB_USER="root"     #数据库用户名
DB_PASS=""     #数据库密码
DB_NAME="all-databases"     #数据库名
 
# Some vars
BIN_DIR="/usr/bin"
BCK_DIR="/backup"     #备份文件存储目录
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
#$BIN_DIR/mysqldump --opt -u$DB_USER -p$DB_PASS $DB_NAME | gzip > $BCK_DIR/$DATE_YEAR/$DATE_MONTH/${DB_NAME}_dump_$DATE.gz
$BIN_DIR/mysqldump --opt -u$DB_USER --all-databases | gzip > $BCK_DIR/$DATE_YEAR/$DATE_MONTH/${DB_NAME}_dump_$DATE.gz
