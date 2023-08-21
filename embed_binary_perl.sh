#!/bin/bash

unset POSIXLY_CORRECT
run_payload() {
   read -r pid mfd < <(perl -e '
		require qw/syscall.ph/;

		# Create memfd
		my $name = "";
		my $fd = syscall(SYS_memfd_create(), $fn, 0);
		if (-1 == $fd) { die "memfd_create: $!"; }

		$pid = fork();
		if ( $pid == 0 ) {
			sleep();
		}

		print "$pid $fd\n";
		select()->flush();
	')
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
