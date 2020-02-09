with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Alea;

--------------------------------------------------------------------------------
--  Auteur   : ADRIEN ANDRE
--  Objectif : Jouer au jeu des allumetes contre la machine
--------------------------------------------------------------------------------

--R1 : Comment jouer au jeu des 13 allumettes contre la machine?
procedure Allumettes is
	procedure choix_niveau (Niveau: in out character) is
----R2: Comment choisir un niveau de l'ordinateur?
	
	begin 
		Put_line("Saisir un niveau: naif(n), distrait(d), rapide (r) ou expert (e)") ;
		Get(Niveau); 
----------------R3: Comment vérifier que le niveau est valide?
		case Niveau is 
			when 'n'|'N' => Put_line("Mon niveau est naif");
			when 'd'|'D' => Put_line("Mon niveau est distrait") ; 
			when 'r'|'R' => Put_line("Mon niveau est rapide") ;
			when 'e'|'E' => Put_line("Mon niveau est expert") ;
			when others => Put_line("Mon niveau est expert")  ;
					Niveau:='e'; 
		end case ; 
	end choix_niveau; 

----R2: Comment choisir si l'on commence à jouer? string;
	procedure choix_commencer (joueur: out character) is
        Choix: character:='o';
        v:character:='n';
	begin
		while v='n' loop
			Put("Souhaitez-vous commencer ? (o/n)") ;
			Get(Choix); 
----------------R3: Comment vérifier que le choix est valide?
			if Choix = 'o' or Choix = 'O' 
				then Put_line("Vous avez choisi de commencer") ;
				v:='o' ;
				joueur:= 'h' ;
			elsif Choix = 'n' or Choix = 'N'
				then Put_line("Vous avez choisi de ne pas commencer") ;
				v:='o';
				joueur:= 'o' ;
			end if;
			if v= 'n'
				then Put_line("Veuillez saisir un choix correct svp") ;
			end if ;
		end loop ;
	end choix_commencer;


----R2: Comment effectuer le déroulement du jeu?
	
	procedure deroulement(joueur: in out character; nombre_allumettes : in out integer; Niveau: in character) is	
		y: integer := 3;
		v: character ;
		temp1 : integer:=2;
		temp2 :integer:=2;
		nombre: integer;
		package Mon_Alea is
			new Alea (1, y);
		use Mon_alea;
		Entier_choisi: integer:=1;
--On crée une fonction minimumu
function min(a: Integer ; b : Integer) return integer is
			minimum: integer;
		begin
			if a<=b
				then minimum:=a;
				else minimum:=b;
			end if;
			return minimum;
		end min;
	begin
		while nombre_allumettes > 0 loop
			Case joueur is
				when 'h' => 
					v:='n';
					while v='n' loop
						Put("Choisir un entier entre 1 et " & integer'image(min(3,nombre_allumettes))) ;
                	                        New_line;
						Get(Entier_choisi) ;
						New_line;
------------------------R3: Comment vérifier que le nombre est valide?
						if Entier_choisi <= min(3 , nombre_allumettes) and Entier_choisi >= 0 
							then nombre_allumettes := nombre_allumettes - Entier_choisi ;
							joueur:= 'o';
							v:='o';
							New_line;
							else Put_line("Veuillez saisir un nombre correct svp") ;
							New_line;
						end if;
					end loop ;
				when others =>
					if Niveau = 'n' or Niveau = 'N'
						then y:= min(3,nombre_allumettes);
						Get_Random_Number (nombre) ;
						nombre_allumettes:= nombre_allumettes - nombre;
						New_line;
						Put("j'ai tiré "& integer'image(nombre) & " Allumettes");
						New_line;
						joueur:='h';
					elsif Niveau = 'd' or Niveau = 'D'
						then y:= 3 ;
						Get_Random_Number (nombre) ;
						nombre_allumettes:= nombre_allumettes - nombre;
						New_line;
						Put("j'ai tiré "& integer'image(nombre) & " Allumettes");
						New_line;
						joueur:='h';
					elsif Niveau = 'r' or Niveau = 'R'
						then  temp1:=min(3, nombre_allumettes);
						nombre_allumettes := nombre_allumettes - min(3, nombre_allumettes) ;
						New_line;						
						Put("j'ai tiré "& integer'image(temp1) & " Allumettes");
						New_line;
						joueur:='h';
					elsif Niveau = 'e' or Niveau = 'E'
						then temp2 := nombre_allumettes mod 4 ;
						if (nombre_allumettes- 1) mod 4 =1 then 
							temp2 := 1;
						elsif (nombre_allumettes- 2) mod 4 = 1 
							then temp2 := 2;
						elsif (nombre_allumettes- 3) mod 4 = 1 then
							temp2 := 3;
						else
							temp2 :=1;
						end if;
						nombre_allumettes := nombre_allumettes - temp2;
						New_line;						
						Put("j'ai tiré "& integer'image(temp2) & " Allumettes");
						New_line;
						joueur:='h';
					end if;
			end case;
----------------R3: Comment afficher le nombre d'allumettes restantes?		

		Put("Il reste "& integer'image(nombre_allumettes) & " Allumettes");
		New_line;
		--On modélise les allumettes avec des barres	
			for i in 1..4 loop
				for j in 1..nombre_allumettes loop
					Put("|  ");
				end loop;
				New_line;			
			end loop;
		end loop;
	end deroulement ;

----R2: Comment afficher le vainqueur?

	procedure afficher_vainqueur(joueur: in character) is
	begin 
		if joueur='h'
			then Put("Le vainqueur est l'ordinateur :(");
			else Put("Vous avez gagné!!!");
		end if;
	end afficher_vainqueur;

	joueur: character:= 'o';
	Niveau: character :='n';
	nombre_allumettes: Integer:= 13;
begin
	choix_niveau(Niveau);
	choix_commencer(joueur);
	deroulement(joueur, nombre_allumettes , Niveau);
	afficher_vainqueur(joueur);
end Allumettes;
