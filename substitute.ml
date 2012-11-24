open Typesystem

let newfresh = 
  let genctr = ref 0 in 
  let newgen x = (
    incr genctr; 
    if !genctr < 0 then raise Error.GensymCounterOverflow;
    VarGen (!genctr, x)) in
  fun v -> match v with 
      Var x | VarGen(_,x) -> newgen x
    | VarUnused as v -> v

(** This version substitutes only for o-variables. *)
let rec substlist subs es = List.map (subst subs) es
and subst subs = function
  | LAMBDA((pos,v), body) -> 
      let w = newfresh v in
      let v' = POS(pos, Variable w) in
      let subs = (v,v') :: subs in 
      LAMBDA((pos,w), subst subs body)
  | POS(pos,e) as d -> match e with 
    | APPLY(label,args) -> POS(pos, APPLY(label,substlist subs args))
    | Variable v -> (try List.assoc v subs with Not_found -> d)
    | EmptyHole _ -> d  

