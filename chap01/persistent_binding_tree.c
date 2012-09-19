#include <string.h>
#include "util.h"
#include "persistent_binding_tree.h"

T_binding Binding(string key, void *value) {
  T_binding b = checked_malloc(sizeof(*b));
  b->key = key;
  b->value = value;
  return b;
}


T_tree Tree(T_tree l, T_binding b, T_tree r) {
  T_tree t = checked_malloc(sizeof(*t));
  t->left = l;
  t->binding = b;
  t->right = r;
  return t;
}


T_tree insert(string key, void *value, T_tree t) {
  if (t==NULL) {

    return Tree(NULL, Binding(key, value), NULL);

  } else if (strcmp(key, t->binding->key) < 0) {

    return Tree(insert(key, value, t->left), t->binding, t->right);

  } else if (strcmp(key, t->binding->key) > 0) {

    return Tree(t->left, t->binding, insert(key, value, t->right));

  } else {

    return Tree(t->left, Binding(key, value), t->right);
  }
}


void * lookup(string key, T_tree t) {
  if (t==NULL) {
    return NULL;
  } else if (strcmp(key, t->binding->key) < 0) {
    return lookup(key, t->left);
  } else if (strcmp(key, t->binding->key) > 0) {
    return lookup(key, t->right);
  } else {
    return t->binding->value;
  }
}
