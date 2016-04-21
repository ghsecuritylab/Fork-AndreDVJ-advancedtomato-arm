include ../common.mak

ifeq ($(TCONFIG_BCMARM),y)
DSTDIR = $(INSTALLDIR)/lib/modules/2.6.36.4brcmarm/kernel/fs
endif

install:
	@echo "[exfat] Installing..."
	@install -d $(DSTDIR)
	@cp -f exfat.ko $(DSTDIR)

.phony: install

