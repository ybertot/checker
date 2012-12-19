(** Substitution. *) 

open Error
open Variables
open Typesystem
open Helpers
open Names
open Printer
open Printf

let fresh pos v subl =
  let v' = newfresh v in
  v', (v,var_to_lf_pos pos v') :: subl

let show_subs (subl : (var * lf_expr) list) =
  printf " subs =\n";
  List.iter (fun (v,e) -> printf "   %a => %a\n" _v v _e e) subl

let spy_counter = ref 0

let spy p subber subl e = 
  if !debug_mode then (
    let n = !spy_counter in
    incr spy_counter;
    show_subs subl;
    printf " in  %d = %a\n%!" n p e;
    let e = subber subl e in
    printf " out %d = %a\n%!" n p e;
    e)
  else subber subl e

let rec subst_list (subl : (var * lf_expr) list) es = List.map (subst subl) es

and subst_spine subl = function
  | ARG(x,a) -> ARG(subst subl x, subst_spine subl a)
  | CAR a -> CAR(subst_spine subl a)
  | CDR a -> CDR(subst_spine subl a)
  | END -> END

and subst subl e = spy _e subst'' subl e

and subst'' subl e = 
  let pos = get_pos e in
  match unmark e with 
  | APPLY(h,args) -> (
      let args = subst_spine subl args in 
      match h with 
      | V v -> (
	  try apply_args (new_pos pos (List.assoc v subl)) args
	  with Not_found -> pos, APPLY(h,args))
      | FUN(f,t) -> raise NotImplemented
      | U _ | T _ | O _ | TAC _ -> pos, APPLY(h,args))
  | CONS(x,y) -> pos, CONS(subst subl x,subst subl y)
  | LAMBDA(v, body) -> 
      let (v,body) = subst_fresh pos subl (v,body) in
      pos, LAMBDA(v, body)

and subst_fresh pos subl (v,e) =
  let (v',subl) = fresh pos v subl in
  let e' = subst subl e in
  v', e'

and apply_args (head:lf_expr) args =
  let rec repeat head args = 
    let pos = get_pos head in
    match unmark head with
    | APPLY(head,brgs) -> (pos, APPLY(head, join_args brgs args))
    | CONS(x,y) -> (
        match args with
        | ARG _ -> raise (GeneralError "too many arguments")
        | CAR args -> repeat x args
	| CDR args -> repeat y args
        | END -> head)
    | LAMBDA(v,body) -> (
        match args with
        | ARG(x,args) -> repeat (subst [(v,x)] body) args
        | CAR args -> raise (GeneralError "pi1 expected a pair")
	| CDR args -> raise (GeneralError "pi2 expected a pair")
        | END -> head)
  in repeat head args

and subst_type_list (subl : (var * lf_expr) list) ts = List.map (subst_type subl) ts

and subst_type subl t = spy _t subst_type'' subl t

and subst_type'' (subl : (var * lf_expr) list) (pos,t) = 
  (pos,
   match t with
   | F_Pi(v,a,b) ->
       let a = subst_type subl a in
       let (v,b) = subst_type_fresh pos subl (v,b) in
       F_Pi(v,a,b)
   | F_Sigma(v,a,b) -> 
       let a = subst_type subl a in
       let (v,b) = subst_type_fresh pos subl (v,b) in
       F_Sigma(v,a,b)
   | F_APPLY(label,args) -> F_APPLY(label, subst_list subl args)
   | F_Singleton(e,t) -> F_Singleton( subst subl e, subst_type subl t ))

and subst_type_fresh pos subl (v,t) =
  let (v,subl) = fresh pos v subl in
  let t = subst_type subl t in
  v,t

let rec subst_kind_list (subl : (var * lf_expr) list) ts = List.map (subst_kind subl) ts

and subst_kind subl k = spy _k subst_kind'' subl k

and subst_kind'' (subl : (var * lf_expr) list) k = 
   match k with
   | K_type -> K_type
   | K_Pi(v,a,b) -> 
       let a = subst_type subl a in
       let (v,b) = subst_kind_fresh (get_pos a) subl (v,b) in K_Pi(v, a, b)

and subst_kind_fresh pos subl (v,t) =
  let (v,subl) = fresh pos v subl in
  v, subst_kind subl t  

let subst_l subs e = if subs = [] then e else subst subs e

let subst_type_l subs t = if subs = [] then t else subst_type subs t

let preface subber (v,x) e = subber [(v,x)] e

let subst = preface subst

let subst_type = preface subst_type

let subst_kind = preface subst_kind

let subst_fresh pos (v,e) = subst_fresh pos [] (v,e)

let subst_type_fresh pos (v,e) = subst_type_fresh pos [] (v,e)

(* 
  Local Variables:
  compile-command: "make substitute.cmo "
  End:
 *)
