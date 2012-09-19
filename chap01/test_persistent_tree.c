#include <stdio.h>
#include "persistent_tree.h"

int main()
{
  T_tree t1 = NULL;
  t1 = insert(String("t"), t1);
  t1 = insert(String("s"), t1);
  t1 = insert(String("p"), t1);
  t1 = insert(String("i"), t1);
  t1 = insert(String("p"), t1);
  t1 = insert(String("f"), t1);
  t1 = insert(String("b"), t1);
  t1 = insert(String("s"), t1);
  t1 = insert(String("t"), t1);

  printf("Tree: tspipfbst\n");
  if (member(String("a"), t1)) {
    printf("a is a member.\n");
  } else {
    printf("a is not a member.\n");
  }
  if (member(String("b"), t1)) {
    printf("b is a member.\n");
  } else {
    printf("b is not a member.\n");
  }

  T_tree t2 = NULL;
  t2 = insert(String("a"), t2);
  t2 = insert(String("b"), t2);
  t2 = insert(String("c"), t2);
  t2 = insert(String("d"), t2);
  t2 = insert(String("e"), t2);
  t2 = insert(String("f"), t2);
  t2 = insert(String("g"), t2);
  t2 = insert(String("h"), t2);
  t2 = insert(String("i"), t2);

  return 0;
}
