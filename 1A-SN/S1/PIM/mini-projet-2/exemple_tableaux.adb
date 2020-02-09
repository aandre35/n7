with Tableaux;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with Ada.Characters.Latin_1;  -- des constantes comme Apostrophe (Latin1 ?!?!)
use Ada.Characters.Latin_1;

-- Programme de test du module Tableau.
procedure Utiliser_Tableaux is


    -- Utiliser le tableau pour en montrer les possibilités sur un exemples.
    --// Attention, même si on utiliser « pragma Assert », on ne peut pas
    --// vraiment considérer cette procédure comme un programme de tests.
    --// Il est souhaitables que chaque programmes de test soit court,
    --// indépendant des autres et teste un aspect.
    procedure Utiliser_Tableau_Entier is

        Max : integer := 3;
        package Tableau_Integer is
                new Tableaux (Capacite => Max, T_Element => Integer);
        use Tableau_Integer;


        Tableau : T_Tableau;
    begin
        Put_Line ("Tester_Tableau_Entier");
        -- initilaiser la Tableau
        Initialiser (Tableau);
        pragma Assert (Taille (Tableau) = 0);

        -- empiler un premier élément
        Ajouter_Element (Tableau, 1);
        pragma Assert (Taille (Tableau) /= 0);
        pragma Assert (Taille (Tableau) /= Max);
        pragma Assert (1 = Obtenir_Element (Tableau, Taille(Tableau)));

        -- remplir le Tableau
        Ajouter_Element (Tableau, 2);
        pragma Assert (2 = Obtenir_Element (Tableau, Taille(Tableau)));
        Ajouter_Element (Tableau, 3);
        pragma Assert (3 = Obtenir_Element (Tableau, Taille(Tableau)));
        pragma Assert (Taille (Tableau) /= 0);
        pragma Assert (Taille (Tableau) = Max);

        -- supprimer un éléments
        Supprimer_Element (Tableau , Taille(Tableau));
        pragma Assert (Taille (Tableau) /= Max);
        pragma Assert (2 = Obtenir_Element (Tableau, Taille(Tableau)));

        -- ajouter un élément
        Ajouter_Element (Tableau, 4);
        pragma Assert (4 = Obtenir_Element (Tableau, Taille(Tableau)));
        pragma Assert (Taille (Tableau) = Max);

        -- vider la Tableau
        Supprimer_Element (Tableau , Taille(Tableau));
        pragma Assert (Taille (Tableau) /= 0);
        pragma Assert (2 = Obtenir_Element (Tableau, Taille(Tableau)));
        Supprimer_Element (Tableau , Taille(Tableau));
        pragma Assert (Taille (Tableau) /= 0);
        pragma Assert (1 = Obtenir_Element (Tableau, Taille(Tableau)));
        Supprimer_Element (Tableau , Taille(Tableau));
        pragma Assert (Taille (Tableau) = 0);

    end Utiliser_Tableau_Entier;



    procedure Utiliser_Tableau_Caractere is

        Max: constant := 4;
        -- Capacite du Tableau de test.
        Capacite : constant Integer := Max;

        package Tableau_Caractere is
            new Tableaux(Capacite, character);
        use Tableau_Caractere;



        Tab1 : T_Tableau;
    begin
        Put_Line ("Tester_Tableau_Caractère");
        -- initilaiser la Tableau
        Initialiser (Tab1);
        pragma Assert (Taille (Tab1) = 0);

        -- remplir la Tableau
        for I in 1..Capacite loop
            Ajouter_Element (Tab1, 'A');
        end loop;
        pragma Assert (Taille (Tab1) = Capacite);

        -- vider le Tableau
        for I in reverse 1..Max loop
            pragma Assert ('A' = Obtenir_Element(Tab1, I));
            Supprimer_Element (Tab1, Taille(Tab1));
        end loop;
        pragma Assert (Taille (Tab1) = 0);
    end Utiliser_Tableau_Caractere;


begin
    Utiliser_Tableau_Entier;
    Utiliser_Tableau_Caractere;
end Utiliser_Tableaux;
