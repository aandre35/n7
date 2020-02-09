function [E,contour] = recursion(E,contour,i_germe,j_germe,voisins,G_x_n,G_y_n,card_max,cos_alpha)
% Fonction recursive permettant de construire un ensemble candidat E

G_x_n_germe = G_x_n(i_germe,j_germe);
G_y_n_germe = G_y_n(i_germe,j_germe);
nb_voisins = size(voisins,1);
k = 1;
s=0;
while k<=nb_voisins & size(E,1)<=card_max
	i_voisin = i_germe+voisins(k,1);
	j_voisin = j_germe+voisins(k,2);
    G_x_n_voisin = G_x_n(i_voisin,j_voisin);
    G_y_n_voisin = G_y_n(i_voisin,j_voisin);
	if contour(i_voisin,j_voisin)
        s =sqrt(G_x_n_germe* G_x_n_voisin + G_y_n_germe* G_y_n_voisin); 
        if s > cos_alpha
            contour(i_voisin, j_voisin) = 0;
            E = [E; i_voisin j_voisin];
            [E,contour] =recursion(E,contour,i_voisin,j_voisin,voisins,G_x_n,G_y_n,card_max,cos_alpha);
        end
		% Dans cette boucle, il vous faut :
		% - Calculer le produit scalaire entre le gradient du germe et le gradient du voisin
		% - Si ce produit scalaire est superieur a cos_alpha :
		%	+ Mettre a jour "contour"
		%	+ Mettre a jour "E" par concatenation
		%	+ Lancer l'appel recursif sur le voisin eligible

	end
	k = k+1;
end
