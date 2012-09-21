/*
 * Definition of lexical-token constants and yylval.
 *
 * Here, we define integer constants IF, ID, NUM, and so on.  These values are
 * returned by the action fragments in the .lex file to tell what token-type
 * is matched.
 */


/*
 * Some tokens have semantic values associated with them.  For example, ID's
 * semantic value is the character string constituting the identifier; NUM's
 * semantic value is an integer; and IF has no semantic value (any IF is
 * indistinguishable from any other).  The values are communicated to the
 * parser through the global variable yylval, which is a union of the different
 * types of semantic values.  The token-type returned by the lexer tells the
 * parser which variant of the union is valid.
 */
typedef union  {
  int pos;
  int ival;
  string sval;
} YYSTYPE;
extern YYSTYPE yylval;

# define ID 257
# define STRING 258
# define INT 259
# define COMMA 260
# define COLON 261
# define SEMICOLON 262
# define LPAREN 263
# define RPAREN 264
# define LBRACK 265
# define RBRACK 266
# define LBRACE 267
# define RBRACE 268
# define DOT 269
# define PLUS 270
# define MINUS 271
# define TIMES 272
# define DIVIDE 273
# define EQ 274
# define NEQ 275
# define LT 276
# define LE 277
# define GT 278
# define GE 279
# define AND 280
# define OR 281
# define ASSIGN 282
# define ARRAY 283
# define IF 284
# define THEN 285
# define ELSE 286
# define WHILE 287
# define FOR 288
# define TO 289
# define DO 290
# define LET 291
# define IN 292
# define END 293
# define OF 294
# define BREAK 295
# define NIL 296
# define FUNCTION 297
# define VAR 298
# define TYPE 299
