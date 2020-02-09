%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_PAROUV UL_PARFER
%token UL_PT UL_VIRG
%token UL_DED
%token UL_FAIL
%token UL_EXCL
%token UL_NEG

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_SYMBOLE
%token <string> UL_VARIABLE

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> document

/* Le non terminal document est l'axiome */
%start document

%% /* Regles de productions */

document : regle suite_regle UL_FIN { (print_endline "programme : regle suite_regle FIN ") }

suite_regle : /* Lambda mot vide */ { (print_endline "suite_regle : mot vide ") }
            | regle suite_regle { (print_endline "suite_regle : regle suite_regle ") }

regle : predicat suite_predicat UL_PT { (print_endline "regle : predicat suite_predicat PT ") }

suite_predicat : /* Lambda mot vide */ { (print_endline "suite_predicat : mot vide ") }
              | UL_DED expression suite_expression { (print_endline "suite_predicat : DEDUCTION expression suite_expression ") }

expression : UL_FAIL { (print_endline "expression : FAIL ") }
            | UL_EXCL { (print_endline "expression : EXCL ") }
            | UL_NEG predicat { (print_endline "expression : NEG predicat") }
            | predicat { (print_endline "expression : predicat ") }

suite_expression : /* Lambda mot vide */ { (print_endline "suite_expression : mot vide ") }
                  | UL_VIRG expression suite_expression { (print_endline "suite_expression : VIRG expression suite_expression ") }

predicat : UL_SYMBOLE UL_PAROUV terme suite_terme UL_PARFER { (print_endline "predicat : SYMBOLE PAR_OUVR terme suite_term PAR_FERM") }

terme : UL_VARIABLE { (print_endline "terme : VARIABLE ") }
      | UL_SYMBOLE o { (print_endline "terme : SYMBOLE o ") }

suite_terme :  /* Lambda mot vide */ { (print_endline "suite_terme : mot vide ") }
            | UL_VIRG terme suite_terme { (print_endline "suite_terme : VIRG terme suite_terme ") }

o :  /* Lambda mot vide */ { (print_endline "o : mot vide ") }
    | UL_PAROUV terme suite_terme UL_PARFER { (print_endline "o : PAR_OUVR terme suite_terme PAR_FERM ") }





%%
