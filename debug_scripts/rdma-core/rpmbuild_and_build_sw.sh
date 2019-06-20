#!bin/bash

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
	echo "Build good"
else
	echo "Build bad"
fi
