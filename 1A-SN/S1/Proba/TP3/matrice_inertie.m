function [C_x,C_y,M] = matrice_inertie(E_x,E_y,E_G_norme)

C_x=0
C_y=0
poids = 0;
M_1_1 = 0;
M_1_2 = 0;
M_2_2 = 0;
M_2_1 = 0;
for i=1:length(E_x)
    C_x = C_x + E_x(i)*E_G_norme(i);
    C_y = C_y + E_y(i)*E_G_norme(i);
    poids = poids + E_G_norme(i);
end
C_x = C_x/ poids ;
C_y = C_y/ poids ;

for i=1:length(E_x)
    M_1_1 = M_1_1 + E_G_norme(i) * (E_x(i) - C_x)^2 ;
    M_1_2 = M_1_2 + E_G_norme(i) * (E_x(i) - C_x) * (E_y(i) - C_y);
    M_2_2 = M_2_2  + E_G_norme(i) * (E_y(i) - C_y)^2 ;
end 

M_1_1 = M_1_1 / poids;
M_1_2 = M_1_2 / poids;
M_2_1 = M_1_2 ;
M_2_2 = M_2_2/ poids;

M=[M_1_1 M_1_2; M_2_1 M_2_2];
