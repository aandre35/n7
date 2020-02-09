function [rho_F,theta_F] = estimation_foyer(rho,theta)

A= [cos(theta) sin(theta)];
B=rho;
X = A\B;
rho_F = sqrt(X(1)^2 + X(2)^2);
theta_F = atan(X(2) / X(1));

end