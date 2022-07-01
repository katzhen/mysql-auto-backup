### 目录下创建日志文件

```
touch logs/backup.log
```

### 环境配置

|     变量      | 说明                            | 是否可控 | 默认值    |
| :-----------: | :------------------------------ | :------: | --------- |
|  MYSQL_DAYS   | 备份保存天数                    |    √     | 7         |
| CRONTAB_TIME  | 任务cron，默认为每天5点备份一次 |    √     | 0 5 * * * |
|  MYSQL_HOST   | 地址                            |    ×     |           |
|  MYSQL_PORT   | 端口                            |    √     | 3306      |
|  MYSQL_USER   | 用户名                          |    ×     |           |
|   MYSQL_PWD   | 密码                            |    ×     |           |
| MYSQL_DB_NAME | 备份数据库名称                  |    ×     |           |



### 构建镜像并启动容器

```
docker-compose up -d --build
```

### 查看日志

```
docker logs --tail=10 -f mysql_backup
```

