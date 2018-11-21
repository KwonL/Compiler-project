/***************************************************************
 * File Name    : hash.c
 * Description
 *      This is an implementation file for the open hash table.
 *
 ****************************************************************/

#include "subc.h"
#include <string.h>
#include <stdlib.h>

#define  HASH_TABLE_SIZE   101

typedef struct nlist {
	struct nlist *next;
	id *data;
} nlist;

// This is root pointer of hashtable 
static nlist* hashTable = NULL;

id *enter(int tokenType, char *name, int length) {
	// Allocate for node and new data
	nlist* node = (nlist *)malloc(sizeof(node));
	id* new_id = (id *)malloc(sizeof(id));
	new_id->name = (char *)malloc(sizeof(length + 1));

	// Initialize vars
	new_id->lextype = tokenType;
	strcpy(new_id->name, name);

	// Initialize node
	node->data = new_id;
	node->next = NULL;

	nlist* cur_node = hashTable;

	// Initially insert into hashTable
	if (cur_node == NULL) hashTable = node;
	// Move cursor until  meet end of list
	else {
		while (cur_node->next != NULL) {
			cur_node = cur_node->next;
		}
		// insert new node to linked list
		cur_node->next = node;
	}

	return new_id;
}

unsigned hash(char* name) {
	return 1;
}

// Lookup for name in hash table
id *lookup(char *name) {
	nlist* cur_node = hashTable;

	// search for name 
	while (cur_node != NULL) {
		if (!strcmp(cur_node->data->name, name)) {
			return cur_node->data;
		}

		cur_node = cur_node->next;
	}

	return NULL;
}