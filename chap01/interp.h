#ifndef INTERP_H
#define INTERP_H

/*
 * "Interpret" a program in this language.
 */
void interp(A_stm stm);

void interpStm(A_stm stm); // must be recursive!

void interpExp(A_exp exp); // must be recursive!

#endif /* INTERP_H */
