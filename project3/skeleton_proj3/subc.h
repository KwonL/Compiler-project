/******************************************************
 * File Name   : subc.h
 * Description
 *    This is a header file for the subc program.
 ******************************************************/

#ifndef __SUBC_H__
#define __SUBC_H__

#include <stdio.h>
#include <strings.h>

/* structure for ID */
typedef struct id {
      char *name;
      int lextype;
} id;

/* For semantic analysis */
struct ste {
    struct id	*name;
    struct decl	*decl;
    struct ste	*prev;
};

/* structure for decl */
struct decl {
    int declclass;	/* DECL Class: VAR, CONST, FUNC, TYPE		*/
    struct decl *type;		/* VAR, CONST: pointer to its type decl		*/
    int value;		/* CONST: value of integer const		*/
    char *char_value;	/* CONST: value of char const			*/
    struct ste *formals;	/* FUNC: ptr to formals list			*/
    struct decl *returntype;	/* FUNC: ptr to return TYPE decl		*/
    int defined;        /* FUNC: check of function definition           */
    int typeclass;	/* TYPE: type class: int, char, array, ptr, struct, void		*/
    struct decl *elementvar;	/* TYPE (array): ptr to element VAR decl	*/
    int num_index;	/* TYPE (array): number of elements		*/
    struct ste *fieldlist;	/* TYPE (struct): ptr to field list		*/
    struct decl *ptrto;		/* TYPE (pointer): type of the pointer		*/
    int ptrcoef;	/* ALL: for check temp decls                    */
    int offset;		/* ALL: local offset                            */
    int isglobal;	/* ALL: isglobal                                */
    int size;		/* ALL: size in bytes				*/
    struct decl *origin;        /* ALL: origin for clone decl                   */
    struct ste **scope;	/* VAR: scope when VAR declared			*/
    struct decl *next;		/* For list_of_variables declarations		*/
};                /* Or parameter check of function call		*/

/* For scope stack */
struct stack_node {
    struct ste* ste;
    struct stack_node* next;
    struct stack_node* prev;

};
struct stack_node* top; 
struct stack_node* bottom;

void push_scope();
void insert(struct id* arg_id, struct decl* arg_decl);
struct ste* pop_scope();
void free_ste_list(struct ste* list);
struct decl* lookup_stack(struct id* arg_id);

/* For hash table */
unsigned hash(char *name);
struct id *enter(int lextype, char *name, int length);
struct id *lookup(char *name);

int read_line();

/* For semantic analysis */
struct decl* maketypedecl(int type);
void declare(struct id* arg_id, struct decl* arg_decl);

/* type decl */
struct decl* inttype;
struct decl* chartype;
struct decl* voidtype;
struct id* returnid;


#endif

