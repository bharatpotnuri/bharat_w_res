#!/bin/bash

cd ../linux*
dir="../compat-rdma/patches/"

git reset --hard

rm -rf drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.h
rm -rf drivers/net/ethernet/chelsio/cxgb4/t4_firmware.h
rm -rf drivers/net/ethernet/chelsio/cxgb4/t4fw.txt
rm -rf drivers/net/ethernet/chelsio/cxgb4/t5fw.txt
rm -rf drivers/net/ethernet/chelsio/cxgb4/t6fw.txt

#patch_to_stop_at=""
patch_to_stop_at="0023-BACKPORT-RHEL7.4-cxgb3.patch"

for i in $(ls -v $dir/*.patch); do
	if [[ "$i" == *"$patch_to_stop_at"* ]]; then
		exit 0
	fi
  echo -e "Applying backport patch: $i"
  patch -p1 -N -t < $i
  RET=$?
  if [[ $RET -ne 0 ]]; then
    echo -e "Patching $i failed, update it"
    exit $RET
  fi
done

