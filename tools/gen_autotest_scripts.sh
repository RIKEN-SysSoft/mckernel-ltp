#!/bin/sh

# Usage: cd <ltp-install>/bin && cat ../runtest/{syscalls,ipc,mm,hugetlb} | ./gen_autotest_scripts.sh
# This puts scritps on <autotest>/data/scripts/
#
# Usage of the generated scripts:
# McKernel run: bash -x <autotest>/data/script/ltp-<test_name>

SCRIPT_PATH=$(readlink -m "${BASH_SOURCE[0]}")
AUTOTEST_HOME="${SCRIPT_PATH%/*/*/*/*}"
scriptdir="$AUTOTEST_HOME/data/scripts"

mkdir -p $scriptdir
rm -f $scriptdir/ltp-*

while read testcase command_line; do
    [[ $testcase =~ ^#|^[[:space:]]*$ ]] && continue
    script=$scriptdir/ltp-$testcase

cat > $script <<'EOF'
#!/usr/bin/bash

set -x

SCRIPT_PATH=$(readlink -m "${BASH_SOURCE[0]}")
AUTOTEST_HOME="${SCRIPT_PATH%/*/*/*}"
. $AUTOTEST_HOME/bin/config.sh

EOF

cat >> $script <<EOF
testcase=$testcase
command_line=$command_line

EOF

cat >> $script <<'EOF'
recorddir=$WORKDIR/output/ltp-$testcase
command_line="$testcase $command_line"

EOF

cat >> $script <<'EOF'
. $AUTOTEST_HOME/ltp/install/bin/run.sh
EOF

chmod +x $script
done
