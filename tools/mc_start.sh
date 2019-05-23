#! /bin/sh

export PATH=/opt/ppos/sbin:$PATH;

KMOD_DIR=/opt/ppos/kmod;
KERN_IMG=/opt/ppos/attached/kernel/mckernel.img;

ret_err=255

cd ${KMOD_DIR} || exit ${ret_err};
[ ! -f ${KERN_IMG} ] && echo "${KERN_IMG} doesn't exist." && exit ${ret_err}

_parse_ret() {
    str=`$*` || return ${ret_err};
    [ "x${str}" = "xret = 0" ] && return 0;
    return ${ret_err};
}

if [ $# -gt 0 -a "$1" = "-r" ]; then
	echo "Shuting down mckernel.";
	killall -INT mcexec 2>/dev/null && sleep 3;
	rmmod mcctrl.ko;
	rmmod ihk_mic.ko;
	rmmod ihk.ko;
fi;

echo "Starting mckernel." && \
    service mpss unload >/dev/null && \
    insmod ihk.ko && \
    insmod ihk_mic.ko && \
    _parse_ret ihkconfig 0 create && \
    _parse_ret ihkosctl 0 load ${KERN_IMG} && \
    _parse_ret ihkosctl 0 kargs hidos && \
    insmod mcctrl.ko && \
    _parse_ret ihkosctl 0 boot && \
    echo "mckernel started." && \
    exit 0;
exit ${ret_err};

