function [r,a,b] = calcul_parametres(I_gauche, I_droite)
[n,l]= size (I_gauche);
mg= mean (I_gauche);
md = mean (I_droite);
cov = (1/n)*sum(I_gauche.*I_droite) -md*mg;
sigma_g= ((1/n)*sum(I_gauche.^2) - mg^2)^0.5;
sigma_d= ((1/n)*sum(I_droite.^2) - md^2)^0.5;
r= cov/(sigma_g * sigma_d);
a= cov/ sigma_g^2;
b= -mg * a + md ;
end