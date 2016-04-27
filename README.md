# AndreDVJ's AdvancedTomato-ARM #

AdvancedTomato-ARM firmware forked off Jacky's AdvancedTomato-ARM (which is a fork of Tomato-ARM by Shibby).

This is my personal fork, where I attempt to fix issues, make small adjustments, update open-source components if possible, and cherry-pick fixes from others.
This repository, while I try to keep aligned to Shibby's as much as possible, it has diverted already as some components are newer versions.

A summary of changes from Shibby so far:

* Tweaks on ~/router/Makefile to parallelize/speed up build as much as possible
* Tweaks on ~/router/Makefile to help with compilation failures
* Tweaks on stop_transmission.sh script
* Updated entware.sh script
* wanuptime code is slightly different, though functionality is the same
* Updated miniupnpd
* Updated gmp / nettle
* Updated dnscrypt
* Updated libevent
* Updated libusb (to a somewhat not that old version)
* Updated dropbear
* Updated NTFS-3G driver
* Updated dnsmasq
* Updated nano
* Removed wireless antenna options and nvram values, as they're pointless on ARM routers.
* Other cherry-picked tweaks and fixes from many other repositories. See commits for history.

Some of these changes are functionally pointless, but may offer potential bug and security fixes.
Firmware size increased around 100K compared to Shibby builds. Should not be an issue to routers with 32MB of flash memory and beyond.

I only have a Netgear R7000 router, so I don't have any other unit to test my builds. Build/flash at your own risk.

If you see any issues or want to request a specific build, please let me know.