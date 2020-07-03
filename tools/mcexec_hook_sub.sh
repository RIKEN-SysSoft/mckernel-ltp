#! /bin/sh

sync; sync; sync;

if [ $# -eq 1 ]; then
    eval ${LTPMCEXEC} $*;
else
    eval $*;
fi
