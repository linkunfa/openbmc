#!/bin/sh
set -e
log_file="/tmp/program_vbios.log"
/sbin/modprobe spi-gpio
sleep 1

if [ -f $1 -a -f $2 ]; then
	dd if=$1 of=$2 bs=1K count=$3  > $log_file 2>&1
	echo "Program vbios success" >> $log_file
	/sbin/modprobe -r spi-gpio
	exit 0
fi
echo "Failure!! vbios=$1 target=$2 size=$3K" > $log_file
