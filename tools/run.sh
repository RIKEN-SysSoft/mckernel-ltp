#!/bin/sh

SCRIPT_PATH=$(readlink -m "${BASH_SOURCE[0]}")
AUTOTEST_HOME="${SCRIPT_PATH%/*/*/*/*}"
export LTPROOT=$AUTOTEST_HOME/ltp/install

ihkosctl=$MCKINSTALL/sbin/ihkosctl

# Prepare working directory
rm -rf $recorddir && mkdir -p $recorddir

$ihkosctl 0 clear_kmsg

# Run LTP
pushd $recorddir > /dev/null
echo "$command_line" > $recorddir/command_line
sudo bash -c " LTPMCEXEC=$MCKINSTALL/bin/mcexec MCEXEC_TIMEOUT=10800 MC_RESET_EACHTIME=0 $LTPROOT/runltp -l LTP_RUN.log -f $recorddir/command_line"
exit_code=$?
popd > /dev/null

# OK/NG decision
rc=0
if [[ $exit_code != 0 ]]; then
    rc=1
fi

# Check if kmsg is empty
$MCKINSTALL/sbin/ihkosctl 0 kmsg > $recorddir/kmsg.log
if [ "`cat $recorddir/kmsg.log | wc -l`" -ne 1 ]; then
    echo "$(basename $0): WARNING: kmsg isn't empty."
fi

# Check if process/thread structs remain
show_struct_process_or_thread="$recorddir/show_struct_process_or_thread.log"
$ihkosctl 0 clear_kmsg
$ihkosctl 0 ioctl 40000000 1
$ihkosctl 0 ioctl 40000000 2
$ihkosctl 0 kmsg > $show_struct_process_or_thread

nprocs=`awk '$4=="processes"{print $3}' $show_struct_process_or_thread`
if [ -n $nprocs ] && [ "$nprocs" != "0" ]; then
    echo "$(basename $0): INFO: $nprocs process(es) remaining"
    rc=1
fi

nthreads=`awk '$4=="threads"{print $3}' $show_struct_process_or_thread`
if [ -n $nthreads ] && [ "$nthreads" != "0" ]; then
    echo "$(basename $0): INFO: $nprocs thread(s) remaining"
    rc=1
fi

exit $rc
