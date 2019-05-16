#!/bin/bash
set -e

if [[ $# != 5 ]]; then
	echo -e "help:"
	echo -e "\tProvide oldCS newCS gitrepo matchname searchfile "
	echo -e "\tMake sure the repo is clean, git status should show clean"
	echo -e "\tSyntax: sh find_commit_that_removed_a_change.sh <old commit> \
					<tot commit> <git dir path> <word to match> <file to search>"
	exit 0
fi

echo "Directory : $3"
git_dir="$3"
match_word="$4"
look_file="$5"

cd $git_dir
rm -rf ./bisect_log.txt
bisect_end=0

git bisect start
git bisect good $1
git bisect bad $2 >> ./bisect_log.txt
echo " " >> ./bisect_log.txt

while [[ $bisect_end == 0 ]]
do
	hit=`grep -nir $match_word $look_file | wc -l`
	if [[ $hit != 0 ]]; then
		git bisect good >> ./bisect_log.txt
	else
		git bisect bad >> ./bisect_log.txt
	fi
	
	bisect_end=`cat ./bisect_log.txt | grep -i "is the first bad commit" | wc -l`
	echo " " >> ./bisect_log.txt
done

git bisect reset

