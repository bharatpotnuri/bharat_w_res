#!/bin/bash

if [[ $# != 1 ]]; then
  echo "error: specify pcimem binary full path"
	echo "   Ex: sh change_fin_wait2_timeout.sh /home/pcimem/pcimem"
  exit 0
fi


pcimem=$1

lspci | grep Chelsio | grep ".4" |  awk -F : '{print $1}' > /bus_awk

for i in $(cat /bus_awk)
do
	echo "#### Chelsio: fin wait before changing ####"
  cat /sys/kernel/debug/cxgb4/0000\:$i\:00.4/clk | grep FIN
	$pcimem /sys/bus/pci/devices/0000\:$i\:00.4/resource0 0x07db8 w 156250 &> /dev/null
	sleep .5
	echo "#### Chelsio: fin wait after changing ####"
	cat /sys/kernel/debug/cxgb4/0000\:$i\:00.4/clk | grep FIN
done

