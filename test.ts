Print x.
Print T.
Print [El](x).
Print [U](uu4).
Print [j](uu1, uu2).
Print *[u](uu4).
Print max((uu1+1+0)+4,2).
Print [Sigma;x](T,T').
Print [Coprod](T,T').
Print [Coprod;x,x'](T,T',U,U',o).
Print [Empty]().
Print [IC;x,y,z](A,a,B,D,q).
Print [Id](T,x,y).

Print [forall;x](uu1,uu2,o,o').

Print Pi x : T1, [U](14).
Print *x.
Print lambda x : T, e.
Print lambda f:T->U, lambda o:T, lambda x : *r, f o.
Print A->B->C.

Subst lambda y: *v, lambda x:T, lambda x:T, v [[forall;y](uu1,uu2,x,x')/v].
Type [u](uu4).
Type [j](uu,uu').
Type [ev;x](f,o,T).
Type [ev;x](f,o,*x).
Type [lambda;x](T,x).
Type [forall;x](uu1,uu2,o,o').

Derive (1,,[]).