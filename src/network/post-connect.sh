#!/bin/sh 

INTERFACE_READY=$(ip -br addr show | grep tun0)

if [ ! -z "$INTERFACE_READY" ]; then
    /bin/sh $PULSE_DIR/vpnc-script
    /bin/sh $PULSE_DIR/custom-routing.sh
fi