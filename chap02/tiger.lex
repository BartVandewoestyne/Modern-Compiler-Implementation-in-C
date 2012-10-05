%{

#include <assert.h>
#include <string.h>
#include <stdlib.h>
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

/* Helper variables for building up strings from characters. */
const int INITIAL_BUFFER_LENGTH = 32;
char *string_buffer;
unsigned int string_buffer_capacity;

/*
 * Initialize the string buffer.
 */
void init_string_buffer(void)
{
  string_buffer = checked_malloc(INITIAL_BUFFER_LENGTH);
  string_buffer[0] = 0;
  string_buffer_capacity = INITIAL_BUFFER_LENGTH;
}

/*
 * Append the given character to the string buffer and double
 * the buffer's capacity if necessary.
 */
static void append_char_to_stringbuffer(char ch)
{
    size_t new_length = strlen(string_buffer) + 1;
    if (new_length == string_buffer_capacity)
    {
        char *temp;

        string_buffer_capacity *= 2;
        temp = checked_malloc(string_buffer_capacity);
        memcpy(temp, string_buffer, new_length);
        free(string_buffer);
        string_buffer = temp;
    }
    string_buffer[new_length - 1] = ch;
    string_buffer[new_length] = 0;
}

/*
 * Make sure the scanner terminates by supplying our own yywrap() function and
 * making it return 1.  See also `man flex` for more information.
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

  /* Skip spaces, carriage returns and tabs. */
[ \r\t] {adjust(); continue;}

  /* Increment the line counter if we detect a newline in the
     INITIAL or COMMENT state. */
<INITIAL,COMMENT>\n {
                      adjust();
                      EM_newline();
                      continue;
                    }

  /* Reserved words of the language. */
while     {adjust(); return WHILE;}
for       {adjust(); return FOR;}
to        {adjust(); return TO;}
break     {adjust(); return BREAK;}
let       {adjust(); return LET;}
in        {adjust(); return IN;}
end       {adjust(); return END;}
function  {adjust(); return FUNCTION;}
var       {adjust(); return VAR;}
type      {adjust(); return TYPE;}
array     {adjust(); return ARRAY;}
if        {adjust(); return IF;}
then      {adjust(); return THEN;}
else      {adjust(); return ELSE;}
do        {adjust(); return DO;}
of        {adjust(); return OF;}
nil       {adjust(); return NIL;}

  /* Punctuation symbols of the language. */
","   {adjust(); return COMMA;}
":"   {adjust(); return COLON;}
";"   {adjust(); return SEMICOLON;}
"("   {adjust(); return LPAREN;}
")"   {adjust(); return RPAREN;}
"["   {adjust(); return LBRACK;}
"]"   {adjust(); return RBRACK;}
"{"   {adjust(); return LBRACE;}
"}"   {adjust(); return RBRACE;}
"."   {adjust(); return DOT;}
"+"   {adjust(); return PLUS;}
"-"   {adjust(); return MINUS;}
"*"   {adjust(); return TIMES;}
"/"   {adjust(); return DIVIDE;}
"="   {adjust(); return EQ;}
"<>"  {adjust(); return NEQ;}
"<"   {adjust(); return LT;}
"<="  {adjust(); return LE;}
">"   {adjust(); return GT;}
">="  {adjust(); return GE;}
"&"   {adjust(); return AND;}
"|"   {adjust(); return OR;}
":="  {adjust(); return ASSIGN;}

  /* Identifiers. */
[a-zA-Z]+[_0-9a-zA-Z]* {
                         adjust();
                         yylval.sval = strdup(yytext);
                         return ID;
                       }

  /* Unsigned integers. */
[0-9]+ {
          adjust();
          yylval.ival = atoi(yytext);
          return INT;
       }

  /* Start of a string. */
\" {
     adjust();
     init_string_buffer();
     BEGIN(STRING_STATE);
   }

  /* Start of a comment. */
"/*" {
       adjust();
       commentNesting++;
       BEGIN(COMMENT);
     }

  /* End of a comment before the comment even started -> ERROR! */
"*/" {
       adjust();
       EM_error(EM_tokPos, "Found closing comment tag while no comment was open!");
       yyterminate();
     }

  /* Anything else that's not matched yet is an illegal token. */
. {
    adjust();
    EM_error(EM_tokPos, "Illegal token!");
    yyterminate();
  }


<STRING_STATE>{

    /* Closing quote: terminate the string buffer pointer with zero and copy 
     * its value to where it belongs. */
    \" {
          adjust();
          BEGIN(INITIAL);
          yylval.sval = strdup(string_buffer);
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
                 if (result > 0xff) {
                   EM_error(EM_tokPos, "ASCII decimal value out of bounds!");
                   yyterminate();
                 }
                 append_char_to_stringbuffer(result);
               }

    /* Escape sequences like ’\48’ or ’\0777777’ are errors! */
    \\[0-9]+ {
               adjust();
               EM_error(EM_tokPos, "Bad escape sequence!");
               yyterminate();
             }

    /* Newline escape sequence. */
    \\n {
          adjust();
          append_char_to_stringbuffer('\n');
        }

    /* Tab escape sequence. */
    \\t {
          adjust();
          append_char_to_stringbuffer('\t');
        }

    /*
     * The control character c, for any appropriate c, in caret notation.
     * See http://en.wikipedia.org/wiki/ASCII#ASCII_control_characters for
     * a list.
     */
    "\^"[@A-Z\[\\\]\^_?] {
                           adjust();
                           append_char_to_stringbuffer(yytext[1]-'@');
                         }

    /* The double-quote character (") inside a string. */
    "\\\"" {
             adjust();
             append_char_to_stringbuffer('"');
           }

    /* The backslash character (\) inside a string. */
    "\\\\" {
             adjust();
             append_char_to_stringbuffer('\\');
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
                        }
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
                   append_char_to_stringbuffer(*yptr++);
                 }
               }

}


<COMMENT>{

    /* A comment that starts inside a comment means that the
       comment nesting depth increases by one. */
    "/*" {
           adjust();
           commentNesting++;
           continue;
         }

    /* When a comment closes, we first check if this is possible and
       then decrease the comment nesting depth.  If we thereby arrive
       at a nesting depth of 0, this means we are not longer inside
       a comment and we can go back to the INITIAL state. */
    "*/" {
           adjust();
           commentNesting--;
           if (commentNesting == 0) {
             BEGIN(INITIAL);
           }
         }

    /* It's an error if we encounter the End Of File when inside a comment. */
    <<EOF>> {
              EM_error(EM_tokPos, "Comment still open at end of file!");
              yyterminate();
            }

    /* Eat anything else inside a comment. */
    . {
        adjust();
      }

}
