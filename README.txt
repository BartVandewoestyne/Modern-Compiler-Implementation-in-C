My implementation of the Tiger compiler from the book

  Modern Compiler Implementation in C
  Andrew W. Appel
  Cambridge University Press
  ISBN 0-521-60765-5

This work is not finished yet.  From time to time, I hack on it.

I was not quite sure in what C-standard or dialect I was going to write my
code, so I did some investigations...

From the inside of the book, we have:

  First published 1998
  Reprinted with corrections, 1999
  First paperback edition 2004

Also, the code from Chapter 1 defines its own TRUE and FALSE in util.h, and
since C99 has true and false macros in stdbool.h, I think we can conclude that
the book's code is *not* C99.

Finally, in Chapter 2, the strdup function is used.  This function is neither
C90 nor C99... so the code from the book is probably some pre-C90 dialect...

I am therefore simply compiling it with gcc without any -std option.


Some other remarks:
-------------------

* In the post

    https://groups.google.com/d/msg/comp.compilers/QYrE4LvCcCE/fxLyAJfxDocJ

  on comp.compilers it is written that the book was originally written by
  Appel in ML, and then translated to C and Java, so the C and Java are not
  great examples of how to code in those languages (the Java version uses few
  OO programming techniques).

* The code often makes use of a union paired with a discrete value that
  indicates the active member of the union.  This is called a 'discriminated
  union' or 'tagged union'.  The discrete value is called a discriminator or
  tag.  See also

    http://www.drdobbs.com/cpp/discriminated-unions/240009296
    http://en.wikipedia.org/wiki/Tagged_union
