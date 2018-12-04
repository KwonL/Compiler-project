#include <stdio.h>
#include <strings.h>
#include <unistd.h>
#include <stdlib.h>
#include "subc.h"

void push_scope(int counter) {
    // printf("%d: push scope\n", read_line());
    struct stack_node* cur_node = (struct stack_node *)malloc(sizeof(struct stack_node));

    cur_node->next = NULL;
    cur_node->prev = top;
    if (top != NULL) {
        cur_node->ste = top->ste;
    } else {
        cur_node->ste = NULL;
    }

    top = cur_node;
    top->counter = counter;

    return;
}

void insert(struct id* arg_id, struct decl* arg_decl) {
    if (arg_id == NULL || arg_decl == NULL) 
        return;
    struct ste* node = (struct ste *)malloc(sizeof(struct ste));

    // initialize new node
    node->prev = top->ste;
    top->ste = node;
    node->decl = arg_decl;
    node->name = arg_id;

    return;
}

struct ste* pop_scope() {
    // printf("%d: pop scope\n", read_line());
    if (top == NULL) return NULL;
    struct ste* cur_node = top->ste;
    struct ste* ste_top = top->ste;

    // There was no insertion on this scope
    if (ste_top == top->prev->ste) {
        // Free scope stack top
        struct stack_node* prev_node = top->prev;
        prev_node->next = NULL;
        free(top);
        top = prev_node;

        return NULL;
    }
    // detach nodes from stack
    // printf("%d: top->prev is : %p\n", read_line(), top->prev);
    while (cur_node->prev != top->prev->ste) {
        // printf("%d: cur_node is : %s\n", read_line(), cur_node->name->name);
        cur_node = cur_node->prev;
    }
    cur_node->prev = NULL;
    // printf("checking\n");
    

    // Reverse list
    // cur_node point to end of this scope's ste
    struct ste* prev   = NULL; 
    struct ste* current = top->ste; 
    struct ste* next = NULL; 
    struct ste* ret = NULL;
    while (current != NULL) { 
        // Store next 
        next  = current->prev;   
  
        // Reverse current node's pointer 
        current->prev = prev;    
  
        // Move pointers one position ahead. 
        prev = current; 
        current = next; 
    } 
    ret = prev;

    // Free scope stack top
    struct stack_node* prev_stack = top->prev;
    prev_stack->next = NULL;
    free(top);
    top = prev_stack;

    /* for debug */
    current = ret; 
    while (current != NULL) {
        // printf("%d: Now node is %s\n", read_line(), current->name->name);
        current = current->prev;
    }

    return ret;
}

void free_ste_list(struct ste* list) {
    struct ste* cur_node = list;

    while (cur_node != NULL) {
        struct ste* prev = cur_node->prev;
        free(cur_node);
        cur_node = prev;
    }

    return;
}

struct decl* lookup_stack(struct id* arg_id) {
    // empty stack
    // printf("lineno : %d\n", read_line());
    if (top == NULL || top->ste == NULL) return NULL;
    if (arg_id == NULL) return NULL;
	/*
	 * This is for debugging
	 */
	// struct ste* test_node = top->ste; 
	// while (test_node != NULL) {
	// 	printf("cur node's name is : %s\n", test_node->name->name);
	// 	test_node = test_node->prev;
	// }

    struct ste* cur_node = top->ste;
    // Top Down searching
    while (cur_node != NULL && (top->prev != NULL ? (cur_node != top->prev->ste) : 1)) {
        if (cur_node->name == arg_id) {
            return cur_node->decl;
        }
        cur_node = cur_node->prev;
    }
    
    return NULL;
}

struct decl* lookup_whole(struct id* arg_id) {
    if (arg_id == NULL) return NULL;
    struct ste* cur_node = top->ste;

    while (cur_node != NULL) {
        if(cur_node->name == arg_id) {
            return cur_node->decl;
        }
        cur_node = cur_node->prev;
    }

    return NULL;
}

struct decl* lookup_func() {
    // // empty stack
    // struct ste* cur_node = top->ste;
    // struct ste* ret = NULL;

    // while (cur_node != NULL) {
    //     if (cur_node->decl->declclass == 2) {
    //         return cur_node->decl;
    //     }
    //     cur_node = cur_node->prev;
    // }
    
    // return NULL;
    return cur_func;
}

struct decl* lookup_struct(struct id* name) {
    if (name == NULL)
        return NULL;
    struct ste* cur_node = top->ste;

    while (cur_node != NULL) {
        if (cur_node->decl == inttype) 
            break;
        cur_node = cur_node->prev;
    }

    // search only below int type
    while (cur_node != NULL) {
        if (cur_node->name == name) 
            return cur_node->decl;
        cur_node = cur_node->prev;
    }

    return NULL;
}

struct id* lookup_id(struct decl* arg_decl) {
    struct ste* cur_node = top->ste;

    while (cur_node != NULL) {
        if (cur_node->decl == arg_decl)
            return cur_node->name;

        cur_node = cur_node->prev;
    }

    return NULL;
}