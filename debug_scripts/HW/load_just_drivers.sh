#!/bin/bash

# Start netconsole
modprobe netconsole netconsole=4444@10.193.184.65/eno1,6666@10.193.185.169/0c:c4:7a:94:9d:9e

#Set variables:
mtu=1500
#mtu=4096

# SIW
rdma link del siw-ens1f4


########### unload ###########
#iser
targetcli clearconfig confirm=True
modprobe -r mlx5_ib
modprobe -r cxgb3i
modprobe -r cxgb4i
modprobe -r libcxgbi
modprobe -r iscsi_tcp
modprobe -r libiscsi_tcp
modprobe -r ib_iser
modprobe -r iscsi_target_mod
modprobe -r rdma_rxe
modprobe -r mlx5_ib
modprobe -r mlx5_core

modprobe -r csiostor
modprobe -r iw_cxgb4
modprobe -r svcrdma
modprobe -r xprtrdma
modprobe -r rdma_ucm
modprobe -r cxgb4

echo "modules unloaded"

######### load ############
#modprobe -v ib_core force_mr=Y
#cat /sys/module/ib_core/parameters/force_mr
modprobe -v cxgb4
#modprobe -v iw_cxgb4 
#modprobe -v iw_cxgb4 mpa_rev=2 use_dsgl=1 wd_disable_inaddr_any=1 crc_enabled=1
#modprobe -v 8021q
#echo 1 > /sys/module/iw_cxgb4/parameters/use_dsgl
#echo 1 > /sys/module/iw_cxgb4/parameters/c4iw_debug
#echo -n 'module iw_cxgb4 +pfl' > /sys/kernel/debug/dynamic_debug/control

modprobe -v rdma_ucm
modprobe -v nvme_rdma

#Mellanox:
#modprobe -v mlx5_ib

sleep 3

######### Interface up ############
#Mellanox
#ifconfig ens15f0 10.0.4.1/24 mtu 4096 up

#T6
ifconfig ens1f4 10.0.2.1/24 mtu $mtu up
#ifconfig ens1f4 inet6 add 1002::1/64 up
ifconfig ens1f4d1 10.0.3.1/24 mtu $mtu up
#ifconfig ens1f4d1 inet6 add 1003::1/64 up

## Add vlan
#vconfig add ens1f4 10
#ip link add link ens1f4 name ens1f4.10 type vlan id 10
#ifconfig ens1f4.10 10.10.10.1/24 up

# Add a ramdisk
#modprobe -v brd rd_nr=4 rd_size=100000

# Add a nulldisk
#modprobe null_blk nr_devices=8 gb=250 use_per_node_hctx=Y

# kmemleak
echo off > /sys/kernel/debug/kmemleak

# iwpmd
systemctl stop iwpmd.service
#systemctl start iwpmd.service
systemctl status iwpmd.service

## HW tracer
#cxgbtool ens1f4 reg 0x9800=0x13
#cxgbtool ens1f4 reg 0x9800
#reg5.py --doc -i ens1f4 0x9800
#echo tx0 snaplen=1000 > /sys/kernel/debug/cxgb4/0000\:04\:00.4/trace0
#echo rx0 snaplen=1000 > /sys/kernel/debug/cxgb4/0000\:04\:00.4/trace1

# For Performance / latency tuning
# Note: For nvmf perf, Use nvmf perf config
#sh HT.sh off
#service irqbalance stop
#tuned-adm profile network-throughput
#perftune_nic.sh -i -c "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"
#tuned-adm profile network-latency
#tuned-adm	active


# Set interrupt affinity of all CIQs to one core, run app on other core
# This is only for kernel mode apps, user apps work in polling mode.
# Here setting to 5th core, cpumask = 1<<5 = 0x10
#grep -i ciq /proc/interrupts | awk '{print $1}' | tr -d ':' | while read irq ; do echo 10 > /proc/irq/${irq}/smp_affinity; done
#grep -i mlx5 /proc/interrupts | awk '{print $1}' | tr -d ':' | while read irq ; do echo 20 > /proc/irq/${irq}/smp_affinity; done

# spdk
#sh /root/huge_page.sh

#SIW
rmmod iw_cxgb4
rmmod mlx5_ib
modprobe -v siw
rdma link add siw-ens1f4 type siw netdev ens1f4


# cleanup
modprobe -r ib_srpt
modprobe -r csiostor
modprobe -r ib_srp

# Info
#echo Y | sudo tee /sys/module/printk/parameters/time
#echo 8 > /proc/sys/kernel/printk
echo "device info:: "
echo "$(ibv_devices)"
echo "<<modules loaded>>"

: '
sleep 5

# set rxmit_min timer
cxgbtool ens2f4d1 reg 0x7d98=609
#cxgbtool ens2f4d1 reg 0x7d98=24360
#cxgbtool ens2f4d1 reg 0x7d98

#cxgbtool ens2f4d1 reg 0x7d44=1349052485

sleep 2
# set dupackthresh
cxgbtool ens2f4d1 reg 0x7d60=0xe213407


cxgbtool ens2f4d1 fec off
cxgbtool ens2f4 fec off
sleep 30
ethtool -s ens2f4d1 speed 40000 duplex full autoneg off
ethtool -s ens2f4 speed 40000 duplex full autoneg off


sleep 30
`cxgbtool ens2f4 sched-class params type packet level cl-rl mode class rate-unit bits rate-mode absolute channel 0 class 0 max-rate 30000000 pkt-size 8960`

`cxgbtool ens2f4d1 sched-class params type packet level cl-rl mode class rate-unit bits rate-mode absolute channel 1 class 0 max-rate 30000000 pkt-size 8960`

sleep 2
ethtool -A ens2f4d1 rx off
ethtool -A ens2f4 rx off

sleep 1
ethtool -a ens2f4d1
ethtool -a ens2f4
'

