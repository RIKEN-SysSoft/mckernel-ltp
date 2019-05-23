#! /bin/sh

ret_err=255

[ -z "${LTPMCEXEC}" ] && echo "LTPMCEXEC is not set." && exit ${ret_err}
[ ! -f ${LTPMCEXEC} ] && echo "${LTPMCEXEC} doesn't exist." && exit ${ret_err}

_mckernel_reset () {
    sync; sync; sync;
    ### try twice -- resetting mckernel may fail at the first time...
    ${LTPROOT}/bin/mc_start.sh -r || \
	${LTPROOT}/bin/mc_start.sh -r || \
	return ${ret_err}
    return 0
}

SUBCMD=${0%.sh}_sub.sh
TIMEOUT=${MCEXEC_TIMEOUT:-300}
BOMMER_TIMEOUT=`expr ${TIMEOUT} + 5`
BOMB=`pwd`/.timeout.bomb.$$

__bommer () {
    trap "exit" TERM
    sleep ${BOMMER_TIMEOUT}
    if [ -f ${BOMB} ]; then
	rm ${BOMB} || exit 0
	killall -INT ${LTPMCEXEC} 2>/dev/null
	_mckernel_reset
    fi
    exit
}


if [ -z "${LTPMCEXEC}" ]; then
    # exec without bommer.
    exec timeout -s INT ${TIMEOUT}s ${SUBCMD} $*
fi

#exec with bommer.
touch ${BOMB} || exit ${ret_err}
trap "rm -f ${BOMB}; kill -TERM -$$ 2>/dev/null" EXIT

__bommer &
bomb_pid=$!

timeout -s INT ${TIMEOUT}s ${SUBCMD} $*
ret=$?

if [ -f ${BOMB} ]; then
    rm ${BOMB} || exit $ret
    kill -TERM ${bomb_pid} 2>/dev/null

    # reset if timeout
    [ "x${MC_RESET_EACHTIME}" = "x1" -o $ret -eq 124 ] && _mckernel_reset
fi
exit $ret

