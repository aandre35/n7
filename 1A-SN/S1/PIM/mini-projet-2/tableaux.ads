generic
    Capacite : Integer;   -- Nombre maximal d'éléments qu'un tableau peut contenir
    type T_Element is private;  -- Type des éléments du tableau

package Tableaux is

    type T_Tableau is limited private; --// "très privé" en Algorithmique !
        --// Sur un type privé, on a droit à l'affectation (:=) et l'égalité (=).
        --// On perd ces opérations avec un type "limited private" (très privé).

    -- Initilaiser le tableau.  Le tableau est vide.
    procedure Initialiser (Tableau : out T_Tableau) with
            Post => Taille (Tableau) = 0;

    --SP2 : Obtenir la taille, le nombre d'élèments du tableau.
    function Taille (Tableau : in T_Tableau) return integer with
	    Post => (Taille'result >= 0 and Taille'result <= Capacite) ;

    --SP3 : Obtenir l'élèment à un indice valide du tableau.
    function Obtenir_Element (Tableau : in out T_Tableau; indice : in integer) return T_Element ;--with
    --Pre => 1 <= indice and indice <= Taille(Tableau);

    --SP4: Modifier l'élèment à un indice donné du tableau.
    Procedure Modifier_Element (Tableau : in out T_Tableau; indice : in integer; nouvelle_valeur : in T_Element) with
	    Pre => 1 <= indice and indice <= Taille(Tableau),
	    Post => Obtenir_Element(Tableau, Indice) = nouvelle_valeur;

    --SP5: Ajouter un élèment à la fin du tableau.
    Procedure Ajouter_Element (Tableau : in out T_Tableau; valeur_a_ajouter : in T_Element) with
            Post => Obtenir_Element(Tableau, Taille(Tableau)) = valeur_a_ajouter ;--and Taille(Tableau) = Taille (Tableau)'old + 1;

    --SP6: Savoir si un élèment est présent dans un tableau.
    function Est_Present (Tableau : in out T_Tableau; element  : in T_Element) return boolean;


    --SP7: Insérer un élèment à un indice donné.
    Procedure Inserer_Element (Tableau : in out T_Tableau; indice : in integer ; element : in T_Element) with
            Post => Taille(Tableau) = Taille(Tableau)'old + 1 ;--and Est_Present(Tableau, element);

    --SP8: Supprimer un élèment à un indice valide donné dans un tableau.
    Procedure Supprimer_Element (Tableau : in out T_Tableau; indice : in integer) with
            Pre => (1 <= indice and indice <= Taille(Tableau)),
            Post => Taille(Tableau) = Taille(Tableau)'old - 1 ;

    --SP9: Supprimer toutes les occurences d'un élèment dans un tableau.
    Procedure Supprimer_Occurences (Tableau : in out T_Tableau; element : in T_Element) with
            Post => Taille(Tableau) <= Taille(Tableau)'old;


    --SP10: Appliquer une opération sur chaque élèment du tableau
    generic
            with function Operation_Sur_Un_Element (Un_Element: in T_Element) return T_Element;
    procedure Operation_Sur_Chaque (Tableau : in out T_Tableau);




private

    type T_Tab_Elements is array (1..Capacite) of T_Element;

    type T_Tableau is
        record
            Elements : T_Tab_Elements;  -- les éléments du tableau
            Taille: Integer;        -- Nombre d'éléments dans le tableau
        end record;

end Tableaux;
