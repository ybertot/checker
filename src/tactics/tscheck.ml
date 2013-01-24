(** Implement the binary equivalence algorithms from sections 5 and 6 of the paper as type checker for TS:

    [EEST]: Extensional Equivalence and Singleton Types
    by Christopher A. Stone and Robert Harper
    ACM Transactions on Computational Logic, Vol. 7, No. 4, October 2006, Pages 676-722.

*)

open Printf
open Printer
open Typesystem
open Lfcheck
open Error

exception Match_failure

let see n x = printf "\t  %s = %a\n%!" n _e x

let args2 s =
  match s with
  | ARG(x,ARG(y,END)) -> x,y
  | _ -> raise Match_failure

(** returns a term y and a derivation of hastype y t and a derivation of oequal x y t *)
let rec head_reduction (env:context) (t:lf_expr) (dt:lf_expr) (x:lf_expr) (dx:lf_expr) : lf_expr * lf_expr * lf_expr =
  (* dt : istype t *)
  (* dx : hastype x t *)
  raise NotImplemented

(** returns a term y and a derivation of hastype y t and a derivation of oequal x y t *)
let rec head_normalization (env:context) (t:lf_expr) (dt:lf_expr) (x:lf_expr) (dx:lf_expr) : lf_expr * lf_expr * lf_expr =
  (* dt : istype t *)
  (* dx : hastype x t *)
  raise NotImplemented

(** returns a derivation of oequal x y t *)
let rec term_equivalence (env:context) (x:lf_expr) (dx:lf_expr) (y:lf_expr) (dy:lf_expr) (t:lf_expr) (dt:lf_expr) : lf_expr =
  (* dt : istype t *)
  (* dx : hastype x t *)
  (* dy : hastype y t *)
  raise NotImplemented

(** returns a type t and derivation of hastype x t, hastype y t, oequal x y t *)
and path_equivalence (env:context) (x:lf_expr) (y:lf_expr) : lf_expr * lf_expr * lf_expr =
  raise NotImplemented

(** returns a derivation of tequal t u *)
and type_equivalence (env:context) (t:lf_expr) (dt:lf_expr) (u:lf_expr) (du:lf_expr) : lf_expr =
  (* dt : istype t *)
  (* du : istype u *)
  raise NotImplemented

(** returns a derivation of hastype e t *)
let rec type_check (env:context) (e:lf_expr) (t:lf_expr) (dt:lf_expr) : lf_expr =
  (* dt : istype t *)
  (* see figure 13, page 716 [EEST] *)
  let (s,ds,h) = type_synthesis env e in	(* ds : istype x ; h : hastype e s *)
  if Alpha.UEqual.term_equiv empty_uContext s t then h
  else 
  let e = type_equivalence env s ds t dt in	(* e : tequal s t *)
  ignore e;
  raise NotImplemented			(* here we'll apply the rule "cast" *)

(** returns a type t and derivations of istype t and hastype x t *)
and type_synthesis (env:context) (x:lf_expr) : lf_expr * lf_expr * lf_expr =
  (* assume nothing *)
  (* see figure 13, page 716 [EEST] *)

  (* match unmark e with *)
  (* | APPLY(O O_lambda, tx) -> ( *)
  (*     let (t,x) = args2 tx in *)

  raise NotImplemented

(** returns a derivation of istype t *)
let type_validity (env:context) (t:lf_expr) : lf_expr =
  raise NotImplemented

(** returns a term y and a derivation of hastype y t and a derivation of oequal x y t *)
let rec term_normalization (env:context) (t:lf_expr) (dt:lf_expr) (x:lf_expr) (dx:lf_expr) : lf_expr * lf_expr * lf_expr =
  (* dt : istype t *)
  (* dx : hastype x t *)
  raise NotImplemented

(** returns the type t of x and derivations of istype t and hastype x t  *)
and path_normalization (env:context) (x:lf_expr) : lf_expr * lf_expr * lf_expr =
  raise NotImplemented

let rec type_normalization (env:context) (t:lf_expr) : lf_expr =
  raise NotImplemented

let tscheck surr env pos t args =
  match unmark t with
  | F_Apply(h,[x;t]) -> (
      printf "tscheck\n\t  x = %a\n\t  t = %a\n%!" _e x _e t;
      try
	let dt = type_validity env t in	(* we should be able to get this from the context *)
	TacticSuccess (type_check env x t dt)
      with
	NotImplemented|Match_failure -> TacticFailure
     )
  | _ -> TacticFailure

(* 
  Local Variables:
  compile-command: "make -C ../.. src/tactics/tscheck.cmo "
  End:
 *)
