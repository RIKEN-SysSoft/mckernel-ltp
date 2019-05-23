#! /bin/sh

ret_err=255

[ -z "${LTPROOT}" ] && echo "LTPROOT is not set." && exit ${ret_err}

NEXT=${LTPROOT}/output/alltests.next
TMP=${LTPROOT}/output/alltests.tmp

trap "rm -f ${TMP}" EXIT

if [ -f ${NEXT} ]; then
    cp -f ${NEXT} ${TMP} || exit ${ret_err}
    sed -e '1d' ${TMP} > ${NEXT}
    diff ${TMP} ${NEXT} >/dev/null && exit ${ret_err}
fi
exit 0

