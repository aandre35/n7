donnees;

% Tirage aleatoire uniforme de C :
nb_tirages = 1000;
C_test = (taille-R_0)*(2*rand(nb_tirages,2)-1);
C_estime = estimation_1(x_donnees_bruitees,y_donnees_bruitees,C_test,R_0);

% Affichage du cercle estime :
x_cercle_estime = C_estime(1)*ones(nb_points_cercle,1) + ...
                  R_0*cos(theta_cercle);
y_cercle_estime = C_estime(2)*ones(nb_points_cercle,1) + ...
                  R_0*sin(theta_cercle);
plot(x_cercle_estime([1:end 1]),y_cercle_estime([1:end 1]),'b--','LineWidth',3);
legend(' Cercle reel', ...
	' Donnees bruitees', ...
	' Cercle estime', ...
	'Location','Best');
