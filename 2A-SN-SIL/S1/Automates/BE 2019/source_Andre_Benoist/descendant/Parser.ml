open Tokens

(* Type du résultat d'une analyse syntaxique *)
type parseResult =
  | Success of inputStream
  | Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let accept expected stream =
  match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

(* acceptSymbole : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien une symbole *)
(* et avance dans l'analyse si c'est le cas *)
let acceptSymbole stream =
  match (peekAtFirstToken stream) with
    | (UL_SYMBOLE _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;

(* acceptVariable: inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien une variable *)
(* et avance dans l'analyse si c'est le cas *)
let acceptVariable stream =
  match (peekAtFirstToken stream) with
    | (UL_VARIABLE _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;

(* Définition de la monade  qui est composée de : *)
(* - le type de donnée monadique : parseResult  *)
(* - la fonction : inject qui construit ce type à partir d'une liste de terminaux *)
(* - la fonction : bind (opérateur >>=) qui combine les fonctions d'analyse. *)

(* inject inputStream -> parseResult *)
(* Construit le type de la monade à partir d'une liste de terminaux *)
let inject s = Success s;;

(* bind : 'a m -> ('a -> 'b m) -> 'b m *)
(* bind (opérateur >>=) qui combine les fonctions d'analyse. *)
(* ici on utilise une version spécialisée de bind :
   'b  ->  inputStream
   'a  ->  inputStream
    m  ->  parseResult
*)
(* >>= : parseResult -> (inputStream -> parseResult) -> parseResult *)
let (>>=) result f =
  match result with
    | Success next -> f next
    | Failure -> Failure
;;


(* parseProgramme : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parseProgramme stream =
  (print_string "Programme -> ");
  (match (peekAtFirstToken stream) with
    | (UL_SYMBOLE _)-> 
      (print_endline "{PR}" );
      (inject stream >>= 
      parseRegle >>=
      parseSuiteRegle)
    | _ -> Failure)

and parseSuiteRegle stream =
  (print_string "SuiteRegle -> ");
  (match (peekAtFirstToken stream) with
    | UL_FIN -> (print_endline "{SR}" );
    inject stream
    | (UL_SYMBOLE _) -> (print_endline "{SR}" );
    (inject stream >>=
    parseRegle >>=
    parseSuiteRegle)
    | _ -> Failure)

and parseRegle stream =
  (print_string "SuitePredicat -> ");
  (match (peekAtFirstToken stream) with
    | (UL_SYMBOLE _) -> (print_endline "{R}" );
    (inject stream >>=
    parsePredicat >>=
    parseSuitePredicat >>=
    accept UL_PT)
    | _ -> Failure)


and parseSuitePredicat stream = 
  (print_string "SuitePredicat -> ");
  (match (peekAtFirstToken stream) with
    | UL_PT-> (print_endline "{SP}" );
    inject stream
    | UL_DED -> (print_endline "{SP}" );
    ( inject stream >>=
    accept UL_DED >>=
    parseExpression >>=
    parseSuiteExpression)
    | _ -> Failure)

and parseExpression stream = 
  (print_string "SuitePredicat -> ");
  (match (peekAtFirstToken stream) with
    | UL_ECHEC -> (print_endline "{E}" );
    (inject stream >>=
    accept UL_ECHEC)
    | UL_EXCL -> (print_endline "{E}" );
    (inject stream >>=
    accept UL_EXCL)
    | UL_NEG -> (print_endline "{E}" );
    (inject stream >>=
    accept UL_NEG >>=
    parsePredicat)
    | (UL_SYMBOLE _) -> (print_endline "{E}" );
    (inject stream >>=
    parsePredicat)
    | _ -> Failure)

and parseSuiteExpression stream = 
  (print_string "SuiteExpression -> ");
  (match (peekAtFirstToken stream) with
    | UL_PT-> (print_endline "{SE}" );
    inject stream
    | UL_VIRG -> (print_endline "{SE}" );
    ( inject stream >>=
    accept UL_VIRG >>=
    parseExpression >>=
    parseSuiteExpression)
    | _ -> Failure)

and parsePredicat stream = 
  (print_string "Predicat -> ");
  (match (peekAtFirstToken stream) with
    | (UL_SYMBOLE _)-> (print_endline "{P}" );
    (inject stream >>=
    acceptSymbole >>=
    accept UL_PAROUV >>=
    parseTerme >>=
    parseSuiteTerme >>=
    accept UL_PARFER)
    | _ -> Failure)

and parseTerme stream = 
  (print_string "SuTerme-> ");
  (match (peekAtFirstToken stream) with
    | (UL_VARIABLE _)-> (print_endline "{T}" );
    (inject stream >>=
    acceptVariable)
    | (UL_SYMBOLE _)-> (print_endline "{T}" );
    ( inject stream >>=
    acceptSymbole >>=
    parseO)
    | _ -> Failure)

and parseSuiteTerme stream = 
  (print_string "SuiteTerme -> ");
  (match (peekAtFirstToken stream) with
    | UL_PARFER-> (print_endline "{ST}" );
    inject stream
    | UL_VIRG -> (print_endline "{ST}" );
    ( inject stream >>=
    accept UL_VIRG >>=
    parseTerme >>=
    parseSuiteTerme)
    | _ -> Failure)

and parseO stream = 
  (print_string "O -> ");
  (match (peekAtFirstToken stream) with
    | UL_PT | UL_VIRG | UL_PARFER-> (print_endline "{O}" );
    inject stream
    | UL_PAROUV -> (print_endline "{O}" );
    ( inject stream >>=
    accept UL_PAROUV >>=
    parseTerme >>=
    parseSuiteTerme >>=
    accept UL_PARFER)
    | _ -> Failure)
;;
