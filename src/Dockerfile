# Using fixed version to guarantee versions/architecture compatibility in the future
FROM alpine:3.15

# Main repository does not contain openconnect package
RUN apk add --no-cache openconnect --repository http://dl-cdn.alpinelinux.org/alpine/v3.15/community

RUN apk add --no-cache tinyproxy procps

COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

ENV PULSE_DIR=/etc/pulse-secure-proxy
RUN mkdir $PULSE_DIR

COPY network/* env-init.sh entrypoint.sh $PULSE_DIR/
RUN chmod -R +x $PULSE_DIR/

EXPOSE 8888

ENTRYPOINT $PULSE_DIR/entrypoint.sh