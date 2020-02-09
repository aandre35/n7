%% paramètres:
delta_k = 1;
eps = 10^(-6);
iter_max = 1000;

%% Test sur les quadratiques de l'Annexe C

% Quadratique 1
disp("Tests sur la quadratique 1:");
g1 = [0; 0];
H1 = [7 0; 0 2];
pas = grad_conjugue_tronque(delta_k, g1, H1, eps, iter_max);
disp("On obtient un pas de : ")
disp(pas)

% Quadratique 2
disp("Tests sur la quadratique 2:");
g2 = [6; 2];
H2 = H1;
pas = grad_conjugue_tronque(delta_k, g2, H2, eps, iter_max);
disp("On obtient un pas de : ")
disp(pas)

% Quadratique 3
disp("Tests sur la quadratique 3:");
g3 = [-2; 1];
H3 = [-2 0; 0 10];
pas = grad_conjugue_tronque(delta_k, g3, H3, eps, iter_max);
disp("On obtient un pas de : ")
disp(pas)

% Quadratique 4
disp("Tests sur la quadratique 4:");
g4 = [0; 0];
H4 = [-2 0; 0 10];
pas = grad_conjugue_tronque(delta_k, g4, H4, eps, iter_max);
disp("On obtient un pas de : ")
disp(pas)

%Quadratique 5
disp("Tests sur la quadratique 5:");
g5 = [2; 3];
H5 = [4 6; 6 5];
pas = grad_conjugue_tronque(delta_k, g5, H5, eps, iter_max);
disp("On obtient un pas de : ")
disp(pas)

%% Tests OK