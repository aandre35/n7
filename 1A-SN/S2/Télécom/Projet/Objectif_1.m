close all;
clear all;

%% Codage Canal : code convolutif(3,1/2) sans poinçonnage
% Paramètres
roll_off = 0.35;
fp = 2000;
Fe = 10000;
Rs = 1000;
Ts = 1/Rs;
Te = 1/Fe;
Ns = Ts/Te;
N = Fe/fp;

% Ordre de modulation
M = 4;
q = log2(M);

% longueur de contrainte
K = 7;
% 2 polynomes générateur
g1 = 171;
g2 = 133;
% Génération du treillis du code convolutif
trellis = poly2trellis(K,[g1 g2]);
% Matrice de poinçonnage
P = [1 1 0 1];

% nombre de pits par symbole
Nb_bits_symb = 8;
% capacite de correction du code
t = 8;
% nombre de symboles du mot de code RS
N_RS = 2^Nb_bits_symb - 1;
% nombre de symboles du mot d'info RS
K_RS = N_RS - 2 * t;

% Génération du flux de bits 
Nb_paquets_RS = 64;
n_bits = Nb_paquets_RS * K_RS * Nb_bits_symb;
bits = randi([0,1],n_bits,1);

%%%%%%%%%%%%%%%%%%%%%% QPSK de base %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mapping
% Séparation en 2 
bits_1 = bits(1:2:end);
bits_2 = bits(2:2:end);

syms_1 = 2 * bits_1 - 1;
syms_2 = 2 * bits_2 - 1;

syms = syms_1 + 1i*syms_2;

