/*
Program to implement a scientific calculator.  
*******************************************************************************
* Author       Dept.    Date            Notes
*******************************************************************************
* Norman K     ECSE     Dec 10 2020     Initial version.
*/

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

    const int MAXRESULT = 1001;
    int result_index = MAXRESULT;
    char result[MAXRESULT];
     
    if (argc != 4) {
	printf("Error: invalid number of arguments!\n");
        printf("Usage: ./scalc <operand1> <operator> <operand2>");
    	return 1;
    }

    // get string lengths and do basic checks
    int len1 = 0, len2 = 0, len3 = 0; 

    // input 1 
    for (; argv[1][len1] != '\0'; len1++) {
	// check if it is a number: ((argv[1][len1] != '0') || (argv[1][len1] != '1')) etc
        if ((argv[1][len1] == '.') || (argv[1][len1] == '-')) { // check it is a + int
            printf("Error: operand can only be positive integer");
    	    return 1;
	}
    }

    // input 2
    for (; argv[2][len2] != '\0'; len2++) {
        if (argv[2][len2] != '+') {
	    printf("Error: operator can only be + !");
	    return 1;
	}
    }
    if (len2 != 1) {
	printf("Error: operator can only be +!");
	return 1;
    }

    // input 3
    for (; argv[3][len3] != '\0'; len3++) {
        // check if it is a number: ((argv[3][len3] != '0') || (argv[3][len3] != '1')) etc
        if ((argv[3][len3] == '.') || (argv[3][len3] == '-')) { // check it is a + int
            printf("Error: operand can only be positive integer");
            return 1;
        }
    }
 
    int digit1, digit2, sum, carry=0;
    result[--result_index] = '\0'; // put a null at the end of the result string array.

    while ((len1 > 0) && (len3 > 0)) {
	digit1 = argv[1][--len1] - '0';
	digit2 = argv[3][--len3] - '0';
	sum = digit1 + digit2 + carry;
	result[--result_index] = sum%10 + '0';
        putchar(result[result_index]);
	if (sum == 0) {carry=1;} else {carry=0;}
    }

    if (carry != 0) result[--result_index] = carry + '0'; // account for last carry

    // TODO: add functionality to account for if one number is longer than the other

printf("\nresult is: "); 
for(int i=0;result[i] != '\0'; i++) {putchar(result[i]);}
//printf("result is: %s\n", result);


    return 0;

}

