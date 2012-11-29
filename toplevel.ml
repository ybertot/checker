(** Declaration of toplevel commands. *)

open Typesystem
type command' = 
  | Print of lf_expr
  | F_Print of lf_type
  | Rule of int * string * lf_type
  | Check of ts_expr
  | UVariable of string list * (ts_expr * ts_expr) list
  | Variable of string list
  | Alpha of ts_expr * ts_expr
  | Axiom of string * ts_expr
  | Type of ts_expr
  | Definition of (string * int * lf_expr * lf_type) list
  | CheckUniverses
  | Show
  | End

type command = Error.position * command'
