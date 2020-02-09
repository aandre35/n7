clear all;
close all;

%% II. Chaines de transmission sur fréquence porteuse

%% Implantation d'une chaîne de transmission QPSK sur fréquence porteuse

% Parametres
n = 10000;  % nombre de bits transmis
alpha = 0.35;
fp = 3*10^3;    % fréquence proteuse = 3 kHz
Fe = 10*10^3;   % fréquence d'échantillonage = 10 kHz
Te = 1/Fe;      % période d'échantillonage
Rs = 1*10^3;    % débit symbole = 1 kbauds 
Ts = 1/Rs;      % temps symbole en secondes
Ns = Ts*Fe;     % nombre d'échantillons par symbole

% Génération de 1 suite de bits 0 1 equiprobable dans un vecteur ligne de n elements
bits = randi([0,1],1,n); 

% Séparation en 2 de la suite de bits
bitsak = bits(1:2:end);
bitsbk = bits(2:2:end); 

% Mapping
ak = bitsak*2-1; % remplace les 0 par -1
bk = bitsbk*2-1;
dk = ak+1i*bk;
figure()
subplot(3,3,1)
plot(ak,bk,'*');
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Constellation mapping")
% Suréchantillonnage 
d = kron(dk,[1 zeros(1,Ns-1)]);

% Filtrage de mise en forme
h = rcosdesign(alpha,6,Ns,'sqrt');
retard = (length(h)-1)/2;
x_h = filter(h,1,[d zeros(1,retard)]); % ajout de zero pour retard
x_h = x_h(retard+1:end);

% Puissance du signal
puissance = mean(abs(x_h.^2));


% Filtrage de réception 
hr = fliplr(h); 
x_hr = filter(hr,1,[x_h zeros(1,retard)]);
x_hr = x_hr(retard+1:end);

% % Diagramme de l'oeil pas sur complexe prendre partie reel ou imaginaire
diag_oeil=reshape(real(x_hr), Ns, length(x_hr)/Ns); 

% Echantillonage
t0=1;
x_e = x_hr(t0:Ns:end);
subplot(3,3,2);
plot(real(x_e),imag(x_e),'*');
title("Constellation en sortie de l'echantilloneur")
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);

% Decision
x_reel_recu = sign(real(x_e));
x_im_recu = sign(imag(x_e));
x_recu = x_reel_recu + 1i*x_im_recu;

% TEB sans bruit
erreur = find(x_recu ~= dk);
nbBitsEr = length(erreur);
TEB = nbBitsEr/n;

M = 4; % ordre de modulation
SNR_dB = [0:6];
Eb_N0 = 10.^(SNR_dB/10);
TEB_bruit = zeros(1,7);
Pr = mean(abs(x_h.^(2)));
N= length(x_h);
for i = 1:7
    % Ajout du bruit
    Pb = Pr*Ns/(2*log2(M)*Eb_N0(i));
    nI = sqrt(Pb) * randn(1,N); 
    nQ = sqrt(Pb) * randn(1,N);
    bruit = nI + 1i*nQ;
    x_bruit = x_h + bruit;
       
    %filtrage de réception
    x_hr_bruit = filter(hr,1,[x_bruit zeros(1,retard)]);
    x_hr_bruit = x_hr_bruit(retard+1:end);
    
    % Echantillonage
    x_e_bruit = x_hr_bruit(1:Ns:end);
    subplot(3,3,i+2)
    plot(real(x_e_bruit), imag(x_e_bruit), '*');
    tit = sprintf("SNR_dB = %d", SNR_dB(i));
    title(tit)
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
p = nextpow2(length(x_h));
nfft = 2^p;
Sxp= ((abs(fft(x_h,nfft)))).^2;
Sxp=fftshift(Sxp);
xf=linspace(-Ts/2,Ts/2,nfft);
figure();
semilogy(xf,Sxp)
title("densité spectrale de puissance")
xlabel('kHz')

figure()
%Symboles complexes
subplot(2,3,1)
plot(dk, '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Symboles complexes")

%Enveloppe complexe
subplot(2,3,2)
plot(x_h, '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal après mise en forme")

%Filtre de réception
subplot(2,3,3);
plot(x_hr, '*');
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal réceptionné sans bruit")

%Signal échantilloné sans bruit
subplot(2,3,4)
plot(x_e, '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal échantilloné sans bruit")

%Signal detecte
subplot(2,3,5)
plot(x_recu, '*')
title("Signal detecté bruit")

%phase/quadrature
figure()
subplot(2,1,1)
plot(real(x_h))
title("Signal en phase")
subplot(2,1,2)
plot(imag(x_h))
title("Signal en quadrature")