#!/bin/sh -x

$LTPMCEXEC pthserv &
sleep 5
$LTPMCEXEC pthcli 127.0.0.1 $LTPROOT/testcases/bin/data
clientCode=$?
killall pthserv
serverCode=$?
if [ $clientCode -ne 0 ] || [ $serverCode -ne 0 ]; then
    exit 1
fi
exit 0
