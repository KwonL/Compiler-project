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

static nlist* hashTable = NULL;

id *enter(int tokenType, char *name, int length) {
	// Allocate for node and new data
	nlist* node = (nlist *)malloc(sizeof(node));
	id* new_id = (id *)malloc(sizeof(id));
	new_id->name = (char *)malloc(sizeof(length + 1));

	// Initialize vars
	new_id->tokenType = tokenType;
	strcpy(new_id->name, name);
	new_id->count = 0;

	// Initialize node
	node->data = new_id;
	node->next = NULL;

	nlist* cur_node = hashTable;

	if (cur_node == NULL) hashTable = node;
	// Move cursor until  meet end of list
	else {
		while (cur_node->next != NULL) {
			cur_node = cur_node->next;
		}
		cur_node->next = node;
	}

	return new_id;
}

unsigned hash(char* name) {
	// search for hash table
	nlist* cur_node = hashTable;

	while (cur_node != NULL) {
		if (!strcmp(cur_node->data->name, name)) {
			// ++ count
			cur_node->data->count++;

			return cur_node->data->count;
		}

		cur_node = cur_node->next;
	}
	
	// There is no matching name, so enter it
	enter(IDENTIFIER, name, strlen(name))->count++;
	return 1;
}

int isKeyword(char* name) {
	nlist* cur_node = hashTable;

	// search for name 
	while (cur_node != NULL) {
		if (!strcmp(cur_node->data->name, name)) {
			// if matching name is Keyword, return 1
			if (cur_node->data->tokenType == KEYWORD)
				return KEYWORD;
			// else return 0
			else 
				return IDENTIFIER;
		}

		cur_node = cur_node->next;
	}

	// if no matching, return -1
	return -1;
}