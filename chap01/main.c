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
 * Return the maximum of two integers.
 */
static int max(int a, int b);

int main()
{
  int n;

  n = maxargs(prog());
  printf("maxargs prog(): %d (should be 2)\n", n);
  n = maxargs(prog_test1());
  printf("maxargs prog_test1(): %d (should be 1)\n", n);
  n = maxargs(prog_test2());
  printf("maxargs prog_test2(): %d (should be 5)\n", n);

  interp(prog());

  return 0;
}


int maxargs(A_stm stm) {

  switch ( stm->kind ) {

    case A_compoundStm:
    {
      return max( maxargs( stm->u.compound.stm1 ),
                  maxargs( stm->u.compound.stm2 ) );
    }
    case A_assignStm:
    {
      A_exp e = stm->u.assign.exp;
      if (e->kind == A_eseqExp) {
        A_stm s = e->u.eseq.stm;
        return maxargs(s);
      } 
      return 0;
    }
    case A_printStm:
    {
      int count = 1;
      A_expList es = stm->u.print.exps;
      while (es->kind != A_lastExpList) {
         A_exp e = es->u.pair.head;
         if (e->kind == A_eseqExp) {
           A_stm s = e->u.eseq.stm;
           count += maxargs(s);
         }
         es = es->u.pair.tail;
      }
      return count;
    }
  }

}


void interp(A_stm stm) {
}


static int
max(int a, int b) {
  return ( a > b ) ? a : b;
}
