#include <stdio.h>
#include "prog1.h"
#include "maxargs.h"

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

  return 0;
}
