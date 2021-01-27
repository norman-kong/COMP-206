#!/bin/bash

echo testing for compilation
echo --------------------------------
gcc -o report report.c
echo --------------------------------

echo
echo testing for incorrect number of arguments
echo --------------------------------
./report data.csv
echo $?
echo --------------------------------

echo
echo testing for unreadable file
echo --------------------------------
./report nosuchdata.csv "Jane Doe" rpt.txt
echo $?
echo --------------------------------

echo
echo testing for user not present
echo --------------------------------
./report data.csv "Jane Doe" rpt.txt
echo $?
echo --------------------------------

echo
echo --------------------------------
echo testing for output file can be created
chmod 000 rpt.txt
./report data.csv "Markus Bender" rpt.txt
echo $?
chmod 777 rpt.txt
echo --------------------------------

echo
echo testing for no collaborators
echo --------------------------------
./report data.csv "Markus Bender" rpt.txt
echo $?
cat rpt.txt
echo --------------------------------

echo
echo testing for finding collaborators
echo --------------------------------
./report data.csv "Adaline Murphy" rpt.txt
echo $?
cat rpt.txt
echo --------------------------------
