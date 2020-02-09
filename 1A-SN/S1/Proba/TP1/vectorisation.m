function [I_gauche, I_droite] = vectorisation(I)
[l,c] = size(I);
I_g= I(:, 1:c-1);
I_d= I(:, 2:c);
I_gauche = I_g(:);
I_droite = I_d(:);
end

