#!/bin/bash
j=5
for ((i=1; i<=4; i++, j++)); do
{
	cat mbw_cli_$i.txt |grep Bhar | awk {'print $6'} > f_cli_$i.txt
		awk -F',' '{print $0}' f_cli_$i.txt | sort | uniq > f$j.txt
		echo -------------
		echo mbw_cli_$i.txt                   
		echo -------------
		cat f$j.txt
		total_cli=`cat "f_cli_""$i".txt | wc -l`
		unique_cli=`cat f"$j".txt | wc -l`
		echo "Total unique cq->cqid         = $unique_cli    values"
		echo "Total generated cq->cqid      = $total_cli   values"
}
done






