%{
#include <stdio.h>
#include <ctype.h>
#include <unistd.h>

int line_number = 1;

void print_token(const char* token_type, const char* token_value) {
    printf("L%d: [%s,%s]\n", line_number, token_type, token_value);
}

void lexical_error(const char* lexeme) {
    printf("L%d: lexical error %s\n", line_number, lexeme);
}

void new_line() {
    line_number++;
}
%}

RESERVED_WORD   ("go to"|"exit"|"return"|"main"|"if"|"else"|"while"|"return"|"endcase"|"endwhile"|"endfor"|"end"|"case"|"repeat"|"until"|"loop")
DATA_TYPE       ("INTEGER"|"REAL"|"BOOLEAN"|"STRING")
ARITHMETIC_OP   ("+"|"-"|"/"|"*")
LOG_OP          (AND|OR)
RELATIONAL_OP   (=|<>|<=|<|>=|>)
DIV             ("DIV")
MOD             ("MOD")
LETTER          [a-zA-Z]
DIGIT           [0-9]
IDENTIFIER      {LETTER}({LETTER}|{DIGIT})*
FLOAT           [-+]?[0-9]*(\.[0-9]+)
INTEGER         [-+]?[1-9][0-9]*|0
WHITESPACE      [ \t]+
NEWLINE         (\r\n|\r|\n)
SPECIAL_CHAR    [,;:]
COMMENT         "//".*
STRING          \"([^"\\]|\\.)*\"

%%

{NEWLINE}          { new_line(); } // Increment line number and ignore newline
{WHITESPACE}       /* Ignore whitespace */
{COMMENT}          /* Ignore comments */

{DATA_TYPE}       { print_token("DATA_TYPE", yytext); }
":="                { print_token("ASSIGNMENT", yytext); }
"("                { print_token("LPAREN", yytext); }
")"                { print_token("RPAREN", yytext); }
"{"                { print_token("LBRACE", yytext); }
"}"                { print_token("RBRACE", yytext); }
{SPECIAL_CHAR}     { print_token("SPECIAL_CHAR", yytext); }
{RESERVED_WORD}    { print_token("RESERVED_WORD", yytext); }
{ARITHMETIC_OP}    { print_token("ARITHMETIC_OP", yytext); }
{LOG_OP}           { print_token("LOG_OP", yytext); }
{RELATIONAL_OP}    { print_token("RELATIONAL_OP", yytext); }
{DIV}              { print_token("DIV", yytext); }
{MOD}              { print_token("MOD", yytext); }
{IDENTIFIER}       { print_token("IDENTIFIER", yytext); }
{FLOAT}            { print_token("FLOAT", yytext); }
{INTEGER}          { print_token("INTEGER", yytext); }
{STRING}           { print_token("STRING", yytext); }

.                  { lexical_error(yytext); }

%%

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (file) {
            yyin = file;
            yylex();
            fclose(file);
        } else {
            perror(argv[1]);
            return 1;
        }
    } else {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }
    return 0;
}
