# Using fixed version to guarantee versions/architecture compatibility in the future
FROM alpine:3.15

# Main repository does not contain openconnect package
RUN apk add --no-cache openconnect --repository http://dl-cdn.alpinelinux.org/alpine/v3.15/community

RUN apk add --no-cache tinyproxy procps

COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY custom-routing.sh /etc/vpnc/custom-routing.sh
RUN chmod 755 /etc/vpnc/custom-routing.sh

# vpnc-script version 2022
COPY vpnc-script /etc/vpnc/vpnc-script
RUN chmod 755 /etc/vpnc/vpnc-script

EXPOSE 8888

ENTRYPOINT ["/entrypoint.sh"]