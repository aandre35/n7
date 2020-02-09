function [min, cond_convergence, cond_stagnation, cond_max_iter, nbIter] = newton_local(gradf, hessf,x0, eps, tol1, tol2, iter_max)
    
    %On initialise les variables
    x= x0;
    d= hessf(x) \ (-gradf(x));
    ng0 = norm(gradf(x0)); 
    k=0;
    cond = true;
    %On cherche la solution
    while cond
        
        d= hessf(x) \ (-gradf(x));      
        x_buf = x;
        x = x + d;
        k=k+1;    
        
        cond_convergence = norm(gradf(x)) > tol1 * (ng0 + eps);
        cond_stagnation = norm(d) > tol2 * (norm(x_buf) + eps);
        cond_max_iter = k< iter_max;
        cond = cond_max_iter && cond_stagnation && cond_convergence;
    end
    min=x;
    nbIter = k;
    %On regarde si le nombre d'iterations max a été dépasée.
    
end