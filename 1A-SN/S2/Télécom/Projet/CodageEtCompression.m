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

%% Codage canal

%% Implantation d'une chaine passe-bas équivalente

Fe = 10000; %Hz
Rs = 1000; %kbauds
Ts = 1/Rs;
nb_bits = 100000;

span = 10;
sps = Fe/Rs;
pas = Fe/(2*Rs);
nbps = 2; %nb bits par symboles

%PARAMETRES DU CODE
% Longueur de contrainte 
K=7;    
% Premier polynôme générateur
g1=171;   
% Deuxième polynôme générateur
g2=133;  
% Génération du treillis du code convolutif
trellis=poly2trellis(K,[g1 g2]);

%Paramètres de l’entrelaceur
nrows=12;  %Nombre de registres (FIFO)
slope=17; %Taille des registres (FIFO)

%Délai introduit
Delai=nrows*(nrows-1)*slope;

%PARAMETRES DU CODE
% nombre de bits par symbole
Nb_bits_symb = 8; 
% capacite de correction du code
t = 8;       
% nombre de symboles du mot de code RS (apres codage)
N_RS = 2^Nb_bits_symb-1;  
% nombre de symboles du mot d'info RS
K_RS = N_RS-2*t;            

%Génération de bits 
%!! Le nombre de bits générés doit être un multiple de K_RS pour que les programmes de codage/décodage RS fonctionnent
%On génère Nb_paquets_RS de taille K_RS*Nb_bits_symb bits
Nb_paquets_RS=64;
Nb_bits=Nb_paquets_RS*188*Nb_bits_symb; 
bits=flux_envoi;
bits = [bits zeros(1,8*Nb_bits - length(bits))];

%CODAGE RS
gp = rsgenpoly(N_RS,K_RS,[],0);
H = comm.RSEncoder(N_RS,K_RS,gp,188,'BitInput',true);
bits_code_RS1=step(H,bits.').';

%ENTRELACEMENT
bits_code_RS = reshape(bits_code_RS1,8,length(bits_code_RS1)/8)';
bits_paddes = bi2de(bits_code_RS);
bits_paddes = [bits_paddes ; zeros(Delai,1)];
bits_entrelaces = convintrlv(bits_paddes,nrows,slope);
bits_entrelaces = reshape(de2bi(bits_entrelaces)',1,numel(de2bi(bits_entrelaces)));

%CODAGE CONVOLUTIF
bits_codes=convenc(bits_entrelaces,trellis);
bits_codes=2*bits_codes-1;

I = bits_codes(1:2:end);
Q = bits_codes(2:2:end);
dk = I + 1i*Q;

Dirac = kron(dk,[1 zeros(1,Fe/Rs-1)]);
Dirac = [Dirac, zeros(1,span*pas)];

% Filtre de mise en forme en racine de cos surélevé
hp = rcosdesign(0.35,span,sps,'sqrt');
filtrage_racine = filter(hp,1,Dirac);
filtrage_racine = filtrage_racine(span*pas+1:end );

% Calcul de sigma_n_carre
M = 4;
somme_hk_carre = sum(abs(hp).^2);

% % Tracé du taux d'erreur binaire en fonction du rapport signal à bruit
% Ajout de bruit blanc
sigma_i_carre = var(dk)*somme_hk_carre ./ (2*log2(M)*10.^(1/10));
signal_bruite_porteuse3 = filtrage_racine + sqrt(sigma_i_carre)*(1+1i)*randn(1,length(filtrage_racine));

signal_bruite_porteuse3 = [signal_bruite_porteuse3 zeros(1,span*pas)];

% Démodulation en bande de base
signal_reception_porteuse3 = filter(hp,1,signal_bruite_porteuse3);
signal_reception_porteuse3 = signal_reception_porteuse3(span*pas+1:end);
        
% Echantillonage
signal_echantillonne_porteuse3 = signal_reception_porteuse3(1 : sps : end);
    
% Décision 
reel = real(signal_echantillonne_porteuse3)>0;
ima = imag(signal_echantillonne_porteuse3)>0;
signal_decision_porteuse3 = zeros(1, 2*length(reel));
signal_decision_porteuse3(1:2:end) = reel;
signal_decision_porteuse3(2:2:end) = ima;
signal_decision_porteuse3 = 1-2*signal_decision_porteuse3;
    
%DECODAGE DE VITERBI
bits_decodes = vitdec(signal_decision_porteuse3,trellis,5*K,'trunc','unquant');
    
%DESENTRELACEMENT
%Désentrelament
bits_desentrelaces1 = reshape(bits_decodes',Nb_bits_symb,length(bits_decodes)/Nb_bits_symb)';
bits_desentrelaces2 = bi2de(bits_desentrelaces1);
bits_desentrelaces = convdeintrlv(bits_desentrelaces2, nrows, slope);

%Suppression du retard
Bits_retrouves1 = bits_desentrelaces(Delai+1:end);

Bits_retrouves2 = de2bi(Bits_retrouves1);
Bits_retrouves = reshape(Bits_retrouves2',1,numel(Bits_retrouves2));

%DECODAGE RS
H = comm.RSDecoder(N_RS,K_RS,gp,188,'BitInput',true);
bits_decodes_RS = step(H,Bits_retrouves.').';

flux_envoi2 = bits_decodes_RS(1:length(flux_envoi));
taux_lol = length(find(flux_envoi - flux_envoi2))/length(flux_envoi)
%% Decompression

flux_recu = huffmandeco(flux_envoi2, DICT);

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


