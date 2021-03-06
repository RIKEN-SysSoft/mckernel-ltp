AC_PREREQ(2.61)
AC_INIT([ltp], [LTP_VERSION], [ltp@lists.linux.it])
AC_CONFIG_AUX_DIR([.])
AM_INIT_AUTOMAKE
AC_CONFIG_HEADERS([include/config.h])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_FILES([ \
    include/mk/config.mk \
    include/mk/config-openposix.mk \
    include/mk/features.mk \
    lib/ltp.pc \
    m4/Makefile \
    execltp \
])

AM_MAINTAINER_MODE([enable])

AM_CONDITIONAL(CROSS_COMPILATION, test x$cross_compiling = xyes)

AC_CANONICAL_HOST

AC_PROG_CC
# <= autoconf 2.61 doesn't have AC_PROG_AR, but 2.63 has it. Not sure about
# 2.62.
AC_DEFUN([AC_PROG_AR], [AC_CHECK_TOOL(AR, ar, :)])
AC_PROG_AR
AC_PROG_LEX
AC_PROG_RANLIB
AC_DEFUN([AC_PROG_STRIP], [AC_CHECK_TOOL(STRIP, strip, :)])
AC_PROG_STRIP
AC_PROG_YACC

# MCKERNEL:
# Compiler related options for host
AC_ARG_VAR([HOSTCC], [CC for host])
AC_ARG_VAR([HOSTCFLAGS], [CFLAGS for host])
AC_ARG_VAR([HOSTLDFLAGS], [LDFLAGS for host])
AC_DEFUN([AC_PROG_HOSTCC], [AC_CHECK_TOOL(HOSTCC, gcc, :)])
AC_PROG_HOSTCC

AC_PREFIX_DEFAULT(/opt/ltp)

AC_CHECK_HEADERS([ \
    ifaddrs.h \
    keyutils.h \
    linux/can.h \
    linux/dccp.h \
    linux/cryptouser.h \
    linux/genetlink.h \
    linux/keyctl.h \
    linux/if_alg.h \
    linux/if_packet.h \
    linux/if_ether.h \
    linux/mempolicy.h \
    linux/module.h \
    linux/netlink.h \
    linux/userfaultfd.h \
    mm.h \
    netinet/sctp.h \
    pthread.h \
    sys/epoll.h \
    sys/fanotify.h \
    sys/inotify.h \
    sys/prctl.h \
    sys/shm.h \
    sys/ustat.h \
    sys/xattr.h \
])

AC_CHECK_FUNCS([ \
    epoll_pwait \
    execveat \
    fallocate \
    fchownat \
    fstatat \
    kcmp \
    mkdirat \
    mknodat \
    openat \
    preadv \
    preadv2 \
    profil \
    pwritev \
    pwritev2 \
    readlinkat \
    renameat \
    renameat2 \
    sched_getcpu \
    sigpending \
    splice \
    stime \
    syncfs \
    sync_file_range \
    tee \
    unshare \
    ustat \
    vmsplice \
])

# Tools knobs

# Expect
AC_ARG_WITH([bash],
  [AC_HELP_STRING([--with-bash],
    [have the Bourne Again SHell interpreter (default=no)])],
  [with_bash=yes],
)
if test "x$with_bash" = xyes; then
    AC_SUBST([WITH_BASH],["yes"])
else
    AC_SUBST([WITH_BASH],["no"])
fi

AC_ARG_WITH([expect],
  [AC_HELP_STRING([--with-expect],
    [have the Tcl/expect library (default=yes)])],
  [with_expect=yes],
  [with_expect=no]
)
if test "x$with_expect" = xyes; then
    AC_SUBST([WITH_EXPECT],["yes"])
else
    AC_SUBST([WITH_EXPECT],["no"])
fi

# Numa
AC_ARG_WITH([numa],
  AC_HELP_STRING([--without-numa],
    [without numa support (default=no)]),
  [with_numa=no],
  [with_numa=yes]
)

# Perl
AC_ARG_WITH([perl],
  [AC_HELP_STRING([--with-perl],
    [have a perl interpreter (default=yes)])],
  [with_perl=yes],
  [with_perl=no]
)
if test "x$with_perl" = xyes; then
    AC_SUBST([WITH_PERL],["yes"])
else
    AC_SUBST([WITH_PERL],["no"])
fi

# Python
AC_ARG_WITH([python],
  [AC_HELP_STRING([--with-python],
    [have a python interpreter (default=yes)])],
  [with_python=yes],
  [with_python=no]
)
if test "x$with_python" = xyes; then
    AC_SUBST([WITH_PYTHON],["yes"])
