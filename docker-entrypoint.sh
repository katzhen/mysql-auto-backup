#!/bin/sh
set -e

if [ -z "$MYSQL_HOST" ]; then 
  echo >&2 '缺少环境变量 MYSQL_HOST'
  exit 1
fi

if [ -z "$MYSQL_USER" ]; then 
  echo >&2 '缺少环境变量 MYSQL_USER'
  exit 1
fi

if [ -z "$MYSQL_PWD" ]; then 
  echo >&2 '缺少环境变量 MYSQL_PWD'
  exit 1
fi

if [ -z "$MYSQL_DB_NAME" ]; then 
  echo >&2 '缺少环境变量 MYSQL_DB_NAME'
  exit 1
fi

# 如果没有设置间隔时间 默认每天凌晨5点备份
if [ -z "$CRONTAB_TIME" ]; then 
  CRONTAB_TIME="0       5       *       *       *      "
fi

# 配置 crontab 自动任务
CRONTAB_STR="${CRONTAB_TIME} /bin/sh /backup.sh"
echo "${CRONTAB_STR}" > /etc/crontabs/root

# 启动 crond
crond start

echo "$(date +%F%n%T) backup task start." >> /var/log/backup.log
exec "$@"