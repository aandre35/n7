function [cos_theta_estime,sin_theta_estime] = estimation_4(xy_donnees_bruitees_centrees)
C=xy_donnees_bruitees_centrees 
Y= transpose(C) * C;
[X, lambdas] = eig(Y); %vep, vap
V= diag(lambdas);
[valeur_propre_min, i]= min(V);
cos_theta_estime = X(1, i);
sin_theta_estime = X(2, i);
end
