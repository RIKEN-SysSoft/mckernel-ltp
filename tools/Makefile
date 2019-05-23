#
#    tools Makefile.
#
#    Copyright (C) 2009, Cisco Systems Inc.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Ngie Cooper, July 2009
#

top_srcdir		?= ..

include $(top_srcdir)/include/mk/testcases.mk

# MCKERNEL:
# Use host compiler for host tools.
ifneq ($(HOSTCC),)
CC			:= $(HOSTCC)
CFLAGS			:= $(HOSTCFLAGS)
LDFLAGS			:= $(HOSTLDFLAGS) -L$(top_srcdir)/hostlib

LIBLTP_DIR		:= $(abs_top_builddir)/hostlib
LIBLTP			:= $(LIBLTP_DIR)/libltp.a
endif

INSTALL_TARGETS		:= *.awk *.pl *.sh html_report_header.txt

INSTALL_DIR		:= bin

# MCKERNEL:
# Override the rule for LIBLTP to link the LTP library created for host.
ifneq ($(HOSTCC),)
MAKE_DEPS		+= $(LIBLTP)
$(LIBLTP): $(LIBLTP_DIR)
	$(MAKE) -C "$^" -f "$(abs_top_srcdir)/hostlib/Makefile" all
endif
INSTALL_TARGETS		+= S99restart_ltp

install: S99restart_ltp

S99restart_ltp: S99restart_ltp.in
	sed -e "s#__LTPROOT__#${prefix}#g" $^ > $@

include $(top_srcdir)/include/mk/generic_trunk_target.mk
