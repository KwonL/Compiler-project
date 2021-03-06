/******************************************************
 * File Name   : subc.h
 * Description
 *    This is a header file for the subc program.
 ******************************************************/

#ifndef __SUBC_H__
#define __SUBC_H__

#include <stdio.h>
#include <strings.h>
#include <string.h>

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
    int defined;        /* FUNC: check of function definition: not declared, declared, defined       */
    int typeclass;	/* TYPE: type class: int, char, array, ptr, struct, void		*/
    struct decl *elementvar;	/* TYPE (array): ptr to element VAR decl	*/
    int num_index;	/* TYPE (array): number of elements		*/
    struct ste *fieldlist;	/* TYPE (struct): ptr to field list		*/
    struct decl *ptrto;		/* TYPE (pointer): type of the pointer		*/
    int offset;		/* ALL: local offset                            */
    int isglobal;	/* ALL: isglobal                                */
    int size;		/* ALL: size in bytes				*/
    struct decl *origin;        /* ALL: origin for clone decl                   */
    struct ste **scope;	/* VAR: scope when VAR declared			*/
    struct decl *next;		/* For list_of_variables declarations		*/
    int fetched;     /* Don't need to fetch */
};                /* Or parameter check of function call		*/

/* For scope stack */
struct stack_node {
    struct ste* ste;
    struct stack_node* next;
    struct stack_node* prev;
    int counter;
    int init_counter;
};
struct stack_node* top; 
struct stack_node* bottom;

/* for WHILE label */
struct labelstruct {
    int loop_label;
    int end_label;  
};

void push_scope(int counter);
void insert(struct id* arg_id, struct decl* arg_decl);
struct ste* pop_scope();
void free_ste_list(struct ste* list);
struct decl* lookup_stack(struct id* arg_id);
struct decl* lookup_whole(struct id* arg_id);
struct decl* lookup_func();
struct decl* lookup_struct(struct id* name);
struct id* lookup_id(struct decl* arg_decl);

/* For hash table */
unsigned hash(char *name);
struct id *enter(int lextype, char *name, int length);
struct id *lookup(char *name);

int read_line();

/* For semantic analysis */
struct decl* maketypedecl(int type);
struct decl* makevardecl(struct decl* typedecl);
struct decl* makepointerdecl(int isPtr, struct decl* typedecl);
struct decl* makearraydecl(struct decl* const_decl, struct decl* var_decl);
struct decl* makeconstdecl(struct decl* type_decl) ;
struct decl* makeintconstdecl(int int_const);
struct decl* makecharconstdecl(char* char_const);
struct decl* clonedecl(struct decl*);
void check_struct_isdefined(struct id* arg_id);
struct decl* makestructdecl(struct ste* arg_list);
struct decl* findcurrentdecl(struct id* arg_id);
void check_is_struct_type(struct decl* arg_decl);
struct decl* makeprocdecl();
struct decl* addpointer(struct decl* arg_decl);
void check_incable(struct decl* arg_decl);
struct decl* reference_ptr(struct decl * arg_decl);
struct decl* reference_array(struct decl* ptr_decl, struct decl* const_decl);
int check_compatibility(struct decl* arg1, struct decl* arg2, int enable);
struct decl* reference_struct(struct decl* struct_name, struct id* member);
void add_formals(struct decl* procdecl, struct ste* formals);
void check_return_type_compatibility(struct decl* type1, struct decl* type2);
void declare(struct id* arg_id, struct decl* arg_decl);
void declare_struct(struct id* arg_id, struct decl* arg_decl);

/* type decl */
struct decl* inttype;
struct decl* chartype;
struct decl* voidtype;
struct id* returnid;
// for return type checking
struct decl* cur_func;

/* file name , readline */
int read_line();
char* get_filename();
void print_error(const char*);
FILE* output_file;
FILE* output_origin;
FILE* null_dev;

/* counter */
int string_counter;
int label_counter;
int loop_label; 
int end_label;
int for_label;
int stmt_label;

/* Code generation */
void printf_code(const char* s);
void fetch_val(struct decl* arg_decl);

#endif

