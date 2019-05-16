#!/bin/bash

#
## This is a simple script to print out the HW/SW CQ entries by 
## dissecting the fields. CQ should be dumped in Hex format 
## Ex: crash: x/<size of whole queue in bytes>xb 0x<start/base address> 
#

if [[ $# != 2 ]]; then
  echo "Usage: #analyse_cq.sh <HW/SW CQ dumped in hex, 8 bytes per line> <output filename>"
	echo "Ex dump: 0xffff880820fc0058:	0x30	0xc8	0x4a	0x2c	0x08	0x88	0xff	0xff"
	echo "Output is dumped to 'output_filename'"
  exit
fi

filename="$1"
output="$2"

echo "" > $output

read -r line < $filename
base_addr=`echo $line | awk '{print $1}'`
base_addr=${base_addr::-1}

echo -e "-------------------------------------------------------------------------------------------------" >> $output
echo "Note: Struct members are in Big Endian, So while reading " >> $output
echo -e "\tmultibyte data, read it from left to right" >> $output
echo "Example:" >> $output
echo -e "\t A multi byte data 0x01234567 is stored at address 0x100 as" >> $output
echo -e "\t Little Endian:" >> $output
echo -e "\t \t 0x100 0x101 0x102 0x103" >> $output
echo -e "\t \t  0x67  0x45  0x23  0x01" >> $output
echo -e "\t Big Endian:" >> $output
echo -e "\t \t 0x100 0x101 0x102 0x103" >> $output
echo -e "\t \t  0x01  0x23  0x45  0x67" >> $output
echo -e ""  >> $output
echo -e "\t ToDo : Add parsing logic, say opcode, cqe processing etc" >> $output
echo -e "\t ToDo : Parse the other flits to extract TAG, MSN etc" >> $output
echo -e "\t Note/Todo : SW repo code CQE has RSS header as flit0 but upstream code CQE has no RSS header," >> $output
echo -e "\t        This script is for now only to be used with upstream code CQE" >> $output
echo -e "-------------------------------------------------------------------------------------------------" >> $output
echo -e ""  >> $output

while IFS='' read -r line || [[ -n "$line" ]]; do
#read -r line < $filename
	line_addr=`echo $line | awk '{print $1}'`
	line_addr=${line_addr::-1}

	index=$(((($line_addr - $base_addr) / 8) % 4))
	#printf "0x%x   0x%x\n" $base_addr $line_addr
	index=$(($index % 11))
	#echo "index $index" >> $output
	
	case $index in
		0)
			echo "CQE $line_addr" >> $output

			pr1="`echo $line | awk '{print $5}'`"
			echo "Opcode: $(($pr1 & 0xF))" >> $output						# bits 0-3 of first be32 of flit0

			echo "Type: $((($pr1 & 0x10) >> 4))" >> $output							# bit 4 of first be32 of flit0

			pr2="`echo $line | awk '{print $4}'`"
			pr2=$((($pr2 << 0x8) + pr1))
			echo "Status: $((($pr2 & 0x3e0) >> 0x5))" >> $output	#bits 5-9 of first be32 of flit0

			echo "Generation bit: $((($pr2 & 0x400) >> 0xa))" >> $output	#bit 10 of first be32 of flit0
			
			pr3="`echo $line | awk '{print $3}'`"
			pr4="`echo $line | awk '{print $2}'`"
			pr4=$((($pr4 << 0x18) + ($pr3 << 0x10) + pr2))
			echo "QPID: $((($pr4 & 0xFFFFF000) >> 0xc))" >> $output	#bit 12-31 of first be32 of flit0

			echo "len: `echo $line | awk '{print ($6,$7,$8,$9)}'`" >> $output	#second be32 of flit0
			;;
		1)
			echo "flit 1: `echo $line | awk '{$1=""; print $0}'`" >> $output
			;;
		2)
			echo "flit 2: `echo $line | awk '{$1=""; print $0}'`" >> $output
			;;
		3)
			echo "flit 3: `echo $line | awk '{$1=""; print $0}'`" >> $output
			echo >> $output 
			;;
	esac
done < "$filename"