else
    AC_SUBST([WITH_PYTHON],["no"])
fi

# TI RPC
AC_ARG_WITH([tirpc],
  AC_HELP_STRING([--without-tirpc],
    [without libtirpc support (default=no)]),
  [with_tirpc=no],
  [with_tirpc=yes]
)
# END tools knobs

# Testsuites knobs

AC_ARG_WITH([open-posix-testsuite],
  [AC_HELP_STRING([--with-open-posix-testsuite],
    [compile and install the open posix testsuite (default=no)])],
  [with_open_posix_testsuite=$withval]
)
if test "x$with_open_posix_testsuite" = xyes; then
    AC_SUBST([WITH_OPEN_POSIX_TESTSUITE],["yes"])
else
    AC_SUBST([WITH_OPEN_POSIX_TESTSUITE],["no"])
fi

# testcases/realtime requires bash and python.
if test "x$with_bash" = xyes && test "x$with_python" = xyes; then
    AC_ARG_WITH([realtime-testsuite],
      [AC_HELP_STRING([--with-realtime-testsuite],
        [compile and install the realtime testsuite (default=no)])],
      [with_realtime_testsuite=yes]
    )
fi
if test "x$with_realtime_testsuite" = xyes; then
    AC_SUBST([WITH_REALTIME_TESTSUITE],["yes"])
    # Run configure on testcases/realtime as well.
    AC_CONFIG_SUBDIRS([testcases/realtime])
else
    AC_SUBST([WITH_REALTIME_TESTSUITE],["no"])
fi

AC_CONFIG_SUBDIRS([utils/ffsb-6.0-rc2])

AC_CONFIG_COMMANDS([syscalls.h], [cd ${ac_top_srcdir}/include/lapi/syscalls; ./regen.sh])

# custom functions
LTP_CHECK_ACL_SUPPORT
LTP_CHECK_ATOMIC_MEMORY_MODEL
LTP_CHECK_BUILTIN_CLEAR_CACHE
LTP_CHECK_CAPABILITY_SUPPORT
LTP_CHECK_CC_WARN_OLDSTYLE
LTP_CHECK_CLONE_SUPPORTS_7_ARGS
LTP_CHECK_CRYPTO
LTP_CHECK_FIDEDUPE
LTP_CHECK_FORTIFY_SOURCE
LTP_CHECK_FS_IOC_FLAGS
LTP_CHECK_FTS_H
LTP_CHECK_IF_LINK
LTP_CHECK_IOVEC
LTP_CHECK_KCMP_TYPE
LTP_CHECK_KERNEL_DEVEL
LTP_CHECK_KEYUTILS_SUPPORT
LTP_CHECK_LINUX_PTRACE
LTP_CHECK_LINUXRANDOM
LTP_CHECK_MADVISE
LTP_CHECK_MKDTEMP
LTP_CHECK_MMSGHDR
LTP_CHECK_MREMAP_FIXED
LTP_CHECK_NOMMU_LINUX
LTP_CHECK_PERF_EVENT
LTP_CHECK_PRCTL_SUPPORT
LTP_CHECK_RLIMIT64
LTP_CHECK_SECUREBITS
LTP_CHECK_SELINUX
LTP_CHECK_SIGNAL
LTP_CHECK_STATX
LTP_CHECK_SYNC_ADD_AND_FETCH
LTP_CHECK_SYSCALL_EVENTFD
LTP_CHECK_SYSCALL_FCNTL
LTP_CHECK_SYSCALL_MODIFY_LDT

if test "x$with_numa" = xyes; then
	LTP_CHECK_SYSCALL_NUMA
	numa_error_msg="test requires libnuma >= 2 and it's development packages"
else
	numa_error_msg="NUMA support was disabled during build"
fi
AC_DEFINE_UNQUOTED(NUMA_ERROR_MSG, ["$numa_error_msg"], [Error message when no NUMA support])

LTP_CHECK_SYSCALL_PERF_EVENT_OPEN
LTP_CHECK_SYSCALL_QUOTACTL
LTP_CHECK_SYSCALL_SIGNALFD
LTP_CHECK_SYSCALL_UTIMENSAT
LTP_CHECK_TASKSTATS
LTP_CHECK_TIME
LTP_CHECK_TIMERFD
test "x$with_tirpc" = xyes && LTP_CHECK_TIRPC
LTP_CHECK_TPACKET_V3
LTP_CHECK_UNAME_DOMAINNAME
LTP_CHECK_XFS_QUOTACTL
LTP_CHECK_X_TABLES
LTP_DETECT_HOST_CPU

AC_OUTPUT
