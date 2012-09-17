#include <stdio.h>
#include "util.h"
#include "slp.h"
#include "prog1.h"

/*
 * Return the maximum number of arguments of any print statement within any
 * subexpression of a given statement.  For example, maxargs(prog) is 2.
 */
int maxargs(A_stm stm);

/*
 * "Interpret" a program in this language.
 */
void interp(A_stm stm);

/*
 * Return the maximum of a and b.
 */
static int max(int a, int b);

/*
 * Count the number of expressions in an expression list.
 */
static int count_exp( A_expList );

/*
 * Return the maximum number of arguments of any print statement within any
 * subexpression of a given expression.
 */
static int maxargs_exp( A_exp );

/*
 * Return the maximum number of arguments of any print statement within any
 * subexpression of a given expression list.
 */
static int maxargs_expList( A_expList );


int main()
{
  int n;

  n = maxargs(prog());
  printf("maxargs prog(): %d (should be 2)\n", n);
  n = maxargs(prog_test1());
  printf("maxargs prog_test1(): %d (should be 1)\n", n);
  n = maxargs(prog_test2());
  printf("maxargs prog_test2(): %d (should be 2)\n", n);
  n = maxargs(prog_test3());
  printf("maxargs prog_test3(): %d (should be 5)\n", n);

  interp(prog());

  return 0;
}


int
maxargs(A_stm stm) {

  switch (stm->kind) {

    case A_compoundStm:

      return max( maxargs(stm->u.compound.stm1),
                  maxargs(stm->u.compound.stm2) );

    case A_assignStm:

      return maxargs_exp( stm->u.assign.exp );

    case A_printStm:

      return max( count_exp(stm->u.print.exps),
                  maxargs_expList(stm->u.print.exps) );

  }

}


void
interp(A_stm stm) {
  // TODO
}


static int
max(int a, int b) {
  return ( a > b ) ? a : b;
}


static int
count_exp(A_expList expList) {

  A_expList el = expList;

  int count;
  for (count = 1; el->kind != A_lastExpList; el = el->u.pair.tail) {
    count += 1;
  }

  return count;

}


static int
maxargs_exp(A_exp exp) {

  switch( exp->kind ) {

    case A_idExp:

      return 0;

    case A_numExp:

      return 0;

    case A_opExp:

      return max( maxargs_exp(exp->u.op.left),
                  maxargs_exp(exp->u.op.right) );

    case A_eseqExp:

      return max( maxargs(exp->u.eseq.stm),
                  maxargs_exp(exp->u.eseq.exp) );

  }

}


static int
maxargs_expList(A_expList expList) {

  switch (expList->kind) {

    case A_pairExpList:

      return max( maxargs_exp(expList->u.pair.head),
                  maxargs_expList(expList->u.pair.tail) );

    case A_lastExpList:

      return maxargs_exp(expList->u.last);

  }

}
