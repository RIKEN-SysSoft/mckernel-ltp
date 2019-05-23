#
# Read COPYING for licensing details.
#
# Ngie Cooper, June 2010
#

-include ../../../include/mk/config-openposix.mk

top_srcdir?=	..

srcdir=		$(top_srcdir)/tools


# MCKERNEL:
# Build host tools with a host compiler
include ../../../include/mk/config.mk
ifneq ($(HOSTCC),)
CC			:= $(HOSTCC)
CFLAGS			:= $(HOSTCFLAGS)
LDFLAGS			:= $(HOSTLDFLAGS)
endif


all: ../bin/t0

clean:
	@rm -f ../bin/t0

../bin:
	mkdir $@

../bin/t0: ../bin $(srcdir)/t0.c
	@$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(srcdir)/t0.c $(LDLIBS)
