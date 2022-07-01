FROM alpine:3.16.0

VOLUME /backup

COPY backup.sh /

COPY docker-entrypoint.sh /usr/local/bin/

RUN \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk add tzdata && \
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  apk add --update mysql-client && rm -rf /var/cache/apk/* && \
  chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD tail -f /var/log/backup.log
