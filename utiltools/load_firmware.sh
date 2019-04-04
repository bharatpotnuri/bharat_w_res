rmmod cxgb4
sleep 2
echo "Load driver with fw_attach=0"
modprobe cxgb4 fw_attach=0
sleep 5
echo "Loading Firmware"
#cxgbtool eth1 loadfw /lib/firmware/cxgb4/t5fw-1.8.4.0.bin
#cxgbtool eth1 loadfw /root/t5fw-1.15.28.8.bin
cxgbtool eth1 loadfw /root/t5fw-1.15.28.160.bin
cxgbtool eth42 loadcfg clear
cxgbtool eth42 loadcfg /lib/firmware/cxgb4/t5-config.txt

sleep 5
echo "Reseting Card"
cxgbtool eth1 reg 0x19428=0x3



