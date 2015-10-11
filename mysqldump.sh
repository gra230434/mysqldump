#!/bin/sh
 
#================================================
# shell scrip made by Kevin W.
# 2015.10.07
# to backup mysql
#================================================
 
# set up all the mysqldump options
FILE=backup.sql.`date +"%Y%m%d"`
DATABASE=technology
USER=
PASS=
 
# set up mysqldump
mysqldump --user=${USER} --password=${PASS} --database ${DATABASE} > /backup/mysql/daily/${FILE}
 
# find file in daily
daily14=$(find /backup/mysql/daily/ -type f -ctime 14)
 
if [ ! -z $daily14 ];then
        find /backup/mysql/daily/ -type f -ctime 7 -exec cp {} /backup/mysql/weekly \;
        find /backup/mysql/daily/ -type f -ctime +7 -exec rm {} \;
fi
 
# find file in weekly
week12=$(find /home/backup/technology/mysql/daily/ -type f -ctime 168)
 
if [ ! -z $week12 ];then
        find /backup/mysql/weekly/ -type f -ctime 84 -exec cp {} /backup/mysql/monthly \;
        find /backup/mysql/weekly/ -type f -ctime +84 -exec rm {} \;
fi
 
# delete 超過一年的資料
find /backup/mysql/monthly/ -type f -ctime +365 -exec rm {} \;
 
# set up rsync to my NAS
rsync -a --delete --password-file={資料位置} /backup/ rsync@{IP位置}::NetBackup/