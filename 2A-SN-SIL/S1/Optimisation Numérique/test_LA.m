%% paramètres:
lambda_0 = 2;
tau = 0.5;
eps_newton = 10^(-6);
tol2_newton = 0.001;
iter_max_newton = 50;
iter_max = 50;
delta0_RC = 2;
delta_max_RC = 10;
gamma1_RC = 0.5;
gamma2_RC = 2;
eta1_RC = 0.25;
eta2_RC = 0.75;
iter_max_RC=1000;
tol = 0.001;
Methodes = ["RC_CG" "RC_Cauchy" "Newton"];
%% Test Annexes D
%% Test avec f1
disp("Test avec f1")
% Test avec xc11

xc11 = [0; 1; 1];
xc12 = [0.5; 1.25; 1];
xc1 = [xc11, xc12];
for x = xc1
    disp("#################")
    disp("Tests avec :");
    disp(x);
    for m = Methodes
       disp("###### Méthode : " + m);
       [xk, lambda_k, mu_k, nbIter] = lagrangien_augmente (m, @f1, @gradf1, @hessf1, @c1, @gradc1, @hessc1, @jacobc1, ...
                                                x, lambda_0, tau, tol, iter_max, ...
                                                eps_newton, tol2_newton, iter_max_newton, ...
                                                delta0_RC, delta_max_RC, gamma1_RC, gamma2_RC, ...
                                                eta1_RC, eta2_RC, iter_max_RC); 
        disp("Résultas obtenus : ");
        disp("x* =")
        disp(xk);
        disp("f1(x*) =");
        disp(f1(xk));
        disp("mu_k =");
        disp(mu_k);
        disp("lambda_k =");
        disp(lambda_k);
        disp("Algo terminé au bout de " + nbIter + " itérations");
        disp("");
    end
end



%% Test avec f2
disp("######################################");
disp("Test avec f2")

% Test avec xc21
xc21 = [1; 0];
xc22 = [sqrt(3)/2; sqrt(3)/2];
xc2 = [xc21, xc22];
for x = xc2
    disp("#################")
    disp("Tests avec :");
    disp(x);
    for m = Methodes
       disp("###### Méthode : " + m);
       [xk, lambda_k, mu_k, nbIter] = lagrangien_augmente (m, @f2, @gradf2, @hessf2, @c2, @gradc2, @hessc2, @jacobc2, ...
                                                x, lambda_0, tau, tol, iter_max, ...
                                                eps_newton, tol2_newton, iter_max_newton, ...
                                                delta0_RC, delta_max_RC, gamma1_RC, gamma2_RC, ...
                                                eta1_RC, eta2_RC, iter_max_RC); 
        disp("Résultas obtenus : ");
        disp("x* =")
        disp(xk);
        disp("f2(x*) =");
        disp(f2(xk));
        disp("mu_k =");
        disp(mu_k);
        disp("lambda_k =");
        disp(lambda_k);
        disp("Algo terminé au bout de " + nbIter + " itérations");
        disp("");
    end
end

