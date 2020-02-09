clear all;
close all;
clc;

%% Compression

% Lecture de l'image
image = imread('barbara.png');

% Affichage de l’image
figure;
imshow(uint8(image));

% Dimensions
N = size(image, 1);
M = size(image, 2);

%Matrice de quantification
Q=[16 11 10 16 24 40 51 61 ; 12 12 14 19 26 58 60 55; 14 13 16 24 40 57 69 56;...
14 17 22 29 51 87 80 62; 18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; ...
49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];

image_compressee = [];

for i=1:N/8
    for j=1:M/8
        %Découpage en blocs 8x8
        bloc = image(8*i-7:8*i,8*j-7:8*j);
        
        %Découpage en bloc DCT
        bloc = dct2(bloc);
        
        %Quantification par bloc
        bloc = round(bloc./Q);
        
        %Lecture en zig-zag par bloc
        indice = reshape(1:numel(bloc), size(bloc));  % indices des elements
        ind = fliplr(spdiags(fliplr(indice)));    % anti-diagonals
        ind(:,1:2:end) = flipud( ind(:,1:2:end) );  % inverser les colonnes
        ind(ind==0) = [];
        
        bloc_zigzag = bloc(ind);   % on recupère les éléments en Zigzag
        

        
        %Codage RLE
        valeur_rle = [];
        occurence_rle = [];
        k=1;
        while k < 65
            compteur=1;
            valeur_rle = [valeur_rle bloc_zigzag(k)];
            while k+compteur<65 && bloc_zigzag(k) == bloc_zigzag(k+compteur) 
                compteur = compteur + 1;
            end;
            k=k+compteur;
            occurence_rle = [occurence_rle compteur];
        end;
        
        rle = [occurence_rle; valeur_rle];
        
        image_compressee = [image_compressee rle];  
    
    end;
        
end;

%Compression de Huffman
occurences_rle = image_compressee(1,:);
valeurs_rle = image_compressee(2,:);

[X_rle, indices_rle]=sort(valeurs_rle);
l=1;
valeurs= [];
occurences=[];

while l<= length(X_rle)
    j=occurences_rle(indices_rle(l)); % nb d'occurence de l'élément l de X
    k=l+1;
    while k<length(X_rle)+1 && X_rle(l)==X_rle(k)
        j=j+occurences_rle(indices_rle(k));
        k=k+1;
    end
    valeurs = [valeurs X_rle(l)];
    occurences = [occurences j];
    l = k;
end

huffmanbloc = [valeurs;occurences];

probas = occurences ./ (N*M);

%Création du dictionnaire de huffman
dictionnaire_huff = huffmandict(valeurs, probas);

%Lecture et affichage du dictionnaire
temp= dictionnaire_huff;
for i = 1:length(temp)
    temp{i,2} = num2str(temp{i,2});
end

codage_huff = huffmanenco(valeurs_rle, dictionnaire_huff);


%% Décompression

%Décodage de huffman
decodage_huff = huffmandeco(codage_huff, dictionnaire_huff);

%Décodage RLE inverse 
decodage_valeurs_rle = [];

for i=1:length(decodage_huff);
    j= occurences_rle(i);
    while j>0
        decodage_valeurs_rle = [decodage_valeurs_rle decodage_huff(i)];
        j=j-1;
    end
end

[X indice_inv] = sort(ind);
image_decompressee = zeros(N,M);
k = 1;



for i= 1:N/8;
    for j= 1:M/8;
        decodage_bloc = decodage_valeurs_rle(64*k-63:64*k);
        
        % inverse Zigzag
        bloc_zig_zag_inv = decodage_bloc(indice_inv);   
        zig_zag_inv = reshape(bloc_zig_zag_inv, [8,8]);   
        k=k+1;
        
        
        % DCT inverse
        quantitification_inv = zig_zag_inv.*Q;
        dictionnaire_huff_inv = idct2(quantitification_inv);
        
        image_decompressee(8*i-7:8*i,8*j-7:8*j) = dictionnaire_huff_inv;
        
    end
end

image_recue = uint8(image_decompressee);


figure;
imshow(image_recue);



