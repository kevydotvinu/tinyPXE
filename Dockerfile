FROM alpine
RUN apk add --update dnsmasq && \
    rm -rf /var/cache/apk/*
ENTRYPOINT ["/usr/sbin/dnsmasq", "--no-daemon"]
