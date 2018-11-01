/******************************************************
 * File Name   : subc.h
 * Description
 *    This is a header file for the subc program.
 ******************************************************/

#ifndef __SUBC_H__
#define __SUBC_H__

#define KEYWORD 1
#define IDENTIFIER 0

#include <stdio.h>
#include <strings.h>

typedef struct id {
	int lextype;
	char *name;
} id;

/* For hash table */
unsigned hash(char *name);
id *enter(int tokenType, char *name, int length);
id *lookup(char *name);

int read_line();

#endif