function [xk, lambda_k, mu_k, nbIter] = lagrangien_augmente (methode, f, gradf, hessf, c, gradc, hessc, jacobc, ...
                                                x0, lambda_0, tau, tol, iter_max, ...
                                                eps_newton, tol2_newton, iter_max_newton, ...
                                                delta0_RC, delta_max_RC, gamma1_RC, gamma2_RC, ...
                                                eta1_RC, eta2_RC, iter_max_RC)
    %% paramètres
    eta_chap = 0.1258925;
    alpha = 0.1;
    beta = 0.9;
    k = 0;
    eta_0 = 0.1;
    mu_0 = (eta_chap/eta_0)^(1/alpha);
    eps_0 = 1/mu_0;

    %% initialisations
    eta_k = eta_0;
    mu_k = mu_0;
    eps_k = eps_0;
    lambda_k = lambda_0;
    xk = x0;
    normgL0 = norm(gradf(xk) + lambda_k'*gradc(xk));
    if (methode ~= "Newton" && methode ~= "RC_CG" && methode ~= "RC_Cauchy")
        disp("Veuillez chosir l'une des trois méthodes suivantes : Newton, RC_Cauchy ou RC_CG");
        return;
    
    else
        while(true)
            L = @(xk) f(xk) + lambda_k'*c(xk)+(mu_k/2)*norm(c(xk))^2;
            gradL = @(xk) gradf(xk) + lambda_k*gradc(xk) + mu_k*jacobc(xk)'*c(xk);
            hessL = @(xk) hessf(xk) + lambda_k*hessc(xk) + mu_k*(jacobc(xk)'*jacobc(xk) + sum(c(xk)*hessc(xk)^2));
            xk_buf = xk;
            %% 1) Calcul approximatif du minimiseur
            if (methode == "Newton")
                [xk, ~] = newton_local(gradL, hessL, x0, eps_newton, eps_k, tol2_newton,...
                    iter_max_newton);
            elseif (methode == "RC_Cauchy")
                [xk, ~] = region_confiance("Cauchy", L, gradL, hessL, x0, delta0_RC, ...
                    delta_max_RC, gamma1_RC, gamma2_RC, eta1_RC, eta2_RC, iter_max_RC);
            elseif (methode == "RC_CG")
                [xk, ~] = region_confiance("CG", L, gradL, hessL, x0, delta0_RC, ...
                    delta_max_RC, gamma1_RC, gamma2_RC, eta1_RC, eta2_RC, iter_max_RC);
            end

            %% 2) Mise à jour des multiplicateurs
            test_arret_iter_max = (k>iter_max);
            test_arret_convergence_1 = (norm(gradf(xk) + lambda_k'*gradc(xk)) <= tol * (normgL0 + eps_k)) && (norm(c(xk)) <= tol ) ;
            test_arret_convergence_2 = norm(xk_buf-xk) <= tol;
            if (test_arret_iter_max || test_arret_convergence_1 || test_arret_convergence_2) 
                nbIter = k+1;
                return;
            end
            if (norm (c(xk)) <= eta_k)
                lambda_k = lambda_k + mu_k * c(xk);
                eps_k = eps_k/mu_k;
                eta_k = eta_k/(mu_k^beta);
                k = k+1;
            else
                mu_k = tau * mu_k;
                eps_k = eps_0/mu_k;
                eta_k = eta_chap/(mu_k^beta);
                k = k+1;
            end
            
            % Critères d'arrêt pour la convergence de l'algorithme
        end
    end
end