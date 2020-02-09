function [rho_F_1,theta_F_1] = RANSAC_2(rho,theta,parametres)
EDM_est = Inf;
for k=1:parametres(3)
    indices = randperm(length(rho), 2);
    %on estime le couple (rho_F, theta_F)
    rho_tire = rho(indices);
    theta_tire = theta (indices);
    [rho_F, theta_F] = estimation_foyer(rho_tire, theta_tire);
    %choix des sroites conformes au seuil S1
    distance_droites_F = abs( rho - rho_F * cos(theta  - theta_F));
    droites_conformes_seuil = find (distance_droites_F < parametres(1));
    %choix par rapport au seuil S2
    m= length(droites_conformes_seuil);
    if (m/length(rho) > parametres(2))
        [rho_F, theta_F] = estimation_foyer (rho(droites_conformes_seuil), theta (droites_conformes_seuil));
        EDM = sum(distance_droites_F(droites_conformes_seuil))/m;
        if (EDM < EDM_est)
            EDM_est = EDM;
            rho_F_1 = rho_F;
            theta_F_1 = theta_F;
        end
    end
end
end

