#include <stdio.h>
#include <string.h>
#include "slp.h"
#include "interp.h"
#include "util.h"


Table_
Table(string id, int value, struct table *tail) {
  Table_ t = malloc(sizeof(*t));
  t->id = id;
  t->value = value;
  t->tail = tail;
  return t;
}


IntAndTable_
IntAndTable(int i, Table_ t) {
  IntAndTable_ it = checked_malloc(sizeof(*it));
  it->i = i;
  it->t = t;
  return it;
}


void
interp(A_stm stm) {
  interpStm(stm, NULL);
}


Table_
interpStm(A_stm s, Table_ t) {

  IntAndTable_ it;

  switch (s->kind) {

    case A_compoundStm:

      t = interpStm(s->u.compound.stm1, t);
      t = interpStm(s->u.compound.stm2, t);
      return t;

    case A_assignStm:

      it = interpExp(s->u.assign.exp, t);
      t = update(it->t, s->u.assign.id, it->i);
      return t;

    case A_printStm:

      it = interpExpList(s->u.print.exps, t);
      return it->t;

    default:

      /* This should not happen! */
      assert(!"Wrong kind-value for A_stm!");

  }

  return t;

}


IntAndTable_
interpExp(A_exp e, Table_ t) {

  switch (e->kind) {

    case A_idExp:

      return IntAndTable(lookup(t, e->u.id), t);
      
    case A_numExp:

      return IntAndTable(e->u.num, t);

    case A_opExp:
    {
      int lval, rval;
      IntAndTable_ it_tmp;

      it_tmp = interpExp(e->u.op.left, t);
      lval = it_tmp->i;
      it_tmp = interpExp(e->u.op.right, it_tmp->t);
      rval = it_tmp->i;

      int value;
      switch (e->u.op.oper) {
        case A_plus:
          value = lval + rval;
          break;
        case A_minus:
          value = lval - rval;
          break;
        case A_times:
          value = lval * rval;
          break;
        case A_div:
          value = lval / rval;
          break;
        default:
          /* This should not happen! */
          assert(!"Wrong value for A_exp->u.op.oper!");
      }

      return IntAndTable(value, it_tmp->t);
    }

    case A_eseqExp:

      t = interpStm(e->u.eseq.stm, t);
      return interpExp(e->u.eseq.exp, t);

    default:

      /* This should not happen! */
      assert(!"Wrong kind-value for A_exp!");

  }

}


IntAndTable_
interpExpList(A_expList expList, Table_ t) {

  IntAndTable_ it;

  switch (expList->kind) {

    case A_pairExpList:

      it = interpExp(expList->u.pair.head, t);
      printf("%d ", it->i);
      return interpExpList(expList->u.pair.tail, it->t);

    case A_lastExpList:

      it = interpExp(expList->u.last, t);
      printf("%d\n", it->i);
      return it;

    default:

      /* This should not happen! */
      assert(!"Wrong kind-value for A_expList->kind.");

  }

}


Table_
update(Table_ t, string id, int value) {
  return Table(id, value, t);
}


int
lookup(Table_ t, string key) {

  Table_ temp = t;
  while (temp != NULL) {
    if (temp->id == key) {
      return t->value;
    }
    temp = temp->tail;
  }

  /* This should not happen! */
  assert(!"Table_t pointer should not be NULL!");

}
