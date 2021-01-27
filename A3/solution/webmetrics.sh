#!/bin/bash

# 1st command line argument: weblogs

# 1.7
if [[ -z $1 ]] 
then
    echo Error: No log file given.
    echo Usage: ./webmetrics.sh \<logfile\>
    exit 1
fi

# 1.8
if [[ ! -r $1 ]] 
then
    echo Error: File '$1' does not exist.
    echo Usage: ./webmetrics.sh \<logfile\>
    exit 2
fi

# 1.2
firefox=$(grep -ic firefox $1)
chrome=$(grep -ic chrome $1)
safari=$(grep -ic safari $1)
echo Number of requests per web browser
echo Safari,$safari
echo Firefox,$firefox
echo Chrome,$chrome

echo 

#1.3
dates=$(awk '{print substr($4,2,11)}' < $1 | sort --unique) # isolate unique dates

echo Number of distinct users per day 
for date in $dates #for each date, print the number of unique IDs
do
    day=$(grep $date $1 | awk '{print $1}' | sort --unique | wc -w)
    echo $date,$day
done	

#1.4
echo 
echo Top 20 popular product requests
grep -E --color=always 'GET /product/[0-9]+/' $1 | awk 'BEGIN { FS="/" } {print $5}' | sort | uniq -c | sort -k1,1rn -k2,2nr | awk '{print $2 "," $1}' | head -n 20

exit 0 
