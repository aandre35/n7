function [C_estime, R_estime] =  estimation_2 (x_donnees_bruitees,y_donnees_bruitees,C_test,R_test)

nb_tirages = length(C_test);
argument = zeros(nb_tirages,1);
for k=1:nb_tirages
    delta_x = x_donnees_bruitees - C_test(k,1);
    delta_y = y_donnees_bruitees - C_test(k,2); 
    distance = sqrt(delta_x.^2 + delta_y.^2);
    erreur = (distance - R_test(k)).^2;
    argument(k) = sum(erreur);
end
[arg_min, i] = min (argument);
[C_estime] = [C_test(i,1); C_test(i,2)];
R_estime = R_test(i);
end
