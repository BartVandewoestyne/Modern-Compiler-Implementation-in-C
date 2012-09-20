#include <stdio.h>
#include "persistent_binding_tree.h"

int main()
{
  T_tree t1 = NULL;
  t1 = insert(String("t"), (void *) 1, t1);
  t1 = insert(String("s"), (void *) 2, t1);
  t1 = insert(String("p"), (void *) 3, t1);
  t1 = insert(String("i"), (void *) 4, t1);
  t1 = insert(String("p"), (void *) 5, t1);
  t1 = insert(String("f"), (void *) 6, t1);
  t1 = insert(String("b"), (void *) 7, t1);
  t1 = insert(String("s"), (void *) 8, t1);
  t1 = insert(String("t"), (void *) 9, t1);

  printf("Tree: tspipfbst\n");
  printf("%ld\n", (long int) lookup(String("t"), t1)); /* 9 (last entered value) */
  printf("%ld\n", (long int) lookup(String("s"), t1)); /* 8 (last entered value) */
  printf("%ld\n", (long int) lookup(String("p"), t1)); /* 5 */
  printf("%ld\n", (long int) lookup(String("i"), t1)); /* 4 */
  printf("%ld\n", (long int) lookup(String("f"), t1)); /* 6 */
  printf("%ld\n", (long int) lookup(String("b"), t1)); /* 7 */

  T_tree t2 = NULL;
  t2 = insert(String("a"), (void *) 1, t2);
  t2 = insert(String("b"), (void *) 2, t2);
  t2 = insert(String("c"), (void *) 3, t2);
  t2 = insert(String("d"), (void *) 4, t2);
  t2 = insert(String("e"), (void *) 5, t2);
  t2 = insert(String("f"), (void *) 6, t2);
  t2 = insert(String("g"), (void *) 7, t2);
  t2 = insert(String("h"), (void *) 8, t2);
  t2 = insert(String("i"), (void *) 9, t2);

  return 0;
}
