function G = gradf2(x)
    y1 = 100 * (-2) * x(1) * (x(2) - x(1)) + 2*(1-x(1));
    y2 = 100 * 2 * (x(2) - x(1));
    G= [y1; y2];
end