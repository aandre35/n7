donnees;
% Centrage des donnees :
x_G = mean(x_donnees_bruitees);
y_G = mean(y_donnees_bruitees);
x_donnees_bruitees_centrees = x_donnees_bruitees-x_G;
y_donnees_bruitees_centrees = y_donnees_bruitees-y_G;
% Resolution du systeme lineaire AX = B :
[a_estime,b_estime] = estimation_2(x_donnees_bruitees,y_donnees_bruitees);

% Affichage de la droite de regression estimee par resolution d'un systeme lineaire :
x_droite_estimee = x_droite_reelle;
y_droite_estimee = y_droite_reelle;
if abs(a_estime)<1
	y_droite_estimee = a_estime*x_droite_estimee+b_estime;
else
	x_droite_estimee = (y_droite_estimee-b_estime)/a_estime;
end
plot(x_droite_estimee,y_droite_estimee,'g--','LineWidth',3);
legend(' Droite reelle', ...
	' Donnees bruitees', ...
	' D_{YX} estimee par MV', ...
	' D_{YX} estimee par resolution de AX = B', ...
	'Location','Best');

% Calcul et affichage de l'ecart angulaire :
theta_estime = atan(a_estime)+pi/2;
EA = min(abs(theta_estime-theta_0),abs(theta_estime-theta_0+pi));
EA = min(EA,abs(theta_estime-theta_0-pi));
fprintf('D_YX estimee par resolution d''un systeme lineaire : ecart angulaire = %.2f degres\n',EA/pi*180);

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
	' D_{YX} estimee par resolution de AX = B', ...
	' D_{perp} estimee par resolution de CY = O', ...
	'Location','Best');

% Calcul et affichage de l'ecart angulaire :
theta_estime = atan(sin_theta_estime/cos_theta_estime);
EA = min(abs(theta_estime-theta_0),abs(theta_estime-theta_0+pi));
EA = min(EA,abs(theta_estime-theta_0-pi));
fprintf('D_perp estimee par resolution d''un systeme lineaire : ecart angulaire = %.2f degres\n',EA/pi*180);
