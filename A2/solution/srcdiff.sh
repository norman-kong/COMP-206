#!/bin/bash

#set -x

# Compares the text files between two diectories (ex: the source files in a directory to files with the same name in a backup directory).

# input: two directories
# iterate over the lists of files
# then report files which are either present in one directory but missing in the other, or present both difectories but differ in content

# 2.3
if [[ -z $1 || -z $2 ]] # if <2 params given
then
    echo Error: Expected two input parameters.
    echo Usage: $0 \<originaldirectory\> \<comparisondirectory\>
    exit 1
fi

# 2.4 
if [[ !(-d $1) ]]	# make sure 1st param is a dir	
then
    echo Error: Input parameter \#1 "$1" is not a directory.
    echo Usage: $0 \<originaldirectory\> \<comparisondirectory\>
    exit 2
elif [[ !(-d $2) ]] # make sure 2nd param is a dir
then	
    echo Error Input parameter \#2 "$2" is not a directory.
    echo Usage: $0 \<originaldirectory\> \<comparisondirectory\>
    exit 2
elif [[ $1 = $2 ]] 
then 
    echo Both input parameters are the same. 
    echo Usage: $0 \<originaldirectory\> \<comparisondirectory\>
    exit 2
fi 

$(touch temp.txt)

# for each file in 1, compare it to the files in 2
for i in $(ls $1)
do
    if [[ -d $1/$i ]] # skip directories
    then 
        continue
    fi
    
    missingStatement=true

    for k in $(ls $2)
    do
        if [[ -d $2/$k ]] # skip directories
	then
	    continue
	fi 
	    
	if [[ $i = $k ]] # if filenames are the same, check if contents are equivalent
        then

	    missingStatement=false
            
	    $(diff $1/$i $2/$k > temp.txt)

	    if [[ -z $(cat temp.txt) ]] #diff printed nothing, so they are equivalent	 
	    then 
		continue # print nothing	
	    else # same name, not equivalent 
	        echo $1/$i differs. 
		continue # go to next element
	    fi
        fi
    done 
   
    if [[ $missingStatement = true ]]
    then
	echo $1/$i is missing
    fi
done

# for each file in 2, compare it to the files in 1
for i in $(ls $2)
do
    if [[ -d $2/$i ]] # skip directories
    then
        continue
    fi

    missingStatement=true

    for k in $(ls $1)
    do
        if [[ -d $1/$k ]] # skip directories
        then
            continue
        fi

        if [[ $i = $k ]] # if filenames are the same, check if contents are equivalent
        then

            missingStatement=false

            $(diff $2/$i $1/$k > temp.txt)

            if [[ -z $(cat temp.txt) ]] #diff printed nothing, so they are equivalent
            then
                continue # print nothing
            else # same name, not equivalent
                echo $2/$i differs.
                continue # go to next element
            fi
        fi
    done

    if [[ $missingStatement = true ]]
    then
        echo $2/$i is missing
    fi
done

# cleanup temp file
$(rm temp.txt)

if [[ -z $(diff $1 $2) ]] # if 0, then they are same
then
    exit 0
else
    exit 3
fi