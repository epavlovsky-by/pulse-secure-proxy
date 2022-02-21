#!/bin/sh

source $PULSE_DIR/env-init.sh

/usr/bin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf

dsid_auth() {
  echo -n 'Enter DSID cookie value: '
  read -s DSID_COOKIE
}

saml_auth() {
  echo '...'
}

authenticate() {
  case $AUTH_TYPE in 
    SAML)
      saml_auth
      ;;
    COOKIE)
      dsid_auth
      ;;
  esac
}

connect() {
  if [ -z $DSID_COOKIE ]; then
    authenticate
  fi
  
  openconnect -C "DSID=$DSID_COOKIE" \
              --script=$PULSE_DIR/post-connect.sh \
              --protocol=$VPN_PROTOCOL \
              --reconnect-timeout $VPN_SESSION_SECONDS \
              $VPN_URL

  DSID_COOKIE=
}

until (connect); do
  error_msg 'Openconnect exited. Restarting process in 60 seconds.'
  sleep 60
done
