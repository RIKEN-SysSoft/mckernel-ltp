#! /bin/sh

# This script is installed at ${LTPROOT}/bin/.
export LTPROOT=`cd \`dirname $0\`/.. && pwd`

LOG=${LTPROOT}/output/`basename $0`.log
RESTART=${LTPROOT}/output/runltp.restart

ret_err=255

if [ -f ${RESTART} ]; then
    echo "Restarting LTP in the background."
    echo "" >> ${LOG} || exit ${ret_err}
    echo "==== restarted at "`date`" ====" >> ${LOG} || exit ${ret_err}
    eval ${RESTART} >>${LOG} 2>&1 &
else
    echo "Skipped restarting LTP: ${RESTART} doesn't exist."
fi;

