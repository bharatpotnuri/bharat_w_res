#!/bin/bash
set -e

if [[ $# != 2 ]]; then
	echo -e "help:"
	echo -e "\tProvide good and bad commits"
	echo -e "\tSyntax: sh find_commit_that_removed_a_change.sh <old commit> <tot commit>"
	exit 0
fi

rm -rf ./bisect_log.txt
bisect_end=0

git bisect start
git bisect good $1
git bisect bad $2 >> ./bisect_log.txt
echo " " >> ./bisect_log.txt

while [[ $bisect_end == 0 ]]
do
	# Build rdma-core rpms
	vers=`cat redhat/rdma-core.spec | grep Version | awk '{print $2}'`
	echo "version $vers"
	dir=`pwd`
	echo "dir $dir"
	new_dir="/root/rpmbuild/SOURCES/rdma-core-$vers"
	echo "new dir $new_dir"
	cd $dir/../
	if [[ $dir != $new_dir  ]]; then
		echo "same dir name"
		mv -f $dir /root/rpmbuild/SOURCES/rdma-core-$vers
	fi
	tar -cf rdma-core-${vers}.tgz rdma-core-$vers
	echo "tar done"
	cd /root/rpmbuild/SOURCES/rdma-core-$vers
	echo "build rpm started"
	rpmbuild -bb ./redhat/rdma-core.spec
	sleep .1
	yum autoremove -y libibverbs libibumad librdmacm rdma-core-devel iwpmd rdma-core rdma-core-debuginfo rdma
	rpm -ivh ../../RPMS/x86_64/*$vers-1*
	
	sleep .1

	# build sw libcxgb4
	cd /root/sw
	echo "library build began"
	sh buildall.sh > /tmp/tmp
	echo "library build over"
	res=`cat /tmp/tmp | grep "FAILED" | wc -l`
	if [[ $res == 0 ]]; then
		cd /root/rpmbuild/SOURCES/rdma-core-$vers
		echo "Bisect good"
		git bisect good >> ./bisect_log.txt
	else
		cd /root/rpmbuild/SOURCES/rdma-core-$vers
		echo "Bisect bad"
		git bisect bad >> ./bisect_log.txt
	fi
	
	echo "check end of bisect"
	bisect_end=`cat ./bisect_log.txt | grep -i "is the first bad commit" | wc -l`
	echo " " >> ./bisect_log.txt
done

git bisect log >> ./bisect_log.txt
git bisect reset

