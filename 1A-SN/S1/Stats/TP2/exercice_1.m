donnees;

% Centrage des donnees :
x_G = mean(x_donnees_bruitees);
y_G = mean(y_donnees_bruitees);
x_donnees_bruitees_centrees = x_donnees_bruitees-x_G;
y_donnees_bruitees_centrees = y_donnees_bruitees-y_G;

% Tirages aleatoires de l'angle psi (loi uniforme) :
nb_tirages = 100;
psi_test = pi*(rand(1,nb_tirages)-0.5);
psi_estime = estimation_1(x_donnees_bruitees_centrees, ...
				y_donnees_bruitees_centrees,psi_test);
a_estime = tan(psi_estime);
b_estime = y_G-a_estime*x_G;

% Affichage de la droite de regression estimee par maximum de vraisemblance :
pas = 0.01;
x_droite_estimee = x_droite_reelle;
y_droite_estimee = y_droite_reelle;
if abs(a_estime)<1
	y_droite_estimee = a_estime*x_droite_estimee+b_estime;
else
	x_droite_estimee = (y_droite_estimee-b_estime)/a_estime;
end
plot(x_droite_estimee,y_droite_estimee,'b--','LineWidth',3);
axis(echelle);
legend(' Droite reelle', ...
	' Donnees bruitees', ...
	' D_{YX} estimee par MV', ...
	'Location','Best');

% Calcul et affichage de l'ecart angulaire :
theta_estime = psi_estime+pi/2;
EA = min(abs(theta_estime-theta_0),abs(theta_estime-theta_0+pi));
EA = min(EA,abs(theta_estime-theta_0-pi));
fprintf('D_YX estimee par maximum de vraisemblance : ecart angulaire = %.2f degres\n',EA/pi*180);
