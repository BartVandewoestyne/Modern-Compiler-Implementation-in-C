/*
 * TODO:
 *   1. Comments may be nested.
 *   2. Detect unclosed comments (at end of file).
 *   3. Detect unclosed strings.
 *   4. The string value that you return for a string literal should have all
 *      the escape sequences translated into their meanings.
 */

%{
#include <string.h>
#include "util.h"
#include "tokens.h"
#include "errormsg.h"

/* Variable to keep track of the position of each token, measured in characters
   since the beginning of the file. */
int charPos = 1;

int commentNestingDepth = 0;

/*
 * Check if the comment nesting depth is smaller than 1.
 * This function is called when we encounter a closing comment.  If the
 * nesting depth is smaller than one, this means we cannot close any
 * comment anymore.
 */
void check_commentNestingDepth()
{
  if (commentNestingDepth < 1)
  {
    EM_error(EM_tokPos, "Wrong nesting in comments!");
  }
}

int yywrap(void)
{
  charPos = 1;
  return 1;
}

/*
   The EM_tokPos variable of the error message module errormsg.h is continually
   told this position by calls to the function adjust().  The parser will be
   able to use this information in printing informative syntax error messages.
 */
void adjust(void)
{
  EM_tokPos = charPos;
  charPos += yyleng;
}

%}

%x COMMENT
%%
" "                    {adjust(); continue;}
\n                     {adjust(); EM_newline(); continue;}
\r                     {adjust(); continue;}
\t                     {adjust(); continue;}
","                    {adjust(); return COMMA;}
":"                    {adjust(); return COLON;}
";"                    {adjust(); return SEMICOLON;}
"("                    {adjust(); return LPAREN;}
")"                    {adjust(); return RPAREN;}
"["                    {adjust(); return LBRACK;}
"]"                    {adjust(); return RBRACK;}
"{"                    {adjust(); return LBRACE;}
"}"                    {adjust(); return RBRACE;}
"."                    {adjust(); return DOT;}
"+"                    {adjust(); return PLUS;}
"-"                    {adjust(); return MINUS;}
"*"                    {adjust(); return TIMES;}
"/"                    {adjust(); return DIVIDE;}
"="                    {adjust(); return EQ;}
"<>"                   {adjust(); return NEQ;}
"<"                    {adjust(); return LT;}
"<="                   {adjust(); return LE;}
">"                    {adjust(); return GT;}
">="                   {adjust(); return GE;}
"&"                    {adjust(); return AND;}
"|"                    {adjust(); return OR;}
":="                   {adjust(); return ASSIGN;}
array                  {adjust(); return ARRAY;}
if                     {adjust(); return IF;}
then                   {adjust(); return THEN;}
else                   {adjust(); return ELSE;}
while                  {adjust(); return WHILE;}
for                    {adjust(); return FOR;}
to                     {adjust(); return TO;}
do                     {adjust(); return DO;}
let                    {adjust(); return LET;}
in                     {adjust(); return IN;}
end                    {adjust(); return END;}
of                     {adjust(); return OF;}
break                  {adjust(); return BREAK;}
nil                    {adjust(); return NIL;}
function               {adjust(); return FUNCTION;}
var                    {adjust(); return VAR;}
type                   {adjust(); return TYPE;}
\"[^\"]*\"             {adjust(); yylval.sval = strdup(yytext); return STRING;}
[a-zA-Z]+[_0-9a-zA-Z]* {adjust(); yylval.sval = strdup(yytext); return ID;}
[0-9]+                 {adjust(); yylval.ival = atoi(yytext); return INT;}
"/*"                   {
                         adjust();
                         //printf("Found opening comment.");
                         commentNestingDepth++;
                         //printf("  Commentlevel = %d\n", commentNestingDepth);
                         BEGIN(COMMENT);
                       }
"*/"                   {
                         adjust();
                         //printf("Found closing comment.");
                         EM_error(EM_tokPos, "Wrong nesting in comments!");
                       }
<COMMENT>"/*"          {
                         adjust();
                         //printf("Found opening comment.");
                         commentNestingDepth++;
                         //printf("  Commentlevel = %d\n", commentNestingDepth);
                       }
<COMMENT>"*/"          {
                         adjust();
                         //printf("Found closing comment.");
                         check_commentNestingDepth();
                         commentNestingDepth--;
                         //printf("  Commentlevel = %d\n", commentNestingDepth);
                         if (commentNestingDepth == 0)
                         {
                           BEGIN(INITIAL);
                         }
                       }
<COMMENT>.             {adjust();}
.                      {adjust(); EM_error(EM_tokPos, "illegal token");}
