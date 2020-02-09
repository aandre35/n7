function message = flag(convergence, stagnation_iter, stagnation_fiter, iter_max)
    if ~convergence
        message = "Algo arrêté par convergence";
    elseif ~stagnation_iter
        message = "Algo arrêté par distance entre les itérés trop faible pour poursuivre";
    elseif ~stagnation_fiter
        message = "Algo arrêté par distance entre les f(itérés) trop faible pour poursuivre";
    elseif ~iter_max
        message = "Algo arrêté par un nombre max d'itérations";
    else
        message = "Erreur";
    end    
end

