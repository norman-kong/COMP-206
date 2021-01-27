#!/bin/bash

# Takes an individual file or directory and backs it up into a tar file. The name of the tar file will contain the directory/file (without the extension) and the date the backup was created (YYYMMDD).

# Requires two inputs (in this order): 
# 1. The directory where the tar file should be saved.
# 2. An individual file or directory to backup.

# 1.3
if [[ -z $1 || -z $2 ]] # if <2 params given
then
    echo Error: Expected two input parameters.
    exit 1
fi

# 1.4
if [[ ! -e $1 ]] # if output directory DNE
then
    echo The directory $1 does not exis and/or is not readable.
    exit 2
elif [[ ! -e $2 ]]
then
    echo Error: $2 does not exist and/or is not readable.
    exit 2
elif [[ $1 = $2 ]] # if output directory == thing to be archived
then 
    echo Error: Both input parameters are the same.
    exit 2
fi

# 1.5
backup=$(basename $2).$(date +%Y%m%d).tar #name of tar file to be created 

if [[ -r $1/$backup ]] # if thing to be backed up exists already 
then
    echo $backup	
    echo "Backup file '$backup' already exists. Overwrite? (y/n)"
    read answer
    if [[ $answer = y ]]
    then
        tar -cvf $1/$backup $2 
       	exit 0
    else
        exit 3
    fi	
else
    tar -cvf $1/$backup $2 # what does the v option do? also, tar works with files and directories right?
    exit 0
fi 