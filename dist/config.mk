###############################################################################
#
#   Author      :     Ganesh Gudigara
#   Description :     Configuration for Building the Deployment and
#                     Other SubSystem.
#    		      
#
#    		      CopyRight(C)  Ganesh Gudigara <gudigara.ganesh@gmail.com>      
#
#
#
################################################################################

#  ARCH - represents which platorm we are building
#           example: arm,x8,mips,powerpc
#           we have default target as ARM
#           override this by typing "make ARCH=x86


include $(TOPDIR)/dist/defaults

############################################################################
#ARCH specific here
# most of the time build machine is x86
############################################################################

BUILD_MACHINE := $(shell uname -m)-linux
#HOST_MACHINE := $(shell uname -m)-linux
ifeq ($(HOST_MACHINE),)
HOST_MACHINE := $(ARCH)-linux
endif
APP_PREFIX := --prefix=$(PREFIX)
CONFIGTARGET := ./configure   --host=$(HOST_MACHINE) --target=$(ARCH)-linux  --build=$(BUILD_MACHINE)


LINUXINCLUDES := $(KERNELDIR)/include
CFLAGS += -I$(DESTDIR)/$(ROOT_BASE)/include -I$(DESTDIR)/$(PREFIX)/include -I$(DESTDIR)/$(CORE_PREFIX)/include -I.
CXXFLAGS += -I$(DESTDIR)/$(ROOT_BASE)/include -I$(DESTDIR)/$(PREFIX)/include -I$(DESTDIR)/$(CORE_PREFIX)/include -I.
CPPFLAGS += -I$(DESTDIR)/$(ROOT_BASE)/include -I$(DESTDIR)/$(PREFIX)/include -I$(DESTDIR)/$(CORE_PREFIX)/include -I.
LDFLAGS +=  -L$(DESTDIR)/$(PREFIX)/lib



############################################################################
# After Target specific
############################################################################

CFLAGS +=  -I$(TOOLCHAINDIR)/include  -I$(PREFIX)/usr/include
CXXFLAGS += -I$(TOOLCHAINDIR)/include -I$(PREFIX)/usr/include
CPPFLAGS += -I$(TOOLCHAINDIR)/include  -I$(PREFIX)/usr/include
LDFLAGS +=  -L$(TOOLCHAINDIR)/lib
LIBS     += $(LDFLAGS)
CC  := $(CROSS)gcc
CXX := $(CROSS)g++
AS := $(CROSS)as
RANLIB := $(CROSS)ranlib
AR := $(CROSS)ar
LD := $(CROSS)ld
STRIP := $(CROSS)strip
OBJCOPY := $(CROSS)objcopy
NM := $(CROSS)nm
HOSTCC := gcc
HOSTCXX := g++
CFLAGS += $(EXTRACFLAGS)
LDFLAGS += $(EXTRALDFLAGS)
LIBS += $(EXTRALIBS)
CXXFLAGS += $(EXTRACXXFLAGS)
XFLAGS := --with-x --with-x-libs=$(PREFIX)/X11R6/lib --with-x-include=$(PREFIX)/X11R6/include --x-includes=$(PREFIX)/X11R6/include --x-libraries=$(PREFIX)/X11R6/lib
X_LIBS  := -L$(PREFIX)/X11R6/lib -lxcb -lxcb-xlib -lXau -lXdmcp -lX11 -lXext -lXt -lSM -lICE 

ifeq ($(X11),1)
EN_X11 := $(XFLAGS)
else
EN_X11 := --without-x
endif
CONFIGTARGET += $(EN_X11)

######################################################################
# user has to say type of library he wants to build
#######################################################################

ifeq ($(LIBTYPE),shared)
LIB_SHARED_CFG := --enable-shared 
LIBEXT = .so
else 
ifeq ($(LIBTYPE), both)
LIB_SHARED_CFG := --enable-static --enable-shared
else
LIB_SHARED_CFG := --enable-static --enable-shared
#--disable-shared
LIBEXT = .a
endif
ifeq ($(LIBTYPE),static)
LIB_SHARED_CFG := --enable-static --disable-shared 
LIBEXT = .a
endif
endif

###########################################################33
#
#  define custom defs
###################################################

CONFIGTARGET += $(LIB_SHARED_CFG)


################################################################
# export global variables
#################################################################

export MESA_LIB    := Mesa-7.4
export MESASRCPATH := $(BUILD_TOPDIR)/$(PRODUCT)-$(PRODUCTVERSION)/$(MESA_LIB)
export PKG_CONFIG_PATH=$(DESTDIR)/$(PREFIX)/lib/pkgconfig
export PKG_CONFIG=$(DESTDIR)/$(PREFIX)/bin/pkg-config

export CORE_PREFIX MOD_PREFIX KERNELDIR GCCVERSION  TOOLCHAIN PREFIX ROOTPREFIX HOSTCC HOSTCXX ARCH  CROSS AS AR LD RANLIB CC CXX  CFLAGS CXXFLAGS CPPFLAGS  LDFLAGS  LIBS STRIP OBJCOPY NM CONFIGTARGET PKG_CONFIG PKG_CONFIG_PATH XFLAGS  LIB_SHARED_CFG CONFIGTARGET LIBEXT HOST_MACHINE BUILD_MACHINE APP_PREFIX X_LIBS
.PHONY:checkuser all
