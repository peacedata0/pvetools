#!/bin/bash

if [ ! -f `dirname $0`/pvetools.conf ]; then
	if [ -f /usr/local/etc/pvetools/pvetools.conf ]; then
		cp -f /usr/local/etc/pvetools/pvetools.conf `dirname $0`/pvetools.conf
	else
		touch `dirname $0`/pvetools.conf
	fi
fi


NODES=`cat /etc/pve/.members | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/ip/){print $(i+1)}}}' | xargs echo`

SRC_DIR=`pwd`
echo $SRC_DIR
for i in $NODES; do
	ssh $i mkdir -p /tmp/pvetools_install
	rsync -av --progress --delete $SRC_DIR/ $i:/tmp/pvetools_install
	ssh $i /tmp/pvetools_install/uninstall.sh
	ssh $i rm -rf /tmp/pvetools_install
done

rm -f `dirname $0`/pvetools.conf

