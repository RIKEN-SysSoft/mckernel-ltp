#!/usr/bin/awk -f

# Usage: cd <ltp-install>/bin && cat ../runtest/{syscalls,ipc,mm,hugetlb} | ./gen_autotest_scripts.awk
# This puts scritps on <autotest>/data/scripts/
#
# Usage of the generated scripts:
# McKernel run: bash -x <autotest>/data/script/ltp-<test_name>

BEGIN {
    "dirname " ARGV[0] | getline dir;
    "cd " dir "/../../.. && pwd -P" | getline autotest_home;
    "cd " dir "/.. && pwd -P" | getline ltp_install;

    scriptdir = sprintf("%s/data/scripts", autotest_home);
    system("rm -f " scriptdir "/ltp-*");
}

!/^#|^$/ {
    testcase = $1;
    command_line = $0;
    script = sprintf("%s/ltp-%s", scriptdir, testcase);

    print "#!/bin/sh\n"  > script;

    print "# Define WORKDIR, DATADIR, MCKINSTALL etc." >> script;
    printf(". %s/bin/config.sh\n", autotest_home) >> script;

    printf("recorddir=$WORKDIR/output/ltp-%s\n", testcase) >> script;

    printf("command_line='%s'\n\n", command_line) >> script;
    printf(". %s/bin/run.sh", ltp_install) >> script;

    system("chmod +x " script);
}
