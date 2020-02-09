function H = hessf1(x)
    y11 = 6;
    y12 = 2;
    y13 = 4;
    y21 = 2;
    y22 = 8;
    y23 = 2;
    y31 = 4;
    y32 = 2;
    y33 = 6;
    
    H= [y11 y12 y13;
        y21 y22 y23;
        y31 y32 y33];
end