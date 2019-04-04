#!/bin/bash

#
## This is a simple script to print out the SW SQ entries by 
## dissecting the fields. SW SQ should be dumped in Hex format 
## Ex: crash: x/<size of whole queue in bytes>xb 0x<start address> 
#

if [[ $# != 2 ]]; then
  echo "Usage: #analyse_sw_sq.sh <sw SQ dumped in hex, 8 bytes per line> <outputfile>"
	echo "Ex dump: 0xffff880820fc0058:	0x30	0xc8	0x4a	0x2c	0x08	0x88	0xff	0xff"
	echo "Output is dumped to 'outputfile'"
  exit
fi

filename="$1"
outputfile="$2"

echo "" > $outputfile

read -r line < $filename
base_addr=`echo $line | awk '{print $1}'`
base_addr=${base_addr::-1}

echo -e "-------------------------------------------------------------------------------------------------" >> $outputfile
echo "Note: Struct members are in Little Endian, So while reading " >> $outputfile
echo -e "\tmultibyte data, read it from right to left" >> $outputfile
echo "Example:" >> $outputfile
echo -e "\t A multi byte data 0x01234567 is stored at address 0x100 as" >> $outputfile
echo -e "\t Little Endian:" >> $outputfile
echo -e "\t \t 0x100 0x101 0x102 0x103" >> $outputfile
echo -e "\t \t  0x67  0x45  0x23  0x01" >> $outputfile
echo -e "\t Big Endian:" >> $outputfile
echo -e "\t \t 0x100 0x101 0x102 0x103" >> $outputfile
echo -e "\t \t  0x01  0x23  0x45  0x67" >> $outputfile
echo -e ""  >> $outputfile
echo -e "\t ToDo : Print them in reverse so that the above need not be done" >> $outputfile
echo -e "\t ToDo : Add parsing logic, say opcode, cqe processing etc" >> $outputfile
echo -e "-------------------------------------------------------------------------------------------------" >> $outputfile
echo -e ""  >> $outputfile

while IFS='' read -r line || [[ -n "$line" ]]; do
#read -r line < $filename
	line_addr=`echo $line | awk '{print $1}'`
	line_addr=${line_addr::-1}

	index=$(((($line_addr - $base_addr) / 8) % 11))
	#printf "0x%x   0x%x\n" $base_addr $line_addr
	index=$(($index % 11))
	#echo "index $index" >> $outputfile
	
	case $index in
		0)
			echo "SWSQE $line_addr" >> $outputfile
			echo "$line" >> $outputfile
			echo "WR ID: `echo $line | awk '{$1=""; print $0}'`" >> $outputfile
			;;
		1)
			echo "CQE" >> $outputfile
			echo $line | awk '{print $0}' >> $outputfile
			;;
		2)
			echo $line | awk '{print $0}' >> $outputfile
			;;
		3)
			echo $line | awk '{print $0}' >> $outputfile
			;;
		4)
			echo $line | awk '{print $0}' >> $outputfile
			;;
		5)
			echo "Read len: `echo $line | awk '{print ($2,$3,$4,$5)}'`" >> $outputfile
			echo "Opcode: `echo $line | awk '{print ($6,$7,$8,$9)}'`" >> $outputfile
			;;
		6)
			echo "Completed: `echo $line | awk '{print ($2,$3,$4,$5)}'`" >> $outputfile
			echo "Signaled: `echo $line | awk '{print ($6,$7,$8,$9)}'`" >> $outputfile
			;;
		7)
			echo "IDX: `echo $line | awk '{print ($2,$3,$4,$5)}'`" >> $outputfile
			echo "Flushed: `echo $line | awk '{print ($6,$7,$8,$9)}'`" >> $outputfile
			;;
		8)
			echo "Host timestamp" >> $outputfile
			echo "kernel time: `echo $line | awk '{$1=""; print $0}'`" >> $outputfile
			;;
		9)
			echo "time ns: `echo $line | awk '{$1=""; print $0}'`" >> $outputfile
			;;
		10)
			echo "SGE timestamp: `echo $line | awk '{$1=""; print $0}'`" >> $outputfile
			echo >> $outputfile 
			;;
	esac
done < "$filename"



