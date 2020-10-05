FROM alpine

MAINTAINER Vinu K <vinu@gnulinuxmate.com>

RUN apk add --update apache2 && \
    rm -rf /var/cache/apk/* && \
    sed -i 's/Listen 80[[:space:]]*$/Listen 8080/' /etc/apache2/httpd.conf

ENTRYPOINT ["/usr/sbin/httpd", "-DFOREGROUND", "-e", "debug"]
