#############################################################################
#
#  Author : Ganesh Gudigara
#
#
#
##############################################################################
TOPDIR := $(shell cd ../../ && pwd)
SRCDIR := $(shell pwd)
include $(TOPDIR)/dist/config.mk

all:$(PATCHKERNEL)

$(PATCHKERNEL):
	    $(call do_untar,$(KERMEL_SRCORIGDIR),(APP),$(APPVERSION),$(BUILD_PRODUCTTOP),$(SRCDIR)); 
	 touch $@; 
	 $(call do_patch, $(BUILDDIR), $(call fllist , $(SRCDIR)/patches/$(APPVERSION)/$(ARCH))) 

