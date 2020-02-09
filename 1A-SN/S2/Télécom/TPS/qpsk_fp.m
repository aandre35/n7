clear all;
close all;

%% II. Chaines de transmission sur fréquence porteuse

%% Implantation d'une chaîne de transmission QPSK sur fréquence porteuse

% Parametres
n = 100;  % nombre de bits transmis
alpha = 0.35;
fp = 3*10^3;    % fréquence proteuse = 3 kHz
Fe = 10*10^3;   % fréquence d'échantillonage = 10 kHz
Te = 1/Fe;      % période d'échantillonage
Rs = 1*10^3;    % débit symbole = 1 kbauds 
Ts = 1/Rs;      % temps symbole en secondes
Ns = Ts*Fe;     % nombre d'échantillons par symbole
temps= 0:Ns*n/2-1;

% Génération de 1 suite de bits 0 1 equiprobable dans un vecteur ligne de n elements
bits = randi([0,1],1,n); 

% Séparation en 2 de la suite de bits
bitsak = bits(1:2:end);
bitsbk = bits(2:2:end); 

% Mapping
ak = bitsak*2-1; % remplace les 0 par -1
bk = bitsbk*2-1;
dk = ak+1i*bk;

% Suréchantillonnage 
d = kron(dk,[1 zeros(1,Ns-1)]);

% Filtrage de mise en forme
h = rcosdesign(alpha,6,Ns,'sqrt');
retard = (length(h)-1)/2;
x_h = filter(h,1,[d zeros(1,retard)]); % ajout de zero pour retard
x_h = x_h(retard+1:end);

% Transposition de fréquence
x_h_exp = x_h.*exp(1i*2*pi*fp/Fe*temps); 
x = real(x_h_exp);

% Puissance du signal
puissance = mean(abs(x).^2)

% Retour en bande de base
x_cos = x.*cos(2*pi*fp/Fe*temps);
x_sin = x.*sin(2*pi*fp/Fe*temps);
%filtre passe-bas
Fc=fp/2;
ordre = 31;
retard_pb = (ordre-1)/2;
hPB = 2*Fc/Fe*sinc (2*Fc*[-retard_pb*Te:Te: retard_pb*Te]); % filtre passe bas
x_cos_PB = filter(hPB,1, [x_cos zeros(1, retard_pb)]);
x_cos_PB = x_cos_PB(retard_pb+1:end);
x_sin_PB = filter(hPB,1, [x_sin zeros(1,retard_pb)]);
x_sin_PB = x_sin_PB(retard_pb+1:end);
x_BB = x_cos_PB - 1i*x_sin_PB;

% Filtrage de réception 
hr = fliplr(h); 
x_hr = filter(hr,1,[x_BB zeros(1,retard)]);
x_hr = x_hr(retard+1:end);

% % Diagramme de l'oeil pas sur complexe prendre partie reel ou imaginaire
diag_oeil=reshape(real(x_hr), Ns, length(x_hr)/Ns); 

% Echantillonage
t0=1;
x_e = x_hr(t0:Ns:end);

% Decision
x_reel_recu = sign(real(x_e));
x_im_recu = sign(imag(x_e));
x_recu = x_reel_recu + 1i*x_im_recu;

% TEB sans bruit
erreur = find(x_recu ~= dk);
nbBitsEr = length(erreur);
TEB = nbBitsEr/n

M = 4; % ordre de modulation
SNR_dB = [0:6];
Eb_N0 = 10.^(SNR_dB/10);
TEB_bruit = zeros(1,7);
Pr = mean(abs(x.^(2)));
for i = 1:7
    % Ajout du bruit
    Pb = Pr*Ns/(2*log2(M)*Eb_N0(i));
    bruit = sqrt(Pb)*randn(1,n*Ns/2);
    x_bruit = x + bruit;
    
    % Retour en bande de base
    x_cos_bruit = x_bruit.*cos(2*pi*fp/Fe*temps);
    x_sin_bruit = x_bruit.*sin(2*pi*fp/Fe*temps);
    
    %filtres passe-bas
    x_cos_PB_bruit = filter(hPB,1, [x_cos_bruit zeros(1, retard_pb)]);
    x_cos_PB_bruit = x_cos_PB_bruit(retard_pb+1:end);
    x_sin_PB_bruit = filter(hPB,1, [x_sin_bruit zeros(1,retard_pb)]);
    x_sin_PB_bruit = x_sin_PB_bruit(retard_pb+1:end);
    x_BB_bruit = x_cos_PB_bruit - 1i*x_sin_PB_bruit;
    
    %filtrage de réception
    x_hr_bruit = filter(hr,1,[x_BB_bruit zeros(1,retard)]);
    x_hr_bruit = x_hr_bruit(retard+1:end);
    
    % Echantillonage
    x_e_bruit = x_hr_bruit(1:Ns:end);
    
    % Decision
    x_reel_recu_bruit = sign(real(x_e_bruit));
    x_im_recu_bruit = sign(imag(x_e_bruit));
    x_recu_bruit = x_reel_recu_bruit + 1i*x_im_recu_bruit;

    % TEB
    erreur_bruit = find(x_recu_bruit ~= dk);
    nbBitsEr_bruit = length(erreur_bruit);
    TEB_bruit(i) = nbBitsEr_bruit/n;
end
TEB_theorique = qfunc(sqrt(2*10.^(SNR_dB/10)));


%% Tracé des graphiques

%Signal en quadrature et en phase
figure()
subplot(3,1,1)
plot(x_cos)
title("Signal en phase")
subplot(3,1,2)
plot(x_sin)
title("Signal en quadrature")
subplot(3,1,3)
plot(x)
title("Signal sur fréquence porteuse")

%Diagramme de l'oeil
figure()
plot(diag_oeil);
title("Diagramme de l'oeil")

% Trace de TEB en fonction de SNR
figure();
semilogy(SNR_dB, TEB_bruit, '*');
hold on;
semilogy(SNR_dB, TEB_theorique,'r');
legend("TEB calculé", "TEB théorique");
xlabel("Eb/N0 en dB")
ylabel("TEB")
title("TEB théorique vs. TEB calculé");

%Densité spectrale de puissance
p = nextpow2(length(x));
nfft = 2^p;
Sxp= ((abs(fft(x,nfft)))).^2;
Sxp=fftshift(Sxp);
xf=linspace(-Ts/2,Ts/2,nfft);
figure();
semilogy(xf,Sxp)
title("densité spectrale de puissance")
xlabel('kHz')

figure()
%Symboles complexes
subplot(3,3,1)
plot(dk, '*')
title("Symboles complexes")

%Enveloppe complexe
subplot(3,3,2)
plot(x_h)
title("Signal après mise en forme")

%Transposition de fréquence
subplot(3,3,3)
plot(x_h_exp)
title("Partie réel du signal transposé")

%Signal après passage dans les filtres
subplot(3,3,4)
plot(x_BB);
title("Signal après passage dans les deux filtres")

%Filtre de réception
subplot(3,3,5);
plot(x_hr);
title("Signal réceptionné sans bruit")

%Signal échantilloné sans bruit
subplot(3,3,6)
plot(x_e)
title("Signal échantilloné sans bruit")

%Signal detecte
subplot(3,3,7)
plot(x_recu, '*')
title("Signal detecté bruit")
