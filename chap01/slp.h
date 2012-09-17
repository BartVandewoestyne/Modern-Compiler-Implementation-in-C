/*
 * Each grammar symbol (Stm, Exp, ExpList, Binop) corresponds to a typedef in
 * the data structures.  Each typedef defines a pointer to a corresponding
 * struct.  The struct name, which ends in an underscore, is never used
 * anywhere except in the declaration of the typedef and the definition of the
 * struct itself.
 *
 * Each struct contains a kind field, which is an enum showing different
 * variants, one for each grammar rule; and a u field, which is a union.  Each
 * grammar rule has right-hand-side components that must be represented in the
 * data structures.  Each grammar symbol's struct contains a union to carry
 * these values, and a kind field to indicate which variant of the union is
 * valid.
 *
 * If there is more than one nontrivial (value-carrying) symbol in the
 * right-hand side of a rule (example: the rule CompoundStm), the union will
 * have a component that is itself a struct comprising these values (example:
 * the compound element of the A_stm_ union).
 *
 * If there is only one nontrivial symbol in the right-hand side of a rule, the
 * union will have a component that is the value (example: the num field of the
 * A_exp union).
 *
 * For each variant (CompoundStm, AssignStm, etc.) we make a constructor
 * function to malloc and initialize the data structure.  For each grammar
 * rule, there is one constructor that belongs to the union for its
 * left-hand-side symbol.  This constructor function initializes all fields.
 * The malloc function shall never be called directly, except in these
 * constructor functions.
 *
 * For BinOp, we do not make a Binop struct because this would be overkill:
 * none of the variants would carry any data.  Instead, we make an enum type
 * A_binop.
 *
 * Each module (header file) shall have a prefix unique to that module (example
 * A_ in this file).
 *
 * Typedef names (after the prefix) shall start with lowercase letters;
 * constructor functions (after the prefix) with uppercase; enumeration atoms
 * (after the prefix) with lowercase; and union variants (which have no prefix)
 * with lowercase.
 */

#ifndef SLP_H
#define SLP_H

#include "util.h"

typedef struct A_stm_ *A_stm;
typedef struct A_exp_ *A_exp;
typedef struct A_expList_ *A_expList;
typedef enum {A_plus, A_minus, A_times, A_div} A_binop;


/*
 * Stm -> Stm; Stm     (CompoundStm)
 * Stm -> id := Exp      (AssignStm)
 * Stm -> print(ExpList)  (PrintStm)
 */
struct A_stm_ {
  enum {A_compoundStm, A_assignStm, A_printStm} kind;
  union {
    struct {A_stm stm1, stm2;} compound;
    struct {string id; A_exp exp;} assign;
    struct {A_expList exps;} print;
  } u;
};
A_stm A_CompoundStm(A_stm stm1, A_stm stm2);
A_stm A_AssignStm(string id, A_exp exp);
A_stm A_PrintStm(A_expList exps);


/*
 * Exp -> id             (IdExp)
 * Exp -> num           (NumExp)
 * Exp -> Exp Binop Exp  (OpExp)
 * Exp -> (Stm, Exp)   (EseqExp)
 */
struct A_exp_ {
  enum {A_idExp, A_numExp, A_opExp, A_eseqExp} kind;
  union {
    string id;
    int num;
    struct {A_exp left; A_binop oper; A_exp right;} op;
    struct {A_stm stm; A_exp exp;} eseq;
  } u;
};
A_exp A_IdExp(string id);
A_exp A_NumExp(int num);
A_exp A_OpExp(A_exp left, A_binop oper, A_exp right);
A_exp A_EseqExp(A_stm stm, A_exp exp);


/*
 * ExpList -> Exp, ExpList  (PairExpList)
 * ExpList -> Exp           (LastExpList)
 */
struct A_expList_ {
  enum {A_pairExpList, A_lastExpList} kind;
  union {
    struct {A_exp head; A_expList tail;} pair;
    A_exp last;
  } u;
};
A_expList A_PairExpList(A_exp head, A_expList tail);
A_expList A_LastExpList(A_exp last);


#endif /* SLP_H */
