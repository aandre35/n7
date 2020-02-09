clear all;
close all;
clc;

%% Compression
%Lecture de l’image (noir et blanc)

image =imread('barbara.png');
%image = double(rgb2gray(image));

% Affichage de l’image
figure;
imshow(uint8(image));

% Dimensions
N = size(image,1); % nombre de lignes
M = size(image,2); % nombre de colonnes

%Matrice de quantification
Q=[16 11 10 16 24 40 51 61 ; 12 12 14 19 26 58 60 55 ; 14 13 16 24 40 57,...
    69 56 ; 14 17 22 29 51 87 80 62 ; 18 22 37 56 68 109 103 77 ; 24 35 55 64 81,...
    104 113 92 ; 49 64 78 87 103 121 120 101 ; 72 92 95 98 112 100 103 99];



MC=[];
for i= 1:N/8;
    for j= 1:M/8;
        
        % Découpage en blocs 8x8
        
        bloc = image(8*i-7:8*i,8*j-7:8*j);
        %imshow(uint8(bloc));
        
        % Discrete Cosinus Transform
        bloc = dct2(bloc);
        
        % Quantification
        bloc = round(bloc./Q);
        
        % zig zag
        ind1 = reshape(1:numel(bloc), size(bloc));  % indices des elements
        ind = fliplr( spdiags( fliplr(ind1) ) );    % anti-diagonals
        ind(:,1:2:end) = flipud( ind(:,1:2:end) );  % inverser les colonnes
        ind(ind==0) = [];
        
        zbloc = bloc(ind);   %# on recupère les éléments en Zigzag
        
        %RLE
        valeur_rle =[];
        occurence_rle=[];
        l=1;
        while l<65
            j=1; % permet de compter le nombre d'occurence d'un élément
            k=l+1; % Voisins de l
            % On regarde si l'élément est égal à son voisin de gauche
            while k<65 && zbloc(l)==zbloc(k)
                j=j+1;
                k=k+1;
            end
            valeur_rle = [valeur_rle zbloc(l)];
            occurence_rle = [occurence_rle j];
            l = l+j;
        end
        rlebloc = [valeur_rle;occurence_rle];
        
        
        % Bits de l'image compressée
        MC = [MC rlebloc];
        
    end
end

% valeur_test =  [33 51 1 0 -2 0 1 0 54 0 11 0 10 0 23 33 -1 14 0];
% occurence_test = [1 1 1 2 1 1 1 7 1 2 1 5 1 1 1 1 1 1 34];
% valeur_rle = valeur_test;
% occurence_rle = occurence_test;

% Codage de Huffman

valeur_rle = MC(1,:);
occurence_rle = MC(2,:);

valeurs =[];
occurence1=[];
[X, I]=sort(valeur_rle);
l=1;

while l<(length(X)+1)
    j=occurence_rle(I(l)); % nb d'occurence de l'élément l de X
    k=l+1;
    while k<length(X)+1 && X(l)==X(k)
        j=j+occurence_rle(I(k));
        k=k+1;
    end
    valeurs = [valeurs X(l)];
    occurence1 = [occurence1 j];
    l = k;
end
huffmanbloc = [valeurs;occurence1];

% Mise en place du dictionnaire pour le codage de Huffman

probas = occurence1./(N*M);
%probas_test = occurence1./64;

DICT = huffmandict(valeurs, probas);
%proba = probabilité d’apparition de ces différentes valeurs

% %Lecture et affichage du dictionnaire
temp = DICT;
for j = 1:length(temp)
    temp{j,2} = num2str(temp{j,2});
end

% Codage de Huffman du vecteur de valeurs de sorti du RLE
flux_envoi = huffmanenco(valeur_rle, DICT);

% imshow(uint8(flux_envoi));

%% Decompression

flux_recu = huffmandeco(flux_envoi, DICT);

MD=[];

% inverse du RLE
flux_inv_rle=[];

for i=1:length(flux_recu)
    
    j=occurence_rle(i);
    while j>0
        flux_inv_rle=[flux_inv_rle flux_recu(i)];
        j=j-1;
    end
end


[X indInv] = sort(ind);
MD = zeros(N,M);
k = 1;


for i= 1:N/8;
    for j= 1:M/8;
        flux_inv_bloc = flux_inv_rle((64*(k-1)+1):64*k);
        
        % inverse Zigzag
        zblocInv = flux_inv_bloc(indInv);   
        invZZ = reshape(zblocInv, [8,8]);   
        k=k+1;
        
        
        % DCT inverse
        quantInv = invZZ.*Q;
        dctInv = idct2(quantInv);
        
        MD(8*i-7:8*i,8*j-7:8*j) = dctInv;
        
    end
end

image_recue = uint8(MD);


figure;
imshow(image_recue);


