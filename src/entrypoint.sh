#!/bin/sh

/usr/bin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf

run () {
    echo 'Paste DSID cookie here:'
    read DSID_COOKIE
    openconnect --juniper -C "DSID=$DSID_COOKIE" $OPENCONNECT_OPTIONS $VPN_URL
}

until (run); do
  echo "openconnect exited. Restarting process in 60 seconds…" >&2
  sleep 60
done
