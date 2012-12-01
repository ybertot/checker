open Typesystem
open Error

let rec get_ts_type (v:var') (env:context) : ts_expr = (
  match env with
  | (_, (pos, F_APPLY(F_hastype,[ATOMIC(_,Variable v'); ATOMIC t]))) :: env -> if v = v' then t else get_ts_type v env
  | _ :: env -> get_ts_type v env
  | [] -> raise Not_found
 )

let rec tau (pos:position) (env:context) (pos,e) : atomic_term = match e with
  | EmptyHole _ -> raise (TypingError(pos, "empty hole, type undetermined"))
  | Variable v -> (
      try get_ts_type v env
      with Not_found -> raise (TypingError(pos, "unbound variable, not in TS context: " ^ (vartostring' v))))
  | APPLY(h,args) -> with_pos pos (
      match h with
      | L v -> 
	  let _ = get_ts_type v in
	  raise NotImplemented
      | U uh -> raise Internal		(* u-expression doesn't have a type *)
      | T th -> raise Internal		(* t-expression doesn't have a type *)
      | O oh -> (
	      match oh with
	    | O_u -> (
		match args with 
		| [ATOMIC u] -> Helpers.make_TT_U (pos, (Helpers.make_UU U_next [ATOMIC u]))
		| _ -> raise Internal)
	    | O_j -> (
		match args with 
		| [ATOMIC m1;ATOMIC m2] -> Helpers.make_TT_Pi (with_pos_of m1 (Helpers.make_TT_U m1)) ((Nowhere,VarUnused), (with_pos_of m2 (Helpers.make_TT_U m2)))
		| _ -> raise Internal)
	    | O_ev -> (
		match args with 
		| [ATOMIC f;ATOMIC o;LAMBDA(x,ATOMIC t)] -> unmark (Substitute.subst (unmark x,ATOMIC o) t)
		| _ -> raise Internal)
	    | O_lambda -> (
		match args with 
		| [ATOMIC t;LAMBDA(x,ATOMIC o)] -> Helpers.make_TT_Pi t (x, tau pos (ts_bind (x,t) env) o)
		| _ -> raise Internal)
	    | O_forall -> (
		match args with 
		| ATOMIC u :: ATOMIC u' :: _ -> Helpers.make_TT_U (nowhere (Helpers.make_UU U_max [ATOMIC u; ATOMIC u']))
		| _ -> raise Internal)
	    | O_pair -> raise NotImplemented
	    | O_pr1 -> raise NotImplemented
	    | O_pr2 -> raise NotImplemented
	    | O_total -> raise NotImplemented
	    | O_pt -> raise NotImplemented
	    | O_pt_r -> raise NotImplemented
	    | O_tt -> Helpers.make_TT_Pt
	    | O_coprod -> raise NotImplemented
	    | O_ii1 -> raise NotImplemented
	    | O_ii2 -> raise NotImplemented
	    | O_sum -> raise NotImplemented
	    | O_empty -> raise NotImplemented
	    | O_empty_r -> raise NotImplemented
	    | O_c -> raise NotImplemented
	    | O_ip_r -> raise NotImplemented
	    | O_ip -> raise NotImplemented
	    | O_paths -> raise NotImplemented
	    | O_refl -> raise NotImplemented
	    | O_J -> raise NotImplemented
	    | O_rr0 -> raise NotImplemented
	    | O_rr1 -> raise NotImplemented
	 )
     )

let tau = tau Nowhere
