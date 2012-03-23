###############################################################################
#
#   Author      :     Ganesh Gudigara
#   Description :      Building the Deployment and
#                     Other SubSystem.
#    		      
#
#    		      CopyRight(C)  Ganesh Gudigara <gudigara.ganesh@gmail.com>      
#
#
#
################################################################################

include $(TOPDIR)/dist/functions
export OUT = $(OUTPUT)
export ROOTAPP = $(APP)-$(APPVERSION)
BUILD_PRODUCTTOP := $(BUILD_TOPDIR)/$(PRODUCT)-$(PRODUCTVERSION)
BUILDDIR  := $(BUILD_PRODUCTTOP)/$(ROOTAPP)
SRC_ORIGDIR := $(SRCDIR)/orig/$(APPVERSION)
PATCHED := $(BUILD_PRODUCTTOP)/.patch-$(PRODUCT)-$(PRODUCTVERSION)-$(ROOTAPP)

ifeq ($(HOST_MACHINE),)
HOST_MACHINE := $(ARCH)-linux
endif

ifeq ($(MAKE_FILE), )
MAKE_FILE=Makefile
endif

CONFIGTARGET += $(APP_PREFIX) 
ifeq ($(CC_OPTIONS), 1)
CONFIGTARGET += CC=$(CC) CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
endif
MKFILE := $(BUILDDIR)/$(MAKE_FILE)

ifeq ($(PKG_CONFIG),)
export PKG_CONFIG := pkg-config
endif


.PHONY:   
all: $(OUT) install $(OUT_EXTRA)

$(TOOLCHAINDIR):
		@echo "please setup toolchain directory properly"
		@exit 1		




$(BUILD_PRODUCTTOP):
		@mkdir -p $@

$(INSTALL_TOPDIR):
		@mkdir -p $@

$(DESTDIR):$(INSTALL_TOPDIR)
		$(call create_base,$(DESTDIR)/core,$(TOPDIR))
		$(call create_base,$(DESTDIR)/$(ROOT_BASE),$(TOPDIR))


$(PATCHED):
	    $(call do_untar,$(SRC_ORIGDIR),$(APP),$(APPVERSION),$(BUILD_PRODUCTTOP),$(SRCDIR)); 
	 touch $@; 
	 $(call do_patch, $(BUILDDIR), $(call fllist , $(SRCDIR)/patches/$(APPVERSION)/$(ARCH))) 
	



$(MKFILE):
	$(CC) test.c $(CFLAGS) $(LIBS);
	$(call verifyprefix, $(PREFIX), $(DESTDIR)/$(PREFIX));
	if [ -d $(SRCDIR)/defs/$(APPVERSION) ]; then \
	cp $(SRCDIR)/defs/$(APPVERSION)/cache $(BUILDDIR); \
	cd $(BUILDDIR) && $(CONFIGTARGET)  --cache-file=cache; \
	else \
	cd $(BUILDDIR) && $(CONFIGTARGET); \
	fi


$(OUT):$(TOOLCHAINDIR) $(BUILD_PRODUCTTOP)   $(PATCHED) $(INITBUILD) $(MKFILE)
	$(Q)cd $(BUILDDIR) && make $(MAKE_OPTIONS)


install : $(INSTALL_TOPDIR) $(OUT)
	$(Q)cd $(BUILDDIR) && make install $(MAKE_OPTIONS)

clean:
	$(Q)$(call check_make_cmd, $(BUILDDIR),$@,$(MAKE_FILE))


distclean:
	$(Q)rm -f   $(PATCHED);	
	$(Q)rm -f   $(OUT);
	$(Q)rm -rf  $(BUILDDIR);

runconfig:
	  cd $(BUILDDIR) && $(CONFIGTARGET)