%% Sur-échantillonnage
dirac = [1 zeros(1,Ns-1)];
peigne_dirac = kron(syms',dirac);

%% Filtrage aller
h = rcosdesign(roll_off,6,Ns);
x = filter(h,1,[peigne_dirac zeros(1,(length(h)-1)/2)]);
x = x((length(h)-1)/2+1:end);

%% Transposition de fréquence
temps = 0:Te:Te*size(x,2) - Te;
comp = 2*pi*fp*1i*temps;
x_comp = x .* exp(comp);
x_comp = real(x_comp);

%% Retour en bande de base
x_cos = x_comp .* cos(2*pi*fp*temps);
x_sin = x_comp .* sin(2*pi*fp*temps);

% Passe bas
k = -N:1:N;
h_pb = 2*fp*sinc(2*fp*k);

x_reel = filter(h_pb,1,[x_cos zeros(1,(length(h_pb)-1)/2)]);
x_reel = x_reel((length(h_pb)-1)/2+1:end);
x_ima = filter(h_pb,1,[x_sin zeros(1,(length(h_pb)-1)/2)]);
x_ima = x_ima((length(h_pb)-1)/2+1:end);

x_recomp = x_reel - 1i*x_ima;

%% Filtrage retour
h_r = fliplr(h);
z = filter(h_r,1,[x_recomp zeros(1,(length(h_r)-1)/2)]);
z = z((length(h_r)-1)/2+1:end);

%% Sous-échantillonnage
sym_recu_sousech = z(1:Ns:end);

%% Démapping
bits_reel_recu = real(sym_recu_sousech') > 0;
bits_ima_recu = imag(sym_recu_sousech') > 0;

bits_recu = zeros(1,n_bits);
bits_recu(1:2:end) = bits_reel_recu;
bits_recu(2:2:end) = bits_ima_recu;
bits_recu = bits_recu(:);

%% Erreurs sans bruit
TEB = sum(bits_recu ~= bits)/n_bits;

%% Rajout du Bruit
Eb_N0_dB = [-4:6];
Eb_N0 = 10.^(Eb_N0_dB/10);
E_bruit_1 = zeros(1,11);
E_theo = zeros(1,11);
for j = 1:11   
        %% Canal AGWN
        Ps = mean(abs(x_comp).^2);    
        sig = Ps * Ns / (2 * q * Eb_N0(j));
    
        bruit = sqrt(sig) * randn(1,Ns/2 * n_bits);
        x_bruit = x_comp + bruit;
        
        %% Retour en bande de base
        x_cos_bruit = x_bruit .* cos(2*pi*fp*temps);
        x_sin_bruit = x_bruit .* sin(2*pi*fp*temps);

        x_reel_bruit = filter(h_pb,1,[x_cos_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_reel_bruit = x_reel_bruit((length(h_pb)-1)/2+1:end);
        x_ima_bruit = filter(h_pb,1,[x_sin_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_ima_bruit = x_ima_bruit((length(h_pb)-1)/2+1:end);
        
        x_recomp_bruit = x_reel_bruit - 1i*x_ima_bruit;
    
        %% Filtrage retour
        z_bruit = filter(h_r,1,[x_recomp_bruit zeros(1,(length(h_r)-1)/2)]);
        z_bruit = z_bruit((length(h_r)-1)/2+1:end);
    
        %% Sous echantillonnage
        sym_recu_sousech_bruit = z_bruit(1:Ns:end);
    
        %% Démapping
        bits_reel_recu_bruit = real(sym_recu_sousech_bruit') > 0;
        bits_ima_recu_bruit = imag(sym_recu_sousech_bruit') > 0;
        
        bits_recu_bruit = zeros(1,n_bits);
        bits_recu_bruit(1:2:end) = bits_reel_recu_bruit;
        bits_recu_bruit(2:2:end) = bits_ima_recu_bruit;
        bits_recu_bruit = bits_recu_bruit(:);
        
        E_bruit_1(j) = sum(bits_recu_bruit ~= bits)/n_bits;
    
    %% TEB théorique
    E_theo(j) = qfunc(sqrt(2 * Eb_N0(j)));
    
end

%%%%%%%%%%%%%%%%%% code convolutif(7,1/2) sans poinçonnage %%%%%%%%%%%%%%%%
%% codage convolutif
bits_codes = convenc(bits,trellis);

%% Mapping
% Séparation en 2 
bits_1 = bits_codes(1:2:end);
bits_2 = bits_codes(2:2:end);

syms_1 = 2 * bits_1 - 1;
syms_2 = 2 * bits_2 - 1;

syms = syms_1 + 1i*syms_2;

%% Sur-échantillonnage
dirac = [1 zeros(1,Ns-1)];
peigne_dirac = kron(syms',dirac);

%% Filtrage aller
h = rcosdesign(roll_off,6,Ns);
x = filter(h,1,[peigne_dirac zeros(1,(length(h)-1)/2)]);
x = x((length(h)-1)/2+1:end);

%% Transposition de fréquence
temps = 0:Te:Te*size(x,2) - Te;
comp = 2*pi*fp*1i*temps;
x_comp = x .* exp(comp);
x_comp = real(x_comp);

%% Retour en bande de base
x_cos = x_comp .* cos(2*pi*fp*temps);
x_sin = x_comp .* sin(2*pi*fp*temps);

% Passe bas
k = -N:1:N;
h_pb = 2*fp*sinc(2*fp*k);

x_reel = filter(h_pb,1,[x_cos zeros(1,(length(h_pb)-1)/2)]);
x_reel = x_reel((length(h_pb)-1)/2+1:end);
x_ima = filter(h_pb,1,[x_sin zeros(1,(length(h_pb)-1)/2)]);
x_ima = x_ima((length(h_pb)-1)/2+1:end);

x_recomp = x_reel - 1i*x_ima;

%% Filtrage retour
h_r = fliplr(h);
z = filter(h_r,1,[x_recomp zeros(1,(length(h_r)-1)/2)]);
z = z((length(h_r)-1)/2+1:end);

%% Sous-échantillonnage
sym_recu_sousech = z(1:Ns:end);

%% Démapping
bits_reel_recu = real(sym_recu_sousech') > 0;
bits_ima_recu = imag(sym_recu_sousech') > 0;

bits_recu = zeros(1,2*length(bits_reel_recu))';
bits_recu(1:2:end) = bits_reel_recu;
bits_recu(2:2:end) = bits_ima_recu;
bits_recu = bits_recu(:);

%% decodage de viterbi
bits_recu_codes = 1 - 2 * bits_recu;
bits_decodes = vitdec(bits_recu_codes,trellis,5*K,'trunc','unquant');

%% Erreurs sans bruit
TEB = sum(bits ~= bits_decodes)/n_bits;

%% Rajout du Bruit
Eb_N0_dB = [-4:6];
Eb_N0 = 10.^(Eb_N0_dB/10);
E_bruit_2 = zeros(1,11);
for j = 1:11
        %% Canal AGWN
        Ps = mean(abs(x_comp).^2);    
        sig = Ps * Ns / (2 * q * Eb_N0(j));
    
        bruit = sqrt(sig) * randn(1,Ns * n_bits);
        x_bruit = x_comp + bruit;
        
        %% Retour en bande de base
        x_cos_bruit = x_bruit .* cos(2*pi*fp*temps);
        x_sin_bruit = x_bruit .* sin(2*pi*fp*temps);

        x_reel_bruit = filter(h_pb,1,[x_cos_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_reel_bruit = x_reel_bruit((length(h_pb)-1)/2+1:end);
        x_ima_bruit = filter(h_pb,1,[x_sin_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_ima_bruit = x_ima_bruit((length(h_pb)-1)/2+1:end);
        
        x_recomp_bruit = x_reel_bruit - 1i*x_ima_bruit;
    
        %% Filtrage retour
        z_bruit = filter(h_r,1,[x_recomp_bruit zeros(1,(length(h_r)-1)/2)]);
        z_bruit = z_bruit((length(h_r)-1)/2+1:end);
    
        %% Sous echantillonnage
        sym_recu_sousech_bruit = z_bruit(1:Ns:end);
    
        %% Démapping
        bits_reel_recu_bruit = real(sym_recu_sousech_bruit') > 0;
        bits_ima_recu_bruit = imag(sym_recu_sousech_bruit') > 0;
        
        bits_recu_bruit = zeros(1,2*length(bits_reel_recu_bruit));
        bits_recu_bruit(1:2:end) = bits_reel_recu_bruit;
        bits_recu_bruit(2:2:end) = bits_ima_recu_bruit;
        bits_recu_bruit = bits_recu_bruit(:);
        
        %% decodage de viterbi
        bits_recu_bruit_codes = 1 - 2 * bits_recu_bruit;
        bits_bruit_decodes = vitdec(bits_recu_bruit_codes,trellis,5*K,'trunc','unquant');
        
        E_bruit_2(j) = sum(bits_bruit_decodes ~= bits)/n_bits;
end

%%%%%%%%%%%%%%%%% code convolutif(7,1/2) avec poinçonnage %%%%%%%%%%%%%%%%%
%% codage convolutif
bits_codes = convenc(bits,trellis,P);

%% Mapping
% Séparation en 2 
bits_1 = bits_codes(1:2:end);
bits_2 = bits_codes(2:2:end);

syms_1 = 2 * bits_1 - 1;
syms_2 = 2 * bits_2 - 1;

syms = syms_1 + 1i*syms_2;

%% Sur-échantillonnage
dirac = [1 zeros(1,Ns-1)];
peigne_dirac = kron(syms',dirac);

%% Filtrage aller
h = rcosdesign(roll_off,6,Ns);
x = filter(h,1,[peigne_dirac zeros(1,(length(h)-1)/2)]);
x = x((length(h)-1)/2+1:end);

%% Transposition de fréquence
temps = 0:Te:Te*size(x,2) - Te;
comp = 2*pi*fp*1i*temps;
x_comp = x .* exp(comp);
x_comp = real(x_comp);

%% Retour en bande de base
x_cos = x_comp .* cos(2*pi*fp*temps);
x_sin = x_comp .* sin(2*pi*fp*temps);

% Passe bas
k = -N:1:N;
h_pb = 2*fp*sinc(2*fp*k);

x_reel = filter(h_pb,1,[x_cos zeros(1,(length(h_pb)-1)/2)]);
x_reel = x_reel((length(h_pb)-1)/2+1:end);
x_ima = filter(h_pb,1,[x_sin zeros(1,(length(h_pb)-1)/2)]);
x_ima = x_ima((length(h_pb)-1)/2+1:end);

x_recomp = x_reel - 1i*x_ima;

%% Filtrage retour
h_r = fliplr(h);
z = filter(h_r,1,[x_recomp zeros(1,(length(h_r)-1)/2)]);
z = z((length(h_r)-1)/2+1:end);

%% Sous-échantillonnage
sym_recu_sousech = z(1:Ns:end);

%% Démapping
bits_reel_recu = real(sym_recu_sousech') > 0;
bits_ima_recu = imag(sym_recu_sousech') > 0;

bits_recu = zeros(1,2*length(bits_reel_recu))';
bits_recu(1:2:end) = bits_reel_recu;
bits_recu(2:2:end) = bits_ima_recu;
bits_recu = bits_recu(:);

%% decodage de viterbi
bits_recu_codes = 1 - 2 * bits_recu;
bits_decodes = vitdec(bits_recu_codes,trellis,5*K,'trunc','unquant',P);

%% Erreurs sans bruit
TEB = sum(bits ~= bits_decodes)/n_bits;

%% Rajout du Bruit
Eb_N0_dB = [-4:6];
Eb_N0 = 10.^(Eb_N0_dB/10);
E_bruit_3 = zeros(1,11);
for j = 1:11
        %% Canal AGWN
        Ps = mean(abs(x_comp).^2);    
        sig = Ps * Ns / (2 * q * Eb_N0(j));
    
        bruit = sqrt(sig) * randn(1,length(x_comp));
        x_bruit = x_comp + bruit;
        
        %% Retour en bande de base
        x_cos_bruit = x_bruit .* cos(2*pi*fp*temps);
        x_sin_bruit = x_bruit .* sin(2*pi*fp*temps);

        x_reel_bruit = filter(h_pb,1,[x_cos_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_reel_bruit = x_reel_bruit((length(h_pb)-1)/2+1:end);
        x_ima_bruit = filter(h_pb,1,[x_sin_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_ima_bruit = x_ima_bruit((length(h_pb)-1)/2+1:end);
        
        x_recomp_bruit = x_reel_bruit - 1i*x_ima_bruit;
    
        %% Filtrage retour
        z_bruit = filter(h_r,1,[x_recomp_bruit zeros(1,(length(h_r)-1)/2)]);
        z_bruit = z_bruit((length(h_r)-1)/2+1:end);
    
        %% Sous echantillonnage
        sym_recu_sousech_bruit = z_bruit(1:Ns:end);
    
        %% Démapping
        bits_reel_recu_bruit = real(sym_recu_sousech_bruit') > 0;
        bits_ima_recu_bruit = imag(sym_recu_sousech_bruit') > 0;
        
        bits_recu_bruit = zeros(1,2*length(bits_reel_recu_bruit));
        bits_recu_bruit(1:2:end) = bits_reel_recu_bruit;
        bits_recu_bruit(2:2:end) = bits_ima_recu_bruit;
        bits_recu_bruit = bits_recu_bruit(:);
        
        %% decodage de viterbi
        bits_recu_bruit_codes = 1 - 2 * bits_recu_bruit;
        bits_bruit_decodes = vitdec(bits_recu_bruit_codes,trellis,5*K,'trunc','unquant',P);
        
        E_bruit_3(j) = sum(bits_bruit_decodes ~= bits)/n_bits;        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Reed Solomon %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Codage RS
Hc = comm.RSEncoder(N_RS,K_RS,'BitInput',true);
bits_codes_RS = step(Hc,bits);

%% Mapping
% Séparation en 2 
bits_1 = bits_codes_RS(1:2:end);
bits_2 = bits_codes_RS(2:2:end);

syms_1 = 2 * bits_1 - 1;
syms_2 = 2 * bits_2 - 1;

syms = syms_1 + 1i*syms_2;

%% Sur-échantillonnage
dirac = [1 zeros(1,Ns-1)];
peigne_dirac = kron(syms',dirac);

%% Filtrage aller
h = rcosdesign(roll_off,6,Ns);
x = filter(h,1,[peigne_dirac zeros(1,(length(h)-1)/2)]);
x = x((length(h)-1)/2+1:end);

%% Transposition de fréquence
temps = 0:Te:Te*size(x,2) - Te;
comp = 2*pi*fp*1i*temps;
x_comp = x .* exp(comp);
x_comp = real(x_comp);

%% Retour en bande de base
x_cos = x_comp .* cos(2*pi*fp*temps);
x_sin = x_comp .* sin(2*pi*fp*temps);

% Passe bas
k = -N:1:N;
h_pb = 2*fp*sinc(2*fp*k);

x_reel = filter(h_pb,1,[x_cos zeros(1,(length(h_pb)-1)/2)]);
x_reel = x_reel((length(h_pb)-1)/2+1:end);
x_ima = filter(h_pb,1,[x_sin zeros(1,(length(h_pb)-1)/2)]);
x_ima = x_ima((length(h_pb)-1)/2+1:end);

x_recomp = x_reel - 1i*x_ima;

%% Filtrage retour
h_r = fliplr(h);
z = filter(h_r,1,[x_recomp zeros(1,(length(h_r)-1)/2)]);
z = z((length(h_r)-1)/2+1:end);

%% Sous-échantillonnage
sym_recu_sousech = z(1:Ns:end);

%% Démapping
bits_reel_recu = real(sym_recu_sousech') > 0;
bits_ima_recu = imag(sym_recu_sousech') > 0;

bits_recu = zeros(1,2*length(bits_reel_recu));
bits_recu(1:2:end) = bits_reel_recu;
bits_recu(2:2:end) = bits_ima_recu;
bits_recu = bits_recu(:);

%% Decodage
Hd = comm.RSDecoder(N_RS,K_RS,'BitInput',true);
bits_recu_decodes = step(Hd,bits_recu);

%% Erreurs sans bruit
TEB = sum(bits_recu_decodes ~= bits)/n_bits;

%% Rajout du Bruit
Eb_N0_dB = [-4:6];
Eb_N0 = 10.^(Eb_N0_dB/10);
E_bruit_4 = zeros(1,11);
E_theo = zeros(1,11);
for j = 1:11   
        %% Canal AGWN
        Ps = mean(abs(x_comp).^2);    
        sig = Ps * Ns / (2 * q * Eb_N0(j));
    
        bruit = sqrt(sig) * randn(1,length(x_comp));
        x_bruit = x_comp + bruit;
        
        %% Retour en bande de base
        x_cos_bruit = x_bruit .* cos(2*pi*fp*temps);
        x_sin_bruit = x_bruit .* sin(2*pi*fp*temps);

        x_reel_bruit = filter(h_pb,1,[x_cos_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_reel_bruit = x_reel_bruit((length(h_pb)-1)/2+1:end);
        x_ima_bruit = filter(h_pb,1,[x_sin_bruit zeros(1,(length(h_pb)-1)/2)]);
        x_ima_bruit = x_ima_bruit((length(h_pb)-1)/2+1:end);
        
        x_recomp_bruit = x_reel_bruit - 1i*x_ima_bruit;
    
        %% Filtrage retour
        z_bruit = filter(h_r,1,[x_recomp_bruit zeros(1,(length(h_r)-1)/2)]);
        z_bruit = z_bruit((length(h_r)-1)/2+1:end);
    
        %% Sous echantillonnage
        sym_recu_sousech_bruit = z_bruit(1:Ns:end);
    
        %% Démapping
        bits_reel_recu_bruit = real(sym_recu_sousech_bruit') > 0;
        bits_ima_recu_bruit = imag(sym_recu_sousech_bruit') > 0;
        
        bits_recu_bruit = zeros(1,2*length(bits_reel_recu_bruit));
        bits_recu_bruit(1:2:end) = bits_reel_recu_bruit;
        bits_recu_bruit(2:2:end) = bits_ima_recu_bruit;
        bits_recu_bruit = bits_recu_bruit(:);
        
        
        %% Decodage
        bits_recu_decodes_bruit = step(Hd,bits_recu_bruit);
        
        E_bruit_4(j) = sum(bits_recu_decodes_bruit ~= bits)/n_bits;
    
    %% TEB théorique
    E_theo(j) = qfunc(sqrt(2 * Eb_N0(j)));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%% Comparaison des TEB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = -4:6;
figure(1)
semilogy(k,E_theo)
hold on;
semilogy(k,E_bruit_1)
hold on;
semilogy(k,E_bruit_2)
hold on;
semilogy(k,E_bruit_3)
hold on;
semilogy(k,E_bruit_4)
grid  on;
legend('TEB théorique non codé','TEB simulé non codé','TEB simulé codage comutatif sans poinçonnage',...
    'TEB simulé codage comutatif avec poinçonnage','TEB simulé codage concaténé sans entrelaceur')


