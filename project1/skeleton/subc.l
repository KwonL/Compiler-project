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
white_space [\ \t\n]

%start NORMAL COMMENT

%% 


{id} {
	char* id = yytext;
	unsigned int count = hash(id);

	// Just use it
	if (isKeyword(id) == KEYWORD) 
		printf("KEY\t%s\t%d\n", id, count);
	else {
		printf("ID\t%s\t%d\n", id, count);
	}
}

.*	{ printf("invalid input"); }


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
