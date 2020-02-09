function  psi_estime = estimation_1(x_donnees_bruitees_centrees, y_donnees_bruitees_centrees,psi_test)

nb_tirages= length(psi_test);
argument= zeros(nb_tirages, 1);
for k=1:nb_tirages
    eps= (y_donnees_bruitees_centrees - x_donnees_bruitees_centrees * tan(psi_test(k))).^2;
    argument(k) = sum (eps);
end
[arg_min, i] = min (argument);
psi_estime = psi_test(i);
end
