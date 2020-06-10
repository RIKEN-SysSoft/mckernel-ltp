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
[[ $exit_code != 0 ]] && rc=1

# Check if kmsg is empty
$MCKINSTALL/sbin/ihkosctl 0 kmsg > $recorddir/kmsg.log
[[ "$(cat $recorddir/kmsg.log | wc -l)" != 1 ]] && echo "$(basename $0): WARNING: kmsg isn't empty."

# Check if process/thread structs remain
! $AUTOTEST_HOME/bin/getnumprocess.sh && echo "$(basename $0): INFO: $nprocs process(es) remaining" && rc=1
! $AUTOTEST_HOME/bin/getnumthread.sh && echo "$(basename $0): INFO: $nprocs thread(s) remaining" && rc=1

exit $rc
