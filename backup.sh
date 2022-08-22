#!/bin/sh
set -e

BACKUP_ROOT="backup"
NOW=$(date +%Y%m%d)
LOG_FILE="/var/log/backup.log"

# 如果没有设置端口 则默认3306
if [ ! ${MYSQL_PORT} ]; then
  MYSQL_PORT="3306"
fi

# 如果没有设置过期天数 则默认7天
if [ ! ${MYSQL_DAYS} ]; then
  MYSQL_DAYS="7"
fi

# 如果没有设置自定义选项，默认使用 -q 选项
if [ ! ${MYSQL_OPTIONS} ]; then
  MYSQL_OPTIONS="-q"
fi

# 创建备份文件夹

mkdir -p /${BACKUP_ROOT}/${NOW}

cd /${BACKUP_ROOT}/${NOW}

# 备份并压缩指定数据库
STARTSTR="$(date +%F%n%T) backup start..."
echo ${STARTSTR} >> $LOG_FILE

mysqldump -h "${MYSQL_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PWD}" -P "${MYSQL_PORT}" ${MYSQL_OPTIONS} --databases "${MYSQL_DB_NAME}" > ${MYSQL_DB_NAME}.sql

tar -czf ${MYSQL_DB_NAME}.tar.gz ${MYSQL_DB_NAME}.sql
rm ${MYSQL_DB_NAME}.sql

ENDSTR="$(date +%F%n%T) backup finished."
echo ${ENDSTR} >> $LOG_FILE

# 删除过期备份
cd /${BACKUP_ROOT}
find . -type d -mmin +1 | xargs rm -rf

