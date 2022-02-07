#!/bin/sh
#
# This script cleans up all routes in a routing table. Then it adds routes for splitting 
# traffic between VPN and standard Ethernet interface. Called by vpnc script during VPN 
# connection setup.
#
# Please note that domain names are still resolved using DNS provided by VPN.
#

# Deleting all routes from routing table
ip route flush table main

# Adding route with scope link for eth0
ip route add 172.17.0.0/16 dev eth0

# Adding default route that will be used for all traffic outside VPN subnet
ip route add 0.0.0.0/0 via 172.17.0.1 dev eth0

# Obtaining IP from VPN interface to route all VPN traffic to
VPN_GATEWAY=$(ip -br addr show | grep tun0 | awk '{print $3}' | cut -d/ -f1)

# Adding route for VPN-related traffic
if [ ! -z "$VPN_GATEWAY" ]; then
    ip route add $VPN_SUBNET via $VPN_GATEWAY dev tun0
fi 