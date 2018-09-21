/***************************************************************
 * File Name    : hash.c
 * Description
 *      This is an implementation file for the open hash table.
 *
 ****************************************************************/

#include "subc.h"

#define  HASH_TABLE_SIZE   101

typedef struct nlist {
	struct nlist *next;
	id *data;
} nlist;

static nlist *hashTable[HASH_TABLE_SIZE];

id *enter(int tokenType, char *name, int length) {
   /* implementation is given here */
}