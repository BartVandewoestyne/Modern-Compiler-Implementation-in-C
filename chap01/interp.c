#include <string.h>
#include "slp.h"
#include "interp.h"
#include "util.h"

Table_  Table(string id, int value, struct table *tail) {
  Table_ t = malloc(sizeof(*t));
  t->id = id;
  t->value = value;
  t->tail = tail;
  return t;
}

void interp(A_stm stm) {
}

Table_ interpStm(A_stm s, Table_ t) {
  return NULL;
}

struct IntAndTable interpExp(A_exp e, Table_ t) {
  ;
}

Table_ update(Table_ t, string id, int value) {
  Table_ newElement = Table(id, value, t);
  return newElement;
}

int lookup(Table_ t, string key) {
  while (t != NULL) {
    if (strcmp(t->id, key) == 0) {
      return t->value;
    }
  }
  return 1; // TODO: can this happen???
}
