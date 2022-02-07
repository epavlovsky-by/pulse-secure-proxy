Pulse Secure VPN inside Docker container
===

Usage benefits
---
1. You don't need to install any software directly to your host operating system.

2. Might be convenient if you need to manage multiple VPN connections

3. Split tunnelling - only traffic related to your VPN subnet is routed through it. Everything else goes directly. However, domain names are still resolved by DNS server provided by VPN.


How to use
---
1. Configure .env file with data required to connect to your VPN
2. Run start.sh


Supported architectures
---
1. **x86_64** - for majority of modern computers
2. **aarch64** - for Apple M1 chip based computers
3. **armv7** - for Raspberry PI computers


How can I also route DNS traffic 
---

Known issues
---
Pulse protocol (newer version of Juniper) 