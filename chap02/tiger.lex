%{

#include <assert.h>
#include <string.h>
#include "util.h"
#include "tokens.h"
#include "errormsg.h"

/*
 * Variable to keep track of the position of each token, measured in characters
 * since the beginning of the file.
 */
int charPos = 1;

/*
 * Variable to keep track of the depth that comments are nested.
 */
int commentNesting = 0;

/*
 * Check if the comment nesting depth is smaller than 1.  This function is
 * called when we encounter a closing comment.  If the nesting depth is smaller
 * than one, this means we cannot close any comment anymore.
 */
void check_commentNesting()
{
  if (commentNesting < 1)
  {
    EM_error(EM_tokPos, "Wrong nesting in comments!");
  }
}

/*
 * TODO: what is the purpose of this function?  When exactly is it called???
 */
int yywrap(void)
{
  charPos = 1;
  return 1;
}

/*
 * The EM_tokPos variable of the error message module errormsg.h is continually
 * told the charPos position by calls to the function adjust().  The parser
 * will be able to use this information in printing informative syntax error
 * messages.
 */
void adjust(void)
{
  EM_tokPos = charPos;
  charPos += yyleng;
}

%}

/* We need these options to avoid some gcc compiler warnings. */
%option nounput
%option noinput

%x COMMENT STRING_STATE

%%

  /* Helper variables for building up our strings. */
  char string_buf[512];
  char *string_buf_ptr;


  /* Skip spaces, carriage returns and tabs. */
" "|\r|\t              {adjust(); continue;}

  /* Increment the line counter if we detect a newline in the
     INITIAL or COMMENT state. */
<INITIAL,COMMENT>\n    {
                         adjust();
                         EM_newline();
                         continue;
                       }

  /* Reserved words of the language. */
while                  {adjust(); return WHILE;}
for                    {adjust(); return FOR;}
to                     {adjust(); return TO;}
break                  {adjust(); return BREAK;}
let                    {adjust(); return LET;}
in                     {adjust(); return IN;}
end                    {adjust(); return END;}
function               {adjust(); return FUNCTION;}
var                    {adjust(); return VAR;}
type                   {adjust(); return TYPE;}
array                  {adjust(); return ARRAY;}
if                     {adjust(); return IF;}
then                   {adjust(); return THEN;}
else                   {adjust(); return ELSE;}
do                     {adjust(); return DO;}
of                     {adjust(); return OF;}
nil                    {adjust(); return NIL;}

  /* Punctuation symbols of the language. */
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

  /* Start of a string. */
\"                     {
                         adjust();

                         /* Initialize the string buffer pointer and switch to
                            the STRING_STATE. */
                         string_buf_ptr = string_buf;
                         BEGIN(STRING_STATE);
                       }

<STRING_STATE>{

    /* Closing quote: terminate the string buffer pointer with zero and copy 
     * its value to where it belongs. */
    \" {
          adjust();
          BEGIN(INITIAL);
          *string_buf_ptr = '\0';
          yylval.sval = strdup(string_buf);
          return STRING;
       }

    /* A newline somewhere in a string is an unterminated string error. */
    \n {
         adjust();
         EM_error(EM_tokPos, "Unterminated string constant!");
         yyterminate();
       }

    /* The single character with ASCII code ddd (3 decimal digits). */
    \\[0-9]{3} {
                 adjust();
                 int result;
                 sscanf(yytext + 1, "%d", &result);
                 printf("result = %d\n", result);
                 if (result > 0xff) {
                   EM_error(EM_tokPos, "ASCII decimal value out of bounds!");
                 }
                 *string_buf_ptr++ = result;
               }

    /* Escape sequences like ’\48’ or ’\0777777’ are errors! */
    \\[0-9]+ {
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

    /*
     * The control character c, for any appropriate c, in caret notation.
     * See http://en.wikipedia.org/wiki/ASCII#ASCII_control_characters for
     * a list.
     */
    "\^"[@A-Z\[\\\]\^_?] {
               adjust();
               char key;
               sscanf(yytext, "^%c", &key);
               /* The Control key subtracts 64 from the value of the keys that
                  it modifies. */
               *string_buf_ptr++ = key - 64;
             }

    /* The double-quote character (") inside a string. */
    "\\\"" {
             adjust();
             *string_buf_ptr++ = '"';
           }

    /* The backslash character (\) inside a string. */
    "\\\\" {
             adjust();
             *string_buf_ptr++ = '\\';
           }

    /* The \f...f\ sequence to be ignored, where f...f stands for a sequence of
       one or more formatting characters (a subset of the non-printable
       characters including at least space, tab, newline, formfeed).  This
       allows one to write long strings on more than one line, by writing \ at
       the end of one line and at the start of the next. */
    \\[ \t\n\f]+\\ {
                     adjust();
                     /* Handle newlines correctly. */
                     int i;
                     for (i = 0; yytext[i]; i++) {
                        if (yytext[i] == '\n') {
                          EM_newline();
                        };
                     }
                     continue;
                   }

    /* Catches EOF in the string state. */
    <<EOF>> {
              EM_error(EM_tokPos, "String not closed at end of file!");
              yyterminate();
            }

    /* Normal text. */
    [^\\\n\"]* {
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
