rmmod iw_cxgb4 cxgb4
sleep 2
echo "Load driver with fw_attach=0"
modprobe cxgb4 fw_attach=0
sleep 5
echo "Loading Firmware"
#cxgbtool eth1 loadfw /lib/firmware/cxgb4/t5fw-1.8.4.0.bin
#cxgbtool eth1 loadfw /root/t5fw-1.15.28.8.bin
cxgbtool ens1f4 loadfw /lib/firmware/cxgb4/t6fw-1.25.5.0.bin
cxgbtool ens1f4 loadcfg clear
cxgbtool ens1f4 loadcfg /lib/firmware/cxgb4/t6-config.txt

sleep 5
echo "Reseting Card"
#cxgbtool ens1f4 reg 0x19428=0x3



