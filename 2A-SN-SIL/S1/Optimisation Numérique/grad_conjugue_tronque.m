function s = grad_conjugue_tronque(delta_k, gradf, hessf, eps, iter_max)
    g0 =gradf;
    g_j = gradf;
    s_j= zeros(size(gradf));
    p_j = -gradf;
    delta_j = delta_k;
    sigma_j = 0;
    alpha_j = 0;
    
    if (~norm(g_j)>0)
        s = zeros(size(g_j));
        disp ("ERREUR : gradient nul => point critique");
        return;
    else
        for j=1:iter_max
            %% Etape a
            k_j = p_j'* hessf * p_j;

            %% Etape b
            if k_j <= 0
                discr = 4*(s_j'*p_j)^2 - 4*(norm(p_j)^2)*((norm(s_j)^2) -delta_k^2);
                sigma1 = (-2*s_j'*p_j - sqrt(discr))/(2*(norm(p_j)^2));
                s1 = s_j + sigma1*p_j;
                sigma2 = (-2*s_j'*p_j + sqrt(discr))/(2*(norm(p_j)^2));
                s2 = s_j + sigma2*p_j;
                if ( q(g_j, hessf, s1) <= q(gradf, hessf, s2) )
                    s = s1;
                else
                    s = s2;
                end
                return;
            end

            %% Etape c
            alpha_j = g_j'* g_j / k_j;

            %% Etape d
            if (norm(s_j + alpha_j*p_j) >= delta_k)
                discr = 4*(s_j'*p_j)^2 - 4*(norm(p_j)^2)*((norm(s_j)^2) -delta_k^2);
                sigma1 = (-2*s_j'*p_j - sqrt(discr))/(2*(norm(p_j)^2));
                sigma2 = (-2*s_j'*p_j + sqrt(discr))/(2*(norm(p_j)^2));

                if ( sigma1>=0)
                    sigma_j = sigma1;
                else
                    sigma_j = sigma2;
                end
                s = s_j + sigma_j*p_j;
                return
            end

            %% Etape e
            % Mise à jour de s
            s_j = s_j + alpha_j*p_j;

            %% Etape f
            % Mise à jour du gradient
            g_buf = g_j;
            g_j = g_j + alpha_j*hessf*p_j;

            %% Etape g
            % Mise à jour de beta
            beta_j = norm(g_j)^2/norm(g_buf);

            %% Etape h
            % Mise à jour de p, la nouvelle direction
            p_j = g_j + beta_j*p_j;

            %% Etape j
            % test d'arrets
            test_arret = norm(g_j) <= eps*(norm(g0) + sqrt(eps));
            if (test_arret || j >= iter_max)
                s = s_j;
                return
            end

            %% Etape k
            % incrémentation de j
            j= j+1;
        end 
    end
end

