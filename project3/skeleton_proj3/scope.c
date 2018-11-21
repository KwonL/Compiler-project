#include <stdio.h>
#include <strings.h>
#include <unistd.h>
#include <stdlib.h>
#include "subc.h"

void push_scope() {
    struct stack_node* cur_node = (struct stack_node *)malloc(sizeof(struct stack_node));

    cur_node->next = NULL;
    cur_node->prev = top;
    if (top != NULL) {
        cur_node->ste = top->ste;
    } else {
        cur_node->ste = NULL;
    }

    if (top == NULL) {
        top = cur_node;
    }

    return;
}

void insert(struct id* arg_id, struct decl* arg_decl) {
    struct ste* node = (struct ste *)malloc(sizeof(struct ste));

    // initialize new node
    node->prev = top->ste;
    top->ste = node;
    node->decl = arg_decl;
    node->name = arg_id;

    return;
}

struct ste* pop_scope() {
    if (top == NULL) return NULL;
    struct ste* cur_node = top->ste;
    struct ste* ste_top = top->ste;

    // There is only one node, Just return all ste
    if (top->prev == NULL) {
        free(top);
        return cur_node;
    }

    while (cur_node != top->prev->ste) {
        cur_node = cur_node->prev;
    }
    
    // There was no insertion on this scope
    if (ste_top == top->prev->ste) return NULL;
    
    cur_node->prev = NULL;
    struct stack_node* prev = top->prev;
    prev->next = NULL;
    free(top);
    top = prev;

    return ste_top;
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
    if (top == NULL || top->ste == NULL) return NULL;

    struct ste* cur_node = top->ste;
    // Top Down searching
    while (cur_node != NULL) {
        if (cur_node->name == arg_id) {
            return cur_node->decl;
        }
        cur_node = cur_node->prev;
    }
    
    return NULL;
}
