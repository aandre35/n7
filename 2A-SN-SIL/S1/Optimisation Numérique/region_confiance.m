function [min_f, nbIter, test_arret_convergence, test_arret_stagnation, test_arret_fstagnation, test_arret_iter_max] = region_confiance(methode, f, gradf, hessf, x0, delta0, delta_max, gamma1, gamma2, eta1, eta2, iter_max)
    
    % Initialisations
    xk = x0;
    delta_k = delta0;
    eps = 10 ^(-6);
    tol = 0.001;
    k = 0;
    test_arret = true;
    g0 = gradf(x0);
    
    if (methode ~= "Cauchy" && methode ~= "CG")
        disp("Veuillez chosir l'une des deux méthodes suivantes : Cauchy ou CG");
        return;
    
    elseif ( ~(0<gamma1 && gamma1<1 && 1<gamma2) || ...
            ~(0<eta1 && eta1<eta2 && eta2<1) || ...
            ~(0<=delta0 && delta0<=delta_max))
        disp("Erreur sur les paramètres (eta ou gamma)");
        return;
    else 
        test_arret_convergence = true;
        test_arret_stagnation = true;
        test_arret_fstagnation = true;
        % Tant que le test de convergence n'est pas satisfait
        while test_arret
            
            gradient = gradf(xk);
            hessienne = hessf(xk);


            %% a) Résolution approximative du minimum
            if (methode == "Cauchy")
                %% On réssout le problème avec la méthode du pas de Cauchy
                s = pas_Cauchy(gradient, hessienne ,delta_k);
            else
                %% On réssout le problème avec la méthode CG
                eps_cg = 10 ^(-6);
                iter_max_cg = 50;
                s = grad_conjugue_tronque(delta_k, gradient, hessienne, eps_cg, iter_max_cg);
            end
            
            f_x = f(xk);
            %% b.1) Evaluation de f(xk + sk) et mk(xk + sk)
            f_x_plus_s = f(xk+s);

            %% b.2) Evaluation de rho
            rho = (f_x - f_x_plus_s) / -q(gradient,hessienne, s);

            %% c) Mise à jour de xk (itéré courant)
            x_buf = xk;
            if rho >= eta1
                xk = xk + s;
                test_arret_convergence = norm(gradf(xk)) > tol*(norm(g0) + sqrt(eps));
                test_arret_stagnation = norm(x_buf-xk) > tol*(norm(x_buf) + sqrt(eps));
                test_arret_fstagnation = norm(f_x_plus_s - f_x) > tol*(norm(f_x) + sqrt(eps));
            else 
            end

            %% d) Mise à jour de la region de confiance delta_k
            if rho>= eta2 
                delta_k = min(gamma2 * delta_k, delta_max);             
            elseif rho< eta1
                delta_k = gamma1 * delta_k;
            end

            %% test d'arrets           
            k =k + 1;
            test_arret_iter_max = (k < iter_max);
            test_arret = test_arret_convergence & test_arret_stagnation & test_arret_fstagnation & test_arret_iter_max;
         
        end

        nbIter= k;
        min_f = xk;
    end
end
    