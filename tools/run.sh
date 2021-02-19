#!/bin/sh

# Prepare working directory
rm -rf $recorddir && mkdir -p $recorddir

$MCKINSTALL/sbin/ihkosctl 0 clear_kmsg

# Run LTP
pushd $recorddir > /dev/null
echo "$command_line" > $recorddir/command_line
sudo bash -c "LTPMCEXEC=$MCKINSTALL/bin/mcexec MCEXEC_TIMEOUT=$TIMEOUT_RUN MC_RESET_EACHTIME=0 $AUTOTEST_HOME/ltp/install/runltp -l LTP_RUN.log -f $recorddir/command_line"
exit_code=$?
popd > /dev/null

# OK/NG decision
rc=0
(( exit_code != 0 )) && rc=1

# Check if kmsg is empty
$MCKINSTALL/sbin/ihkosctl 0 kmsg > $recorddir/kmsg.log
[[ "$(cat $recorddir/kmsg.log | wc -l)" != 1 ]] && echo "$(basename $0): WARNING: kmsg isn't empty."

# Check if process/thread structs remain
nproc=$($AUTOTEST_HOME/bin/getnumprocess.sh)
(( nproc != 0 )) && echo "$(basename $0): INFO: $nproc process(es) remaining" && rc=1
nthr=$($AUTOTEST_HOME/bin/getnumthread.sh)
(( nthr != 0 )) && echo "$(basename $0): INFO: $nthr thread(s) remaining" && rc=1

exit $rc
