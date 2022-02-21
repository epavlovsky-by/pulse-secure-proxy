Pulse Secure VPN inside Docker container
===

This container acts like an HTTP proxy server for your VPN traffic.


Usage benefits
---
1. You don't need to install any software directly to your host operating system.

2. Might be convenient if you need to manage multiple VPN connections.

3. Split tunnelling - only traffic related to your VPN subnet is routed through it. Everything else goes outside VPN. However, domain names are still resolved by DNS server provided by VPN for now.


How to use
---
1. Build using Docker image by executing **build.sh** script.

2. Run a container:
```
docker run -it --rm --privileged \
           -e VPN_URL="https://mycompany/vpn" \
           -p 8888:8888 \
           pulse-secure-proxy
```


Environment variables
---
* **VPN_URL** - mandatory. Will be prompted on startup if not specified.

* **VPN_USER** - optional. Will be prompted during authentication if required.

* **VPN_PASSWORD** - optional. usage not recommended since sensitive value can stay in command history, .env file, etc. Will be prompted during authentication if required.

* **VPN_SUBNET** - optional. Default value is 10.0.0.0/8.

* **VPN_PROTOCOL** - optional. Default value is "nc". See OpenConnect documentation for available values and description.

* **VPN_SESSION_SECONDS** - optional, default value if 86400 (24 hours).

* **AUTH_TYPE** - optional. Could be either SAML, or COOKIE. Default value is SAML.

* **DSID_COOKIE** - optional. DSID cookie value that is used for authentication. If not specified then will be prompted or obtained according to AUTH_TYPE.


Supported architectures
---
1. **x86_64**
2. **aarch64**


Known issues
---
1. Pulse protocol (newer version of Juniper) is not supported

2. VPN-provider's DNS server is used to resolve all the hostnames

3. Only Microsoft Identity provider is currently supported for SAML authentication. Only Microsoft Authenticator notification-based MFA is implemented. TOTP is in plans.

4. Only HTTP proxy server is added to container. SOCKS is in plans.


How can I also route DNS traffic?
---
You can route traffic (not just DNS) using browser plugins like FoxyProxy, Proxy SwitchyOmega, etc. These plugins allow to choose proxy server based on domain name patterns.


How can I use HTTP proxy for Git over SSH?
---
For example, you can use socat library (needs to be installed in a system) and the following SSH configuration (~/.ssh/config):
```
Host githost.mycompany.com
 User git
 ProxyCommand socat - PROXY:my-proxy-host:%h:%p,proxyport=8888
```