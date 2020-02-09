-- Implantation du module tableaux.

with Ada.Text_IO;  use Ada.Text_IO;

package body Tableaux is

    procedure Initialiser (Tableau : out T_Tableau) is
    begin
        Tableau.Taille := 0;
    end initialiser;


    function Taille (Tableau : in T_Tableau) return integer is
    begin
        return Tableau.Taille;
    end Taille;


    function Obtenir_Element (Tableau : in out T_Tableau; indice : in integer) return T_element is
    begin
	return Tableau.Elements(indice);
    end Obtenir_Element;


    Procedure Modifier_Element (Tableau : in out T_Tableau; indice : in integer; nouvelle_valeur : in T_Element) is
    begin
	Tableau.Elements(indice) := nouvelle_valeur;
    end Modifier_Element;


    Procedure Ajouter_Element (Tableau : in out T_Tableau; valeur_a_ajouter : in T_Element) is
    begin
	Tableau.Taille := Tableau.Taille +1;
        Tableau.Elements(Tableau.Taille) := valeur_a_ajouter;
    end Ajouter_Element;


    function Est_Present (Tableau : in out T_Tableau; element : in T_Element) return boolean is
    begin
        for i in 1..Tableau.Taille loop
            if Tableau.Elements(i) = element then
                return true;
            end if;
        end loop;
        return false;
    end Est_Present;


    Procedure Inserer_Element (Tableau :in out T_Tableau; indice : in integer ; element : in T_Element) is
    begin
            Tableau.Taille := Tableau.Taille + 1;
        for i in  reverse indice..Tableau.Taille-1 loop
            Tableau.Elements(i+1) := Tableau.Elements(i);
        end loop;
        Modifier_Element(Tableau,  indice, element);
    end Inserer_Element;


    Procedure Supprimer_Element (Tableau : in out T_Tableau; indice : in integer) is
    begin
            for i in indice..(Tableau.Taille-1) loop
                Tableau.Elements(i) := Tableau.Elements(i+1);
            end loop;
            Tableau.Taille := Tableau.Taille -1;
    end Supprimer_Element;


    Procedure Supprimer_Occurences (Tableau : in out T_Tableau; element : in T_Element) is
    begin
	for i in 1..Tableau.Taille loop
	   if Tableau.Elements(i) = element then
		Supprimer_Element(Tableau, i);
	   end if;
	end loop;
    end Supprimer_Occurences;



    Procedure Operation_Sur_Chaque (Tableau : in out T_Tableau) is
    begin
        for i in 1..Tableau.Taille loop
	    Tableau.Elements(i) := Operation_Sur_Un_Element (Tableau.Elements(i));
	end loop;
    end Operation_Sur_Chaque;

end Tableaux;
