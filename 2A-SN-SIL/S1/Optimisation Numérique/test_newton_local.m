%% Test de la fonction newton_local 

%% paramètres:

tol1 = 10^(-6);
tol2 = 10^(-6);
iter_max = 1000;
eps = 10^(-6);

%% Tests Annexe A
%Test avec f1
disp("Tests sur f1:");
disp("#################################################")
x011 = [1; 0; 0];
disp("Soit x011=");
disp(x011);
disp("On obtient:");
[min_f11, cond_convergence, cond_stagnation, cond_max_iter, nbIter] = newton_local(@gradf1, @hessf1, x011, eps, tol1, tol2, iter_max);
disp("x_min =")
disp(min_f11);
disp("Le minimum vaut : f1(x_min)=");
disp(f1(min_f11));
disp(flag(cond_convergence, true, cond_stagnation, cond_max_iter) + " au bout de : " + nbIter + " itérations");

disp("#################################################")


x012 = [10; 3; -2.2];
disp("Soit x012=");
disp(x012);
disp("On obtient:");
[min_f12, cond_convergence, cond_stagnation, cond_max_iter, nbIter] = newton_local(@gradf1, @hessf1, x012, eps, tol1, tol2, iter_max);
disp("x_min =")
disp(min_f12);
disp("Le minimum vaut : f1(x_min)=");
disp(f1(min_f12));
disp(flag(cond_convergence, true, cond_stagnation, cond_max_iter) + " au bout de : " + nbIter + " itérations");

disp("#################################################")
disp("#################################################")

%Test avec f2
disp("Tests sur f2:");

disp("#################################################")
x021 = [-1.2; 1];
disp("Soit x021=");
disp(x021);
disp("On obtient:");
[min_f21, cond_convergence, cond_stagnation, cond_max_iter, nbIter] = newton_local(@gradf2, @hessf2, x021, eps, tol1, tol2, iter_max);
disp("x_min =")
disp(min_f21);
disp("Le minimum vaut : f2(x_min)=");
disp(f2(min_f21));
disp(flag(cond_convergence, true, cond_stagnation, cond_max_iter) + " au bout de : " + nbIter + " itérations");

disp("#################################################")
x022 = [10; 0];
disp("Soit x022=");
disp(x022);
disp("On obtient:");
[min_f22, cond_convergence, cond_stagnation, cond_max_iter, nbIter] = newton_local(@gradf2, @hessf2, x022, eps, tol1, tol2, iter_max);
disp("x_min =")
disp(min_f22);
disp("Le minimum vaut : f2(x_min)=");
disp(f2(min_f22));
disp(flag(cond_convergence, true, cond_stagnation, cond_max_iter) + " au bout de : " + nbIter + " itérations");

disp("#################################################")
x023 = [0; 1/200 + 10^(-12)];
disp("Soit x023=");
disp(x023);
disp("On obtient:");
[min_f23, cond_convergence, cond_stagnation, cond_max_iter, nbIter] = newton_local(@gradf2, @hessf2, x023, eps, tol1, tol2, iter_max);
disp("x_min =")
disp(min_f23);
disp("Le minimum vaut : f2(x_min)=");
disp(f2(min_f23));
disp(flag(cond_convergence, true, cond_stagnation, cond_max_iter) + " au bout de : " + nbIter + " itérations");


%% Tests OK