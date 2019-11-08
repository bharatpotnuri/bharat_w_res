#!/bin/bash
set -e

if [[ $# != 4 ]]; then
	echo -e "help:"
	echo -e "\tProvide oldCS newCS gitrepo matchname searchfile "
	echo -e "\tMake sure the repo is clean, git status should show clean"
	echo -e "\tSyntax: sh find_commit_that_removed_a_change.sh <old commit> \
<tot commit> <git dir path> <full path to the file to search>"
	exit 0
fi

echo "Directory : $3"
echo "pwd : `pwd`"
git_dir="$3"
look_file="$4"

cd $git_dir
rm -rf ./bisect_log.txt
bisect_end=0

git bisect start
git bisect good $1
git bisect bad $2 >> ./bisect_log.txt
echo " " >> ./bisect_log.txt

while [[ $bisect_end == 0 ]]
do
#	hit=`grep -nir $match_word $look_file | wc -l`
	if test -f "$look_file"; then
    echo "$look_file exist" >> ./bisect_log.txt
		hit=1
	else
		hit=0
    echo "$look_file Not exist" >> ./bisect_log.txt
	fi
	if [[ $hit != 0 ]]; then
		git bisect good >> ./bisect_log.txt
	else
		git bisect bad >> ./bisect_log.txt
	fi
	
	bisect_end=`cat ./bisect_log.txt | grep -i "is the first bad commit" | wc -l`
	echo " " >> ./bisect_log.txt
done

git bisect reset

