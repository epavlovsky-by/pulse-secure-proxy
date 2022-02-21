#!/bin/sh

error_msg() {
  echo -e "\e[1;31m$1\e[0m" >&2
}

if [ -z "$VPN_SUBNET" ]; then
    export VPN_SUBNET=10.0.0.0/8
fi

if [ -z "$VPN_PROTOCOL" ]; then
    export VPN_PROTOCOL=nc
fi

if [ -z "$VPN_SESSION_SECONDS" ]; then
    # Default session timeout is 24 hours
    export VPN_SESSION_SECONDS=86400
fi

if [ -z "$AUTH_TYPE" ]; then
    export AUTH_TYPE="SAML"
fi

if [ $AUTH_TYPE != 'SAML' ] && [ $AUTH_TYPE != 'COOKIE' ]; then
    error_msg 'AUTH_TYPE must be on of: SAML, COOKIE.'
    exit 1
fi

if [ -z "$VPN_URL" ]; then
    echo -n 'Enter VPN address: '
    read VPN_URL
    export VPN_URL
fi