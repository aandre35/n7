exercice_3;

% Resolution du systeme lineaire CY = 0 :
xy_donnees_bruitees_centrees = [x_donnees_bruitees_centrees y_donnees_bruitees_centrees];
[cos_theta_estime,sin_theta_estime] = estimation_4(xy_donnees_bruitees_centrees);
rho_estime = x_G*cos_theta_estime+y_G*sin_theta_estime;

% Affichage de la droite de regression estimee par resolution du systeme lineaire CY = 0 :
x_droite_estimee = x_droite_reelle;
y_droite_estimee = y_droite_reelle;
if abs(sin_theta_estime)>abs(cos_theta_estime)
	y_droite_estimee = (rho_estime-x_droite_estimee*cos_theta_estime)/sin_theta_estime;
else
	x_droite_estimee = (rho_estime-y_droite_estimee*sin_theta_estime)/cos_theta_estime;
end
plot(x_droite_estimee,y_droite_estimee,'g--','LineWidth',3);
legend(' Droite reelle', ...
	' Donnees bruitees', ...
	' D_{perp} estimee par MV', ...
	' D_{perp} estimee par resolution de CY = O', ...
	'Location','Best');

% Calcul et affichage de l'ecart angulaire :
theta_estime = atan(sin_theta_estime/cos_theta_estime);
EA = min(abs(theta_estime-theta_0),abs(theta_estime-theta_0+pi));
EA = min(EA,abs(theta_estime-theta_0-pi));
fprintf('D_perp estimee par resolution d''un systeme lineaire : ecart angulaire = %.2f degres\n',EA/pi*180);
