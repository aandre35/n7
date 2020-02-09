function s = pas_Cauchy(grad,hess,delta)
    c= grad' * hess * grad;
    ngrad = norm(grad);
    
    if ngrad==0
        s = zeros(size(grad));
        return
    end
    
    
    %Cas convexe
    if c>0
        t = min(delta/ngrad, ngrad^2 / c);
    
    %Cas concave
    else    
        t = delta /ngrad;
    end
    
    s = -t * grad;
           
end