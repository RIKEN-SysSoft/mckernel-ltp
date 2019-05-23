#! /bin/sh

sync; sync; sync;

if [ $# -eq 1 ]; then
    file $1 | egrep -i "(script|text)" 2>&1 >/dev/null;
    if [ $? -ne 0 ]; then
	eval ${LTPMCEXEC} $*;
	exit $?;
    fi;
fi;
eval $*;

