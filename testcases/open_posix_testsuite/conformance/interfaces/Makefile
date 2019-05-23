#
# Read COPYING for licensing details.
#
# Ngie Cooper, June 2010
#


# for MCKERNEL:
include ../../../../include/mk/config.mk
BUILD_MAKE_ENV=		"CC=$(CC) $(CFLAGS) $(LDFLAGS)"

all clean install test:
	@for dir in `ls -d */Makefile 2>/dev/null | sed -e 's,/Makefile$$,,g'`; do \
		$(MAKE) $(BUILD_MAKE_ENV) -C $$dir $@;						  \
	done

distclean-makefiles:
	@find */ -name 'Makefile*' | xargs rm -f
