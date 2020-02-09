function I_decorrelee = dec (I)
[l,c]=size (I);
G=I(:,1:c-1);
D=I(:,2:c);
I_decorrelee = [I(:,1) D-G];