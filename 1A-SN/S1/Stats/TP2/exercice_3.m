donnees;

% Centrage des donnees :
x_G = mean(x_donnees_bruitees);
y_G = mean(y_donnees_bruitees);
x_donnees_bruitees_centrees = x_donnees_bruitees-x_G;
y_donnees_bruitees_centrees = y_donnees_bruitees-y_G;

% Tirages aleatoires de l'angle theta (loi uniforme) :
nb_tirages = 100;
theta_test = pi*rand(1,nb_tirages);
theta_estime = estimation_3(x_donnees_bruitees_centrees,y_donnees_bruitees_centrees,theta_test);
rho_estime = x_G*cos(theta_estime)+y_G*sin(theta_estime);

% Affichage de la droite de regression estimee par maximum de vraisemblance :
pas = 0.01;
x_droite_estimee = x_droite_reelle;
y_droite_estimee = y_droite_reelle;
if abs(pi/2-theta_estime)<pi/4
	y_droite_estimee = (rho_estime-x_droite_estimee*cos(theta_estime))/sin(theta_estime);
else
	x_droite_estimee = (rho_estime-y_droite_estimee*sin(theta_estime))/cos(theta_estime);
end
plot(x_droite_estimee,y_droite_estimee,'b--','LineWidth',3);
axis(echelle);
legend(' Droite reelle', ...
	' Donnees bruitees', ...
	' D_{perp} estimee par MV', ...
	'Location','Best');

% Calcul et affichage de l'ecart angulaire :
EA = min(abs(theta_estime-theta_0),abs(theta_estime-theta_0+pi));
EA = min(EA,abs(theta_estime-theta_0-pi));
fprintf('D_perp estimee par maximum de vraisemblance : ecart angulaire = %.2f degres\n',EA/pi*180);
