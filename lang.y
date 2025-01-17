%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
    int ival;
    float fval;
    char cval;
    char* sval;
    int bval;
}

%token <ival> INTEGER
%token <fval> FLOAT
%token <cval> CHAR
%token <sval> IDENTIFIER STRING
%token <bval> BOOL

%token INT STRING BOOL CHAR FLOAT VOID
%token IF ELSE WHILE FOR RETURN PRINT INPUT CLASS

%token PLUS MINUS TIMES DIVIDE MODULO ASSIGN
%token LT LE GT GE EQ NE

%token LBRACE RBRACE LPAREN RPAREN COLON COMMA DOT ARROW SEMICOLON LBRACKET RBRACKET

%type <sval> program decllist declaration type stmtlist stmt cmpdstmt expression condition

%%

program: decllist cmpdstmt;

decllist: declaration
         | declaration decllist;

declaration: type IDENTIFIER SEMICOLON;

type: INT | STRING | BOOL | CHAR | FLOAT | VOID;

cmpdstmt: LBRACE stmtlist RBRACE;

stmtlist: stmt
        | stmt stmtlist;

stmt: assignstmt
    | iostmt
    | returnstmt
    | structstmt;

assignstmt: IDENTIFIER ASSIGN expression SEMICOLON;

expression: expression PLUS term
          | expression MINUS term
          | term;

term: term TIMES factor
    | term DIVIDE factor
    | term MODULO factor
    | factor;

factor: LPAREN expression RPAREN
      | IDENTIFIER
      | INTEGER
      | FLOAT
      | STRING
      | CHAR
      | BOOL;

iostmt: PRINT LPAREN expression RPAREN SEMICOLON
      | INPUT LPAREN IDENTIFIER RPAREN SEMICOLON;

structstmt: cmpdstmt
          | ifstmt
          | whilestmt
          | forstmt;

ifstmt: IF LPAREN condition RPAREN cmpdstmt
      | IF LPAREN condition RPAREN cmpdstmt ELSE cmpdstmt;

whilestmt: WHILE LPAREN condition RPAREN cmpdstmt;

forstmt: FOR LPAREN expression SEMICOLON condition SEMICOLON expression RPAREN cmpdstmt;

condition: expression LT expression
         | expression LE expression
         | expression GT expression
         | expression GE expression
         | expression EQ expression
         | expression NE expression;

returnstmt: RETURN expression SEMICOLON;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}
