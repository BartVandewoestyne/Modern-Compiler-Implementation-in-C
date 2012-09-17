#ifndef MAXARGS_H
#define MAXARGS_H

#include "slp.h"

/*
 * Return the maximum number of arguments of any print statement within any
 * subexpression of a given statement.  For example, maxargs(prog) is 2.
 */
int maxargs(A_stm stm);

/*
 * Return the maximum of a and b.
 */
static int max(int a, int b);

/*
 * Count the number of expressions in an expression list.
 */
static int count_exp(A_expList expList);

/*
 * Return the maximum number of arguments of any print statement within any
 * subexpression of a given expression.
 */
static int maxargs_exp(A_exp exp);

/*
 * Return the maximum number of arguments of any print statement within any
 * subexpression of a given expression list.
 */
static int maxargs_expList(A_expList expList);

#endif /* MAXARGS_H */
