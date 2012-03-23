#
#  Author : Ganesh Gudigara
#
#
#
##############################################################################
TOPDIR := $(shell cd ../../ && pwd)
SRCDIR := $(shell pwd)
include $(TOPDIR)/dist/config.mk
export CROSS_COMPILE=$(CROSS)

RELEASE_TMPPATH := $(RELEASE_ROOT)/tmp
TOP_TEMPLATEDIR := $(TOPDIR)/base/template
TOP_TEMPLATEDIR_FSC := $(TOPDIR)/base/template/fs-common
TOP_TEMPLATEDIR_TMPFSC := $(TOPDIR)/base/template/tmpfs-common
TOP_N_TEMPLATEDIR := $(TOPDIR)/base/template/$(PRODUCTNAME)
TOP_NV_TEMPLATEDIR := $(TOPDIR)/base/template/$(PRODUCTNAME)/$(PRODUCTVERSION)

TOP_PRODUCTDIR := $(TOPDIR)/base/products
PRODUCT_FILES := $(shell cat $(TOP_PRODUCTDIR)/$(PRODUCTNAME)-$(PRODUCTVERSION).filelist)
PRODUCT_TMP := $(shell mktemp)

all: $(DESTDIR)/$(PREFIX)/apps $(BOOTLOADER)  $(KERNEL_HEADERS) $(KERNEL) $(KERNEL_MODULES)

$(KERNEL_HEADERS):
	  cd $(KERNELDIR) && make headers_install $(INSTALL_HDR_PATH)=$(DESTDIR)/$(PREFIX)


$(KERNEL_MODULES):
	  cd $(KERNELDIR) && make modules_install $(INSTALL_MOD_PATH)=$(DESTDIR)/$(PREFIX)

$(KERNEL):
	  cd $(KERNELDIR) && make $@ INSTALL_PATH=$(DESTDIR)/$(PREFIX)
$(BOOTLOADER):
	  cd $(BOOTLOADERDIR) && make 

$(DESTDIR)/$(PREFIX)/apps:
	./createbase $(DESTDIR)/$(PREFIX) $(SRCDIR)

release_files:$(RELEASE_ROOT)/$(BOOTLOADER) $(RELEASE_ROOT)/$(KERNEL) $(RELEASE_ROOT)/$(ROOTFS_IMAGE)
	
$(RELEASE_ROOT)/$(KERNEL): $(KERNEL)
		$(INSTALL_CMD) $< $@
	
$(RELEASE_ROOT)/$(BOOTLOADER): $(BOOTLOADER)
		$(INSTALL_CMD) $< $@
	_	
$(RELEASE_ROOT)/$(ROOTFS_IMAGE):
	mv $(RELEASE_TMPPATH) $(RELEASE_TMPPATH).old
	mkdir -p $(RELEASE_TMPPATH)
	basedirs=`cat $(SRC_DIR)/base/base.dirs`
	for i in $(basedirs) \
	do \
	mkdir -p $(RELEASE_TMPPATH)/$$i; \
	done
	$(Q)echo -ne "copying template files....."
	$(Q)$(INSTALL_CMD) $(TOP_TEMPLATEDIR_FSC)/*  $(RELEASE_TMPPATH)
	$(Q)$(INSTALL_CMD) $(TOP_N_TEMPLATEDIR)/fs/* $(RELEASE_TMPPATH)
	$(Q)$(INSTALL_CMD) $(TOP_NV_TEMPLATEDIR)/fs/* $(RELEASE_PATH
 	$(Q)$(INSTALL_CMD) $(TOP_TEMPLATEDIR_TMPFSC)/* $(RELEASE_TMPPATH)
	$(Q)$(INSTALL_CMD) $(TOP_N_TEMPLATEDIR)/tmpfs/* $(RELEASE_TMPPATH)
	$(Q)$(INSTALL_CMD) $(TOP_NV_TEMPLATEDIR)/tmpfs/* $(RELEASE_TMPPATH)
	$(Q)echo "done"
	$(Q)echo -ne "start copying core files...."
	if [ -d $(DESTDIR)/$(CORE_PREFIX) ]; then \
	@(Q)$(INSTALL_CMD) $(DESTDIR)/$(CORE_PREFIX) $(RELEASE_TMPPATH); \
	fi
	cd $(DESTDIR)/$(PREFIX) && tar -czvf $(PRODUCT_TMP) $(PRODUCT_FILES)
	cd $(RELEASE_TMPPATH) && tar -xzvf $(PRODUCT_TMP)
	rm -f $(PRODUCT_TMP)
	$(call build_rfs,$(RELEASE_TMPPATH),$(RFSTYPE),$@)
	
	


