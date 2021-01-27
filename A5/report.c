/*
Program to analyze a user event file to look for possible collaboration among 
students from a dataset. This is done by identifying students from the same IP 
address. 
*******************************************************************************
* Author       Dept.    Date            Notes
*******************************************************************************
* Norman K     ECSE     Nov 15 2020     Initial version.
* Norman K     ECSE     Nov 16 2020     Added readLog, checkNameExists. 
* Norman K     ECSE     Nov 17 2020     Finished assignment. 
*/
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

struct logrecord {
    char name[100];
    char IPAddress[50];
};

/* Parse a character array that contains a line from the log and return a 
 * struct that contains the fields of interest to us.
 */
struct logrecord readLog(char* logline) {
    char *token;   
    token = strtok(logline, ",");
    struct logrecord student;
   
    /* walk through other tokens */
    for (int i=0; i<7; i++) {
	if (i == 0) strcpy(student.name, token);	   
      	if (i == 6) strcpy(student.IPAddress, token);
        token = strtok(NULL, ","); // go to next token
    }   

    return student;
}

/* Reads through the CSV data file looking for the name. If the name is found, 
 * store the corresponding address to the variable ip and return success.
 */
bool checkNameExists(FILE* csvfile, char* name, char* ip) {

    char line[200]; // max size is 200 
    struct logrecord student;

    fgets(line,200,csvfile);
    
    while (!feof(csvfile)) {

	fgets(line,200,csvfile); // fgets will read max 199, since fgets inserts a \0 at the end
        //printf("line is: %s\n", line);
  	if (feof(csvfile)) break;
	student = readLog(line);
        //printLog(student); 

	if (strcmp(student.name, name) == 0) { // match found
	    strcpy(ip, student.IPAddress); // get IP 
	    return true;
        }
    }

    return false;
}

/* Go through CSV file, look for collaboratos of sname by looking for entries with the same ip
 * as sip. If any collaborators are found, write it to the output report file. 
 */
bool findCollaborators(char* sname, char *sip, FILE* csvfile, FILE* rptfile){
   
    bool flag = false;
    char line[200]; // max size is 200
    struct logrecord entry;

    fgets(line,200,csvfile);

    while(!feof(csvfile)) {
	fgets(line,200,csvfile);  // fgets will read max 199, since fgets inserts a \0 at the end
	if (feof(csvfile)) break;	
	entry = readLog(line);
        
	//readLog(entry);

	if (strcmp(entry.name, sname) == 0) continue;
        if (strcmp(entry.IPAddress, sip) == 0) {
	    fprintf(rptfile, "%s\n", entry.name);
	    strcpy(sname, entry.name);
	    flag = true; // collaborator found   
	}
    }
    return flag;
}

/* Simple function to print the contents of a logrecord struct */
void printLog(struct logrecord log) {
    printf("Log is name: %s, IP: %s\n", log.name, log.IPAddress);
}

int main(int argc, char *argv[]) {
    
    /* checks to validate input */

    if (argc != 4) { // check right number of CL arguments 
        fprintf(stderr, "Usage ./report <csvfile> \"<student name>\" <reportfile>\n");
        exit(1); 
    }
  
    // validating data file 
    FILE *dataFile1 = fopen(argv[1], "rt");
    if (dataFile1 == NULL) { // error if data file cannot be read
        fprintf(stderr, "Error, unable to open the csv file %s\n", argv[1]);
	exit(1);
    }

    // check that user is present
    char ip[51];
    if (checkNameExists(dataFile1, argv[2], &ip[0])) {
    } else {
        fprintf(stderr, "Error, unable to locate %s\n", argv[2]);
	    exit(1);
    }
    
    // validating output file
    FILE *outputFile = fopen(argv[3], "wt");
    if (outputFile == NULL) { // error if data file cannot be read
        fprintf(stderr, "Error, unable to open the output file %s\n", argv[3]);
        exit(1);
    }

    FILE *dataFile2 = fopen(argv[1], "rt");
    if (dataFile2 == NULL) { // error if data file cannot be read
        fprintf(stderr, "Error, unable to open the csv file %s\n", argv[1]);
        exit(1);
    }

    // checking for collaborators 
    if (findCollaborators(argv[2], ip, dataFile2, outputFile)) {
    } else { // no collaborators found
        fprintf(outputFile, "No collaborators found for %s\n", argv[2]);
    }

    // clean up
    fclose(dataFile1);
    fclose(dataFile2);
    fclose(outputFile);
    exit(0);
}   


