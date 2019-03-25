%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

#define SIZE 100

int linenum = 1;
char characterArray[SIZE] = {0};
%}
%%	
	/* RESERVED WORDS */
	
echo	return ECHO;
if		return IF;
elif	return ELIF;
else	return ELSE;
then	return THEN;
fi		return FI;

while	return WHILE;
do		return DO;
done	return DONE;


	/* EXPRESSIONS */


\$	return DOLLARSIGN;

\-	return MINUSOP;
\+	return PLUSOP;
\/	return DIVIDEOP;
\*	return MULTOP;
\=	return ASSIGNOP;

\.	return CONCATOP;

\(	return OPENPARAN;
\)	return CLOSEPARAN;
\[	return OPENBRACKET;
\]	return CLOSEBRACKET;
\{	return OPENCURLY;
\}	return CLOSECURLY;

"-gt"	return GREATERTHAN;
"-lt"	return LESSTHAN;
"-le"	return lessORequal;
"-ge"	return greaterORequal;
"-eq"	return EQUALCHECK;


;		return SEMICOLON;

\"\\n\"	return NEWLINE;
[ ] 	return WHITESPACE;
[\t]	return TAB;	

	
	
	
	/* STRING LITERALS */
	
\"([^\"]|\.)*\"	{ yylval.string = strdup(yytext); return STRLITERAL1; }	/* The string literal starts with a double quote and then followed by followed by zero or more of either an escaped anything OR not a double quote character. Finishes with a closing quote mark too. Return part returns the string that is between double quotes. */

\'(.)*\'	{yylval.string = strdup(yytext);return STRLITERAL2;}	/* String literals with inside single quotes */

	/* COMMENTS */

[#][^!].*		{yylval.string = strdup(yytext);return COMMENT;} /* Any string that starts with a number sign but NOT followed by a exclamation mark is a comment line because of that we identified the Shell Script Predirective with an exclamation mark right after the number sign so that if we don't add the [^!] part to the rule, an error occurs in the terminal that the rule for Shell Script Predirective did't match. */

"#!/bin/sh"		return SHELLPRED;	/* A line that starts with a comment number sign and collaborated with an exclamation mark defines a shell script predirective. */ 

	/* INTEGERS */
	
[0-9]+	{yylval.string = strdup(yytext);return INTEGER;}

	/* IDENTIFIERS */
	
[A-Za-z]([A-Za-z]|[0-9])*		{	
									strcpy(characterArray,"$");					
									strcat(characterArray,yytext);
									yylval.string = strdup(characterArray);
						
									memset(&characterArray[0], 0, sizeof(characterArray));
								
									return VARIABLE1;					/* Variables that not starts with a dollar sign. */
								}

[\$][A-Za-z]([A-Za-z]|[0-9])*	{ yylval.string = strdup(yytext);return VARIABLE2; }	/* This variable decleration is basically for variable calls. In shell script files, if you want to call a variable you need to call it with a dollar sign. */



\n		linenum++;



	
%%
