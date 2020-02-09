function [a_estime,b_estime] = estimation_2(x_donnees_bruitees,y_donnees_bruitees);

nb_donnees = length(x_donnees_bruitees);
A= [x_donnees_bruitees ones(nb_donnees, 1)];
B= y_donnees_bruitees;
X= A\B;
a_estime = X(1);
b_estime = X(2);

end

