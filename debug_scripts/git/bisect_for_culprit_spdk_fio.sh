#!/bin/bash
set -e

if [[ $# != 2 ]]; then
	echo -e "help:"
	echo -e "\tProvide good and bad commits"
	echo -e "\tSyntax: sh bisect_for_culprit_spdk_fio.sh <old commit> <tot commit>"
	exit 0
fi

cd /home/fio

rm -rf ./bisect_log.txt
bisect_end=0

git bisect start
git bisect good $1
git bisect bad $2 >> ./bisect_log.txt
echo " " >> ./bisect_log.txt

while [[ $bisect_end == 0 ]]
do
#	hit=`grep -nir "match_device" providers/bnxt_re/main.c | wc -l`
	echo "1"
	make && make install
	cd /home/spdk_nvme-cli/spdk
	make clean; ./configure --with-rdma; make -j16; make install
	sleep 1
	echo "2"
	/home/spdk_nvme-cli/spdk/scripts/setup.sh

	echo "3"
	sleep 1
	LD_PRELOAD=/home/spdk_nvme-cli/spdk/examples/nvme/fio_plugin/fio_plugin fio --rw=randwrite --name=random --norandommap=1 --ioengine=spdk --thread=1 --size=400m --group_reporting --exitall --fsync_on_close=1 --invalidate=1 --direct=1 --filename='trtype=RDMA adrfam=IPv4 traddr=10.0.2.2 trsvcid=4420 subnqn=nqn.2016-06.io.spdk\:cnode1 ns=1:trtype=RDMA adrfam=IPv4 traddr=10.0.2.2 trsvcid=4420 subnqn=nqn.2016-06.io.spdk\:cnode2 ns=1:trtype=RDMA adrfam=IPv4 traddr=10.0.2.2 trsvcid=4420 subnqn=nqn.2016-06.io.spdk\:cnode3 ns=1:trtype=RDMA adrfam=IPv4 traddr=10.0.2.2 trsvcid=4420 subnqn=nqn.2016-06.io.spdk\:cnode4 ns=1' --time_based --runtime=5 --iodepth=64 --numjobs=8 --bs=32K --kb_base=1000 --output=/tmp/tmp &
	sleep 10
	echo "4"
	#killall -9 fio
	hit=`grep "end_fsync failed for file trtype" /tmp/tmp | wc -l`
	echo "5 $hit"
	cd /home/fio
	echo "6"
	if [[ $hit != 0 ]]; then
		echo "7"
		git bisect bad >> ./bisect_log.txt
	else
		echo "8"
		git bisect good >> ./bisect_log.txt
	fi

	bisect_end=`cat ./bisect_log.txt | grep -i "is the first bad commit" | wc -l`
	echo " " >> ./bisect_log.txt
done

git bisect reset

