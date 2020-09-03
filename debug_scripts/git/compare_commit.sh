#!/bin/bash
#echo "num args $#"
if [[ $# != 2 ]]; then
	echo "Check if a commit is present in a repo"
	echo "use "git log --oneline" output as input file"
	echo "Usage: #compare_commit.sh <what_file_to_compare> <with_what>"
	exit
fi

echo "" > ./compare_output.txt
while IFS='' read -r line || [[ -n "$line" ]]; do
		echo $line > /tmp/commit
		echo $line | awk '{$1=""; $2=""; print $0}' > /tmp/line
		sed -i 's/^ *//' /tmp/line
		line=`cat /tmp/line | awk '{print $0}'`
		line=${line::-2}
#		echo $line
		grep --silent -F "$line" $2 
		if [[ $? == 0 ]]; then
			search="Yes"
		else
			search="No"
		fi
#    echo -e "Commit:: $line \t\t\t\t-> $search"
     echo -e "`cat /tmp/commit` \t\t-> $search" >> ./compare_output.txt
done < "$1"



