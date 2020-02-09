function  theta_estime = estimation_3(x_donnees_bruitees_centrees,y_donnees_bruitees_centrees,theta_test);

nb_tirages= length(theta_test);
argument= zeros(nb_tirages, 1);
for k=1:nb_tirages
    eps= (x_donnees_bruitees_centrees * cos(theta_test(k)) + y_donnees_bruitees_centrees * sin(theta_test(k))).^2;
    argument(k) = sum (eps);
end
[arg_min, i] = min (argument);
theta_estime = theta_test(i);
end
