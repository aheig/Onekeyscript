#!/bin/bash
#backup_mysql_data
#author cy
#2021-02-01
#检查目录权限
BackupDir=/home/backup/
SaveDir=/data/sdv1/backup
fdate=`date "+%Y%m%d%H%M%S"`
YourMySQLPasswd=数据库root密码
chown -R mysql:mysql $BackupDir
chmod -R 775 $BackupDir
chmod -R 775 $SaveDir
#备份database1库
function database1 () {
        echo "`date "+%m %d %H:%M:%S"` 开始备份 database1 数据库" >> $BackupDir/backmysql.log
                if [ ! -d $BackupDir/mysql ];then
                mkdir -p $BackupDir/mysql
                fi
                chown -R mysql:mysql $BackupDir/mysql
        mysqldump -u root -p'$YourMySQLPasswd'  database1 > $BackupDir/mysql/database1_$fdate.sql
        echo "`date "+%m %d %H:%M:%S"` 备份 database1 数据库完成" >> $BackupDir/backmysql.log
}
#备份database2库
function database2 () {
        echo "`date "+%m %d %H:%M:%S"` 开始备份 database2 数据库" >> $BackupDir/backmysql.log
                if [ ! -d $BackupDir/mysql ];then
                mkdir -p $BackupDir/mysql
                fi
                chown -R mysql:mysql $BackupDir/mysql
        mysqldump -u root -p'$YourMySQLPasswd' database2 > $BackupDir/mysql/database2_$fdate.sql
        echo "`date "+%m %d %H:%M:%S"` 备份 database2 数据库完成"  >> $BackupDir/backmysql.log
}
#备份database3库
function database3 () {
        echo "`date "+%m %d %H:%M:%S"` 开始备份 database3 数据库" >> $BackupDir/backmysql.log
                if [ ! -d $BackupDir/mysql ];then
                mkdir -p $BackupDir/mysql
                fi
                chown -R mysql:mysql $BackupDir/mysql
        mysqldump -u root -p'$YourMySQLPasswd' database3 > $BackupDir/mysql/database3_$fdate.sql
        echo "`date "+%m %d %H:%M:%S"` 备份 database3 数据库完成"  >> $BackupDir/backmysql.log
}
#压缩删除备份文件
function compress () {
        echo "`date "+%m %d %H:%M:%S"` 开始压缩完整的数据库 " >> $BackupDir/backmysql.log
                chown -R mysql:mysql $BackupDir
                cd $BackupDir
                tar -cf mysql_$fdate.tar mysql
                if [[ $? -eq 0 && -s mysql_$fdate.tar ]];then
                echo "`date "+%m %d %H:%M:%S"` 完成数据库压缩" >> $BackupDir/backmysql.log
                find $BackupDir -mtime +3 -exec rm -rf{} \;
                fi
                if [ ! -d $SaveDir ];then
                mkdir -p $SaveDir
                fi
                cd $BackupDir
                \cp mysql_$fdate.tar $SaveDir
                echo "`date "+%m %d %H:%M:%S"` 备份数据到 Savedir 完成" >> $BackupDir/backmysql.log
                #判断备份文件数是否大于3
                nuf=`find $SaveDir -name '*.tar' -size +10M|wc -l`
                if [[ $? -eq 0 && $nuf -gt 3 ]];then
                #删除7天之前的数据
                find $SaveDir -name '*.tar' -mtime +7 -exec rm -rf {} \;
                echo "`date "+%m %d %H:%M:%S"` delete nfs than 7 days"  >> $BackupDir/backmysql.log
                fi
        echo `date "+%m %d %H:%M:%S"` "All is OK" >> $BackupDir/backmysql.log
                \cp -r $BackupDir/backmysql.log $SaveDir
}
database1
database2
database3
compress
echo "mysql数据库备份完成"
