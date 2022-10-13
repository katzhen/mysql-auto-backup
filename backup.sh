#!/bin/sh
set -e

BACKUP_ROOT="backup"
MONTH=$(date +%Y%m)
DAY=$(date +%Y%m%d)
LOG_FILE="/var/log/backup.log"


DIR="/${BACKUP_ROOT}/${MONTH}"
FILENAME="${MYSQL_DB_NAME}_${DAY}"

# 创建文件夹并跳转
mkdir -p $DIR
cd $DIR

# 备份并压缩指定数据库
STARTSTR="$(date +%F%n%T) backup start..."
echo ${STARTSTR} >> $LOG_FILE

mysqldump -h "${MYSQL_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PWD}" -P "${MYSQL_PORT}" ${MYSQL_OPTIONS} --databases "${MYSQL_DB_NAME}" > ${FILENAME}.sql

tar -czf $DIR/${FILENAME}.tar.gz ${FILENAME}.sql
rm ${FILENAME}.sql

ENDSTR="$(date +%F%n%T) backup finished."
echo ${ENDSTR} >> $LOG_FILE

# 删除过期备份
find /$BACKUP_ROOT -type d -mtime +${MYSQL_DAYS} -mindepth 1 | xargs rm -rf
