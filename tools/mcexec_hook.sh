#!/usr/bin/bash

ret_err=255

[ -z "${LTPMCEXEC}" ] && echo "LTPMCEXEC is not set." && exit ${ret_err}
[ ! -f ${LTPMCEXEC} ] && echo "${LTPMCEXEC} doesn't exist." && exit ${ret_err}

SUBCMD=${0%.sh}_sub.sh
TIMEOUT=${MCEXEC_TIMEOUT:-300}

# TODO: kill -9 $((-$pgid))
timeout -s 9 ${TIMEOUT}s ${SUBCMD} $*
ret=$?

exit $ret

