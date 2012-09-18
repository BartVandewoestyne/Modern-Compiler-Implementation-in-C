#include <stdio.h>
#include "prog1.h"
#include "interp.h"

int main()
{
  printf("prog():\n");
  interp(prog());
  printf("prog_test1():\n");
  interp(prog_test1());
  printf("prog_test2():\n");
  interp(prog_test2());
  printf("prog_test3():\n");
  interp(prog_test3());

  return 0;
}
