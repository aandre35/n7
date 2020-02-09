with Tableaux;

procedure Test_Tableaux is
    
    package Tableau_Integer is
        new Tableaux (Capacite => 10, T_Element => Integer);
    use Tableau_Integer;


    -- test SP1 : Initialiser un tableau noté Tab1 : [4, 3, 1, 3, 5]
    procedure Initialiser_Tab1 (Tableau : out T_Tableau) is
    begin
        Initialiser (Tableau);
	Ajouter_Element (Tableau, 4);
	Ajouter_Element (Tableau, 3);
	Ajouter_Element (Tableau, 1);
	Ajouter_Element (Tableau, 3);
	Ajouter_Element (Tableau, 5);
    end Initialiser_Tab1;


    --test SP2: Obtenir la taille, le nombre d'élèments du tableau.
    procedure Tester_Taille is
        Tableau1 : T_Tableau;
    begin
	Initialiser_Tab1 (Tableau1);
        pragma Assert (Taille (Tableau1) = 5);
    end Tester_Taille;


    --test SP3 : Obtenir l'élèment à un indice valide du tableau.
    procedure Tester_Obtenir_Element is
	Tableau1 , Tableau2 : T_Tableau;
    begin 
	Initialiser_Tab1 (Tableau1);
	pragma Assert (Obtenir_Element (Tableau1, 1) = 4);
	pragma Assert (Obtenir_Element (Tableau1, 4) = 3);
	pragma Assert (Obtenir_Element (Tableau1, 2) = Obtenir_Element (Tableau1, 4) );
	Initialiser_Tab1 (Tableau2);
	for i in 1..5 loop
	     pragma Assert (Obtenir_Element (Tableau1, i) = Obtenir_Element (Tableau2, i) );
	end loop;
    end Tester_Obtenir_Element;


    --test SP4: Modifier l'élèment à un indice donné du tableau.
    procedure Tester_Modifier is
	Tableau1 : T_Tableau;
    begin 
	Initialiser_Tab1 (Tableau1);
	Modifier_Element (tableau1, 2, -7);
	--pragma Assert (not Obtenir_Element (Tableau1, 2) = 3);
	pragma Assert (Obtenir_Element (Tableau1, 2) = -7);
    end Tester_Modifier;
	

    --test SP5 : Ajouter un élèment à la fin du tableau
    procedure Tester_Ajouter is
    Tableau1 : T_Tableau;
    begin
	Initialiser_Tab1 (Tableau1);
	Ajouter_Element (Tableau1, 1);
	pragma Assert (Taille (Tableau1) = 6);
        pragma Assert (Obtenir_Element (Tableau1 , 6) = 1);
    end Tester_Ajouter;


    --test SP6
    procedure Tester_Est_Present is
    Tableau1 : T_Tableau;
    begin
	Initialiser_Tab1 (Tableau1);
        pragma Assert (Est_Present (Tableau1, 3));
        pragma Assert (not Est_Present(Tableau1, 11));
        Ajouter_Element (Tableau1, 3);
        pragma Assert (Est_Present (Tableau1, 3));
    end Tester_Est_Present;


    --test SP7: Insérer un élèment à un indice donné.
    procedure Tester_Inserer is
    Tableau1 : T_Tableau;
    begin
	Initialiser_Tab1 (Tableau1);
        Inserer_Element (Tableau1, 2, 9);
	pragma Assert (Obtenir_Element(Tableau1, 2) = 9);
    end Tester_Inserer;


    --test SP8: Supprimer un élèment à un indice valide donné dans un tableau.
    procedure Tester_Supprimer is
    Tableau1 : T_Tableau;
    begin
	Initialiser_Tab1 (Tableau1);
        Supprimer_Element (Tableau1, 2);
	pragma Assert (Taille (Tableau1) = 4);
	pragma Assert (Obtenir_Element(Tableau1, 2) = 1);
    end Tester_Supprimer;

    --test SP9: Supprimer toutes les occurences d'un élèment dans un tableau.
    procedure Tester_Supprimer_Occurences is
	Tableau1 : T_Tableau;
    begin
	Initialiser_Tab1 (Tableau1);
	pragma Assert (Obtenir_Element(Tableau1, 2) = 3);
	Supprimer_Occurences (Tableau1, 3); 
	for i in 1..Taille(Tableau1) loop
            pragma Assert (not Est_Present(Tableau1, 3));
        end loop;
    end Tester_Supprimer_Occurences;

    --test SP10: Appliquer une opération sur chaque élèment du tableau.
--    function mettre_au_carre (nombre: in integer) return integer is 
           -- new Operation_Sur_Un_Element ;
--    begin 
        -- return nombre*nombre;
--    end mettre_au_carre;
    
    
    function mettre_au_carre (element: in  integer) return integer is 
    begin
        return element*element;
    end mettre_au_carre;
    
    
    procedure Appliquer_mettre_au_carre is new 
            Operation_Sur_Chaque (mettre_au_carre);
    
    
    procedure Tester_Operation is
        Tableau1 : T_Tableau;
    begin 
        Initialiser_Tab1 (Tableau1);
        Appliquer_mettre_au_carre (Tableau1);
    end Tester_Operation;

    Tableau: T_Tableau;
begin
    Initialiser_Tab1(Tableau);
    Tester_Taille;
    Tester_Obtenir_Element;
    Tester_Modifier;
    Tester_Ajouter;
    Tester_Est_Present;
    Tester_Inserer;
    Tester_Supprimer;
    Tester_Supprimer_Occurences;
    Tester_Operation;

end Test_Tableaux;
