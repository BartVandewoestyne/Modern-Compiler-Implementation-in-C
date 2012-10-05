SHIFT-REDUCE CONFLICTS THAT I ENCOUNTERED:

  IF expression THEN expression
  (if x=1 then a = 1) + 2
  or
  (if x=1 then a = 1 + 2)

  IF expression THEN expression ELSE expression
  (if x=1 then a = 1 else a = 1) + 2
  or
  (if x=1 then a = 1 else a = 1 + 2)

  WHILE expression DO expression
  (while x=1 do a = 1) + 2
  or
  (while x=1 do a = 1 + 2)

  ID LBRACK expression RBRACK OF expression
  (x[3] of 1) + 2
  or
  (x[3] of 1 + 2)

References:

  [1] http://linuxgazette.net/issue93/ramankutty.html


