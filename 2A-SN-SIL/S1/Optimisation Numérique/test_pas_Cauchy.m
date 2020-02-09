%% Test de la fonction pas_Cauchy qui calcule le pas de Cauchy d'une fonction

% La quadratique est de la forme :
%   q(s) = s.'*grad(x) + 1/2*s.'*hess(x)*s;

% paramétre:
delta = 1;

%% Test sur les quadratiques de l'annexe B 
disp("Tests sur la quadratique 1:");
% Quadratique 1
g1 = [0; 0];
H1 = [7 0; 0 2];
pas = pas_Cauchy(g1, H1, delta);
disp("On obtient un pas de : ")
disp(pas)


% Quadratique 2
disp("#################################################")
disp("Tests sur la quadratique 2:");
g2 = [6; 2];
H2 = H1;
pas = pas_Cauchy(g2, H2, delta);
disp("On obtient un pas de : ")
disp(pas)

%Quadratique 3
disp("#################################################")
disp("Tests sur la quadratique 3:");
g3 = [-2; 1];
H3 = [-2 0; 0 10];
pas = pas_Cauchy(g3, H3, delta);
disp("On obtient un pas de : ")
disp(pas)
%% Tests OK