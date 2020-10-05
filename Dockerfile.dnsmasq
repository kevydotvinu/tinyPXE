FROM alpine

MAINTAINER Vinu K <vinu@gnulinuxmate.com>

RUN apk add --update dnsmasq && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/sbin/dnsmasq", "--no-daemon"]
