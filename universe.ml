(** A naive algorithm for checking consistency of a universe context.

    We set the i-th universe level variable to [100 * i], evaluate, and see
    whether the resulting equalities of natural numbers are true.  That amounts to
    taking the admissible set [A] in the paper to be the singleton set
    [A = {(0,100,200,...)}].

    We also implement the equivalence relation on universe levels given by 
    agreement on the set [A].

    Finally, we provide equality testing on universe levels, which is simply
    structural equality, not even normalized.

*)

open Typesystem

exception Inconsistency of ts_expr * ts_expr

let rec memi' i x = function
    [] -> raise Error.Internal
  | a::l -> if a = x then i else memi' (i+1) x l

let memi x = memi' 0 x

let chk uv ((lhs:ts_expr),(rhs:ts_expr)) =
  let index name = memi name uv in
  let rec ev e = 
    let (pos,e0) = e 
    in match e0 with
    | Variable u -> index u
    | APPLY(U U_next,[ATOMIC u]) -> (ev u) + 1
    | APPLY(U U_max,[ATOMIC u;ATOMIC v]) -> max (ev u) (ev v)
    | _ -> raise Error.Internal
  in let chk lhs rhs = if (ev lhs) = (ev rhs) then raise (Inconsistency (lhs, rhs)) in
  chk lhs rhs

let get_uvars =
  let rec get_uvars accu = function
  | [] -> List.rev accu
  | (u,t) :: rest -> if t = uexp then get_uvars (u :: accu) rest else get_uvars accu rest
  in get_uvars []

let get_ueqns =
  let rec get_ueqns accu = function
  | (_, (pos,F_APPLY(F_ulevel_equality,[ATOMIC u; ATOMIC u']))) :: rest -> get_ueqns ((u,u') :: accu) rest
  | _ :: rest -> get_ueqns accu rest 
  | [] -> List.rev accu
  in get_ueqns []

let chk_var_ueqns uv eqns = List.iter (chk uv) eqns

let consistency env  = List.iter (chk (get_uvars env)) (get_ueqns env)

let chk_ueqns ueqns = chk_var_ueqns (get_uvars !global_context) ueqns

let ubind uvars ueqns =
  global_context := List.rev_append (List.map (fun u -> ((Var u), uexp)) uvars) !global_context;
  global_context := List.rev_append (List.map (fun (u,v) -> (newfresh (Var "ueq"), ulevel_equality (ATOMIC u) (ATOMIC v))) ueqns) !global_context;
  chk_ueqns ueqns

module Equal = struct
  let term_equiv ulevel_context = 			(* structural equality *)
    let rec ueq a b = match (a,b) with
    | ATOMIC(_,a), ATOMIC(_,b) -> (
	a == b || 
	match (a,b) with 
	| Variable x, Variable x' -> x = x'
	| APPLY(U U_next, [x ]),
	  APPLY(U U_next, [x']) -> ueq x x'
	| APPLY(U U_max, [x;y]), 
	  APPLY(U U_max, [x';y']) -> ueq x x' && ueq y y'
	| _ -> false)
    | _ -> false
    in ueq
end

module EquivA = struct
  let term_equiv ulevel_context lhs rhs = 		(* naive *)
    try
      (* not implemented *)
      true
    with
      Inconsistency _ -> false
end

module type Equivalence = sig
  val term_equiv : uContext -> lf_expr -> lf_expr -> bool
end
