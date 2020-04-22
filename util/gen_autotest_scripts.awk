#!/usr/bin/awk -f

# Usage: cat /work/mcktest/ltp/install/runtest/{syscalls,ipc,mm,hugetlb} | ./gen_autotest_scripts.awk
# This puts scritps on /work/mctest/data/script/ and
# the test list on /work/mcktest/data/ltp-testlist.
#
# Usage of the generated scripts:
# McKernel run: AUTOTEST_HOME=/work/mcktest bash -x /work/mcktest/data/script/ltp-<test_name>
# Linux run:
#   AUTOTEST_HOME=/work/mcktest bash -x /work/mcktest/data/script/ltp-<test_name> -H

BEGIN { 
    "pwd -P" | getline cwd;
    "dirname " ARGV[0] | getline dir;
    "cd " dir "/../.. && pwd -P" | getline autotest_home;

    scriptdir = sprintf("%s/data/script", autotest_home); 
    system("rm " scriptdir "/ltp-*");
}

!/^#|^$/ {
    testcase = $1;
    command_line = $0;
    script_bn = sprintf("ltp-%s", testcase);
    script = sprintf("%s/%s", scriptdir, script_bn);

    #print script;

    print "#!/bin/sh\n"  > script;

    print "# Define linux_run" >> script;
    print ". ${AUTOTEST_HOME}/ltp/util/linux_run.sh\n" >> script;

    print "# Define WORKDIR, DATADIR, MCKINSTALL etc." >> script;
    print ". ${AUTOTEST_HOME}/bin/config.sh\n" >> script;

    # Switch recorddir for McKernel run and Linux run

    printf("if [ \"${linux_run}\" != \"yes\" ]; then\n") >> script;

    recorddir_base = "$WORKDIR/output";
    printf("\trecordfile=%s/ltp-%s.output\n", recorddir_base, testcase) >> script;
    printf("\trecorddir=%s/ltp-%s\n", recorddir_base, testcase) >> script;

    printf("else\n") >> script;

    recorddir_base = sprintf("%s/data/linux", autotest_home);
    printf("\trecordfile=%s/ltp-%s.output\n", recorddir_base, testcase, testno) >> script;
    printf("\trecorddir=%s/ltp-%s\n", recorddir_base, testcase, testno) >> script;
    
    printf("fi\n\n") >> script;

    printf("command_line='%s'\n\n", command_line) >> script;
    print(". ${AUTOTEST_HOME}/ltp/util/run.sh") >> script;

    system("chmod +x " script);

}
