#!/bin/bash

unset POSIXLY_CORRECT
run_payload() {
    ARG1=$1

    read -r pid mfd < <(python3 -c '
import os
import sys
import signal

fd = os.memfd_create("bin", 0)
if fd < 0:
    sys.exit(-1)

pid = os.fork()
if pid == 0:
    signal.pause()

print("%d %d" % (pid, fd))
sys.stdout.flush()
    ')
    if ! [[ ${pid} =~ ^[0-9]+$ ]] || ! [[ ${mfd} =~ ^[0-9]+$ ]]; then
        PAYLOAD_RC=1
        return
    fi

    memfd=/proc/$pid/fd/$mfd

    sed "1,/^\#\#\/\*\*__PAYLOAD_BEGINS__\*\*\/\#\#$/ d" $0 | base64 -d | gzip -d -c > ${memfd}

	${memfd} 87
	PAYLOAD_RC=$?

	kill ${pid}
}

run_payload
echo "run elf string in memfd and get return code:" $PAYLOAD_RC

exit
##/**__PAYLOAD_BEGINS__**/##
