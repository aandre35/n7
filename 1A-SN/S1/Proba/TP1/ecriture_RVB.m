function image_RVB = ecriture_RVB (image_originale)
[l,c] = size(image_originale);
R= image_originale(1:2:l-1,2:2:c);
V1= image_originale (1:2:l-1, 1:2:c-1);
B= image_originale (2:2:l, 1:2:c-1);
V2= image_originale (2:2:l, 2:2:c);
image_RVB (:,:,1) =  R;
image_RVB (:,:,2) = (V1+V2)/2;
image_RVB (:,:,3)= B;
end
