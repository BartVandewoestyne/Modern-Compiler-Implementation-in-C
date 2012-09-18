#ifndef INTERP_H
#define INTERP_H

#include "stdlib.h"
#include "util.h"

typedef struct table *Table_;

struct table {
  string id;
  int value;
  Table_ tail;
};

Table_ Table(string id, int value, struct table *tail) {
  Table_ t = malloc(sizeof(*t));
  t->id = id;
  t->value = value;
  t->tail = tail;
  return t;
}

/*
 * "Interpret" a program in this language.
 */
void interp(A_stm stm);

void interpStm(A_stm stm); // must be recursive!

void interpExp(A_exp exp); // must be recursive!

#endif /* INTERP_H */
