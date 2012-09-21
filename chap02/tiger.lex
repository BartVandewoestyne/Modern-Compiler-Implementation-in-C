/*
 * TODO:
 *   1. The string value that you return for a string literal should have all
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

int commentNesting = 0;

/*
 * Check if the comment nesting depth is smaller than 1.
 * This function is called when we encounter a closing comment.  If the
 * nesting depth is smaller than one, this means we cannot close any
 * comment anymore.
 */
void check_commentNesting()
{
  if (commentNesting < 1)
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
 * The EM_tokPos variable of the error message module errormsg.h is continually
 * told this position by calls to the function adjust().  The parser will be
 * able to use this information in printing informative syntax error messages.
 */
void adjust(void)
{
  EM_tokPos = charPos;
  charPos += yyleng;
}

%}

%option nounput
%option noinput

%x COMMENT STRING_STATE

%%

  char string_buf[512];
  char *string_buf_ptr;


" "                    {adjust(); continue;}
<INITIAL,COMMENT>\n    {
                         adjust();
                         EM_newline();
                         continue;
                       }
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

\"                     {
                         adjust();
                         string_buf_ptr = string_buf;
                         BEGIN(STRING_STATE);
                       }

<STRING_STATE>{

    \" {
          /* Closing quote, all done. */
          adjust();
          BEGIN(INITIAL);
          *string_buf_ptr = '\0';
          yylval.sval = strdup(string_buf);
          return STRING;
       }

    \n {
         adjust();
         EM_error(EM_tokPos, "Unterminated string constant!");
       }

    \\[0-9]{3} {
                 /* ASCII code*/
                 // TODO: check this!!!
                 adjust();
                 int result;
                 (void) sscanf( yytext + 1, "%d", &result );
                 if ( result > 0xff ) {
                   /* error, constant is out-of-bounds */
                 }
                 *string_buf_ptr++ = result;
               }

    \\[0-9]+ {
               /* Escape sequences like ’\48’ or ’\0777777’ are errors! */
               adjust();
               EM_error(EM_tokPos, "Bad escape sequence!");
             }

    \\n {
          adjust();
          *string_buf_ptr++ = '\n';
        }

    \\t {
          adjust();
          *string_buf_ptr++ = '\t';
        }

    "\\^"[A-Z] {
                 adjust();
                 /* TODO: catch control characters! */
               }

    <<EOF>> {
              /* Catches EOF in the string state. */
              EM_error(EM_tokPos, "String not closed at end of file!");
              yyterminate();
            }

    [^\\\n\"]* {
                 /* Normal text. */
                 adjust();
                 char *yptr = yytext;
                 while (*yptr) {
                   *string_buf_ptr++ = *yptr++;
                 }
               }

}

[a-zA-Z]+[_0-9a-zA-Z]* {
                         adjust();
                         yylval.sval = strdup(yytext);
                         return ID;
                       }

[0-9]+ {
          adjust();
          yylval.ival = atoi(yytext);
          return INT;
       }

"/*" {
       adjust();
       commentNesting++;
       BEGIN(COMMENT);
     }

"*/" {
       adjust();
       EM_error(EM_tokPos, "Wrong nesting in comments!");
     }

<COMMENT>{

    "/*" {
           adjust();
           commentNesting++;
           continue;
         }

    "*/" {
           adjust();
           check_commentNesting();
           commentNesting--;
           if (commentNesting == 0)
           {
             BEGIN(INITIAL);
           }
         }

    <<EOF>> {
              //adjust();
              EM_error(EM_tokPos, "Comment still open at end of file!");
              yyterminate();
            }

    . {
        adjust();
      }

}

. {
    adjust();
    EM_error(EM_tokPos, "illegal token");
  }
