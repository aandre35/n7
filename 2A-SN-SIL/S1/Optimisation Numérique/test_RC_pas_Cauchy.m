%% Test de la fonction region_confiance 

% paramètres:
delta0 = 2;
delta_max = 10;
gamma1 = 0.5;
gamma2 = 2;
eta1 = 0.25;
eta2 = 0.75;
iter_max=50;


%% Test sur les fonctions de l'annexe A 
disp("Test de l'algorithme de RC avec la méthode du pas de Cauchy");
%Test avec f1
x011 = [1; 0; 0];
x012 = [10; 3; -2.2];
x01 = [x011 x012];
disp("Tests pour f1")
disp("#################################################")
for x = x01
    disp("#################")
    disp("x0 = ");
    disp(x);
    [min_f1, nbIter, test_arret_convergence, test_arret_stagnation, test_arret_fstagnation, test_arret_iter_max] = region_confiance("Cauchy",@f1, @gradf1, @hessf1, x, ...
    delta0, delta_max, gamma1, gamma2, eta1, eta2, iter_max);
    disp("min f1 : ");
    disp(min_f1);      
    disp("f1(x*) =");
    disp(f1(min_f1));
    disp(flag(test_arret_convergence, test_arret_stagnation, test_arret_fstagnation, test_arret_iter_max) + " au bout de : " + nbIter + " itérations");
end
disp("#################################################")

%Test avec f2
delta0=1;
x021 = [-1.2; 1];
x022 = [10; 0];
x023 = [0; 0.005];
x02 = [x021 x022 x023];
disp("Tests pour f2")
disp("#################################################")
for x = x02
    disp("#################")
    disp("x0 = ");
    disp(x);
    [min_f2, nbIter, test_arret_convergence, test_arret_stagnation, test_arret_fstagnation, test_arret_iter_max] = region_confiance("Cauchy",@f2, @gradf2, @hessf2, x, ...
    delta0, delta_max, gamma1, gamma2, eta1, eta2, iter_max);
    disp("min f2 : ");
    disp(min_f2);
    disp("f2(x*) =");
    disp(f2(min_f2));
    disp(flag(test_arret_convergence, test_arret_stagnation, test_arret_fstagnation, test_arret_iter_max) + " au bout de : " + nbIter + " itérations");
end

%% Tests ok