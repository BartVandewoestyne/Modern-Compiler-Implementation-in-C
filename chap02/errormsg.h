/*
 * Error message module, useful for producing error messages with file names
 * and line numbers.
 */

extern bool EM_anyErrors;

void EM_newline(void);

extern int EM_tokPos;

void EM_error(int, string,...);
void EM_impossible(string,...);
void EM_reset(string filename);
