
(* The type of tokens. *)

type token = 
  | UL_VIRG
  | UL_VARIABLE of (string)
  | UL_SYMBOLE of (string)
  | UL_PT
  | UL_PAROUV
  | UL_PARFER
  | UL_NEG
  | UL_FIN
  | UL_FAIL
  | UL_EXCL
  | UL_DED

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val document: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit)
