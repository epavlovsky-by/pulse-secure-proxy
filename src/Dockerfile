# Using fixed version to guarantee versions/architecture compatibility in the future
FROM alpine:3.15

RUN apk add --no-cache nodejs npm tinyproxy procps

# Main repository does not contain these packages
RUN apk add --no-cache openconnect chromium --repository http://dl-cdn.alpinelinux.org/alpine/v3.15/community

COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

ENV PULSE_DIR=/etc/pulse-secure-proxy
RUN mkdir $PULSE_DIR

COPY network/* saml/* env-init.sh entrypoint.sh $PULSE_DIR/
RUN chmod -R +x $PULSE_DIR/

ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
WORKDIR $PULSE_DIR
RUN npm i
RUN npx playwright install chromium

EXPOSE 8888

ENTRYPOINT $PULSE_DIR/entrypoint.sh