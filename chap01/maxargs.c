#include "maxargs.h"

int
maxargs(A_stm stm) {

  switch (stm->kind) {

    case A_compoundStm:

      return max( maxargs(stm->u.compound.stm1),
                  maxargs(stm->u.compound.stm2) );

    case A_assignStm:

      return maxargs_exp(stm->u.assign.exp);

    case A_printStm:

      return max( count_exp(stm->u.print.exps),
                  maxargs_expList(stm->u.print.exps) );

    default:

      /* This should not happen! */
      assert(!"Wrong kind-value for A_stm!");

  }

}


int
max(int a, int b) {
  return (a > b) ? a : b;
}


int
count_exp(A_expList expList) {

  A_expList el = expList;

  int count;
  for (count = 1; el->kind != A_lastExpList; el = el->u.pair.tail) {
    count += 1;
  }

  return count;

}


int
maxargs_exp(A_exp exp) {

  switch (exp->kind) {

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

    default:

      /* This should not happen! */
      assert(!"Wrong kind-value for A_exp->kind!");

  }

}


int
maxargs_expList(A_expList expList) {

  switch (expList->kind) {

    case A_pairExpList:

      return max( maxargs_exp(expList->u.pair.head),
                  maxargs_expList(expList->u.pair.tail) );

    case A_lastExpList:

      return maxargs_exp(expList->u.last);

    default:

      /* This should not happen */
      assert(!"Wrong kind-value for A_expList!");

  }

}
