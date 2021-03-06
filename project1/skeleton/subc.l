%{
/**************************************************************
* File Name   : subc.l
*
* Description
*	This is a skeleton input file to lex.
*
* Which tool to use
*	The GNU lex-clone, flex/flex++ is recommended to use.
*	It supports a C++ mode.
*	For any information about flex, refer to flex.man.
*
*	Good Luck!
*
***************************************************************/

/**************************************************************/
/* This section will appear at the head of lex.yy.c/lex.yy.cc */
/**************************************************************/

#include "subc.h"
/***************************************************************
{Other useful code segments can be here.}
***************************************************************/
int commentdepth=0;
%}

letter		[A-Za-z_]
digit	[0-9]
id	{letter}({letter}|{digit})*
WS	[ \t\n\ ]
integer_constant	([1-9]+{digit}*)|0
float_constant	{digit}+\.{digit}*([eE][+-]?{digit}+)?
operator	("("|")"|"["|"]"|"{"|"}"|"->"|"."|","|".."|"!"|"~"|"++"|"--"|"*"|"/"|"%"|"+"|"-"|"<<"|">>"|"<"|"<="|">"|">="|"=="|"!="|"&"|"^"|"|"|"&&"|"||"|"?"|":"|";"|"="|"+="|"-="|"*="|"/="|"%="|"&="|"^="|"|="|"<<="|">>=")
comment_start	("/*")
comment_end ("*/")

%start NORMAL COMMENT

%% 


	/* this  is for id and keyword */
<NORMAL>{id} {
	char* id = yytext;
	unsigned int count = hash(id);

	// if id in hashTable is keyword
	if (isKeyword(id) == KEYWORD) 
		printf("KEY\t%s\t%d\n", id, count);
	// else, it is identifier
	else {
		printf("ID\t%s\t%d\n", id, count);
	}
}
	/* integer constant */
<NORMAL>{integer_constant} {
	printf("INT\t%s\n", yytext);
}
	/* dot dot operator */
<NORMAL>{integer_constant}/".." {
	printf("INT\t%s\n", yytext);
}
	/* float constant */
<NORMAL>{float_constant} {
	printf("F\t%s\n", yytext);
}
	/* operators */
<NORMAL>{operator} {
	printf("OP\t%s\n", yytext);
}

	/********* comment *********/
{comment_start} {
	if (commentdepth == 0) {
		BEGIN COMMENT;
	}

	commentdepth++;
}
{comment_end} {
	commentdepth--;
	if (commentdepth == 0) {
		BEGIN NORMAL;
	}
}
<COMMENT>. {;}
	/*************** end of comment ***************/

	/* Do nothing with white space */
{WS}+ {}
. { printf("invalid input\n"); }


%%
void initHash() 
{
	int i;

	char* keyWord[]={
		"auto", "break", "case", "char", "continue", "default", "do", 
		"double", "else",  "extern", "float", "for", "goto", "if", "int", 
		"long", "register", "return", "short" "sizeof", "static", "struct", 
		"switch", "typedef", "union", "unsigned", "void", "while", "\0"
	};

	/* Initilize Hash Tabel with Keywords */
	for (i = 0; strcmp(keyWord[i], "\0") !=0; i++) {
		enter(KEYWORD, keyWord[i],strlen(keyWord[i]));
	}
}

int main(int argc, char** argv)
{
	id* temp;

	++argv;
	--argc;

	if (argc > 0) {
		yyin = fopen(argv[0], "r");
	} else {
		yyin = stdin;
	}

	initHash();

	BEGIN NORMAL;
	yylex ();

	return 0;
}
