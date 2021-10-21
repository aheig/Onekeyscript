#!/bin/sh
# File:    /root/backup_shell/backup_log.sh
# Author:  lovelucy,Late Winter
# Version: 1.1.1
 
# Some vars
BIN_DIR="/usr/bin"
BCK_DIR="/backup"
LOG_ERROR="/var/log/web-error_log"
LOG_ACCESS="/var/log/web-access_log"
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
tar -jcvf $BCK_DIR/$DATE_YEAR/$DATE_MONTH/log_$DATE.tar.bz2  $LOG_ERROR $LOG_ACCESS
 
# Clear logs
echo > $LOG_ERROR
echo > $LOG_ACCESS
