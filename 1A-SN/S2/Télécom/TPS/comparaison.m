clear all
close all
%% Comparaison des modules BPSK, QPSK, 8-PSK, 16-QAM
%% 
n=1200;
Ts=4;
Ns = 4;
Te= Ts/Ns;
%% Module BPSK 


%% Modulation
%moyenne nulle, 
%Mise en forme rectangulaire
%filtre de réception de réponse impulsionnelle rectangulaire de durée Ts
figure()
SymbolesMapping = mapping_moyenne_nulle(n);
subplot(3,3,1)
plot(SymbolesMapping, zeros(1,length(SymbolesMapping)), '*');
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal émis")
%Génération de la suite de Diracs pondérés
Suite_diracs = kron(SymbolesMapping, [1 zeros(1, Ns - 1)]);

%Réponse impulsionnelle du filtre de mise en forme (NRZ)
alpha = 0.35;
h = rcosdesign(alpha,10,Ts);
%Filtrage de mise en forme
retard = (length(h)-1)/2;
SignalFiltre_bpsk = filter(h, 1, [Suite_diracs zeros(1,retard)]);
SignalFiltre_bpsk = SignalFiltre_bpsk(1+retard:end);


%% Demodulation

%Filtre de réception

%Réponse impulsionelle
hr = fliplr(h);

%%%cas sans bruit%%%

%Filtrage
z_sans_bruit= filter(hr,1,[SignalFiltre_bpsk zeros(1,retard)]);
z_sans_bruit = z_sans_bruit(1+retard:end);

%Echantilonnage
diag_oeil_bpsk = reshape(z_sans_bruit, 2*Ts, []);
t0= 1;
ze_sans_bruit = z_sans_bruit(t0:Ts:length(z_sans_bruit));

%Décisions - détecteur
seuil = 0;
indices_positifs = (ze_sans_bruit >= seuil);
indices_negatifs = (ze_sans_bruit < seuil);
signal_detecte_sans_bruit_bpsk = zeros(size(ze_sans_bruit));
signal_detecte_sans_bruit_bpsk(indices_positifs) = 1;
signal_detecte_sans_bruit_bpsk(indices_negatifs) = -1;
subplot(3,3,2);
plot(signal_detecte_sans_bruit_bpsk,zeros(length(signal_detecte_sans_bruit_bpsk)), '*')
title("Signal en sortie de l'échantilloneur")

%Démapping
bit_transmis = length(SymbolesMapping);
bit_errone_sans_bruit = sum(ne(signal_detecte_sans_bruit_bpsk, SymbolesMapping));
TEB_bpsk = bit_errone_sans_bruit/bit_transmis;
fprintf("le TEB du signal bpsk sans bruit est: TEB=%0.3e\n",TEB_bpsk)

%%%cas avec bruit%%%


%Ajout du bruit
Pr = mean(abs(SignalFiltre_bpsk).^2);
SNR_dB = linspace(0,6,7);
Eb_N0 = 10.^(SNR_dB/10);
N= length(SignalFiltre_bpsk);
TEB_bruit_bpsk = zeros(1,length(SNR_dB));
M=2;
for i=1:length(SNR_dB)
    %Ajout du bruit
    
    Pb = Pr*Ns/(2*log2(M)*(10^(SNR_dB(i)/10)));
    bruit_gauss = sqrt(Pb) * randn(1,N);
    canal = SignalFiltre_bpsk + bruit_gauss;
        
    %Filtrage
    z_avec_bruit= filter(hr,1,[canal zeros(1,retard)]);
    z_avec_bruit= z_avec_bruit(1+retard:end);
    
    %Echantilonnage
    t0= 1;
    ze_avec_bruit_bpsk = z_avec_bruit(t0:Ts:end);
    subplot(3,3,i+2)
    plot(ze_avec_bruit_bpsk, zeros(1,length(ze_avec_bruit_bpsk)), '*')
    title("Eb/N0 = " + SNR_dB(i)) 
    %Décisions - détecteur
    seuil = 0;  
    
    %Décisions - détecteur
    signal_detecte_avec_bruit = zeros(size(ze_avec_bruit_bpsk));
    indices_positifs = find(ze_avec_bruit_bpsk >= seuil);
    indices_negatifs = find(ze_avec_bruit_bpsk < seuil);
    signal_detecte_avec_bruit(indices_positifs) = 1;
    signal_detecte_avec_bruit(indices_negatifs) = -1;
    
    %Démapping
    bit_errone_avec_bruit = sum(ne(signal_detecte_avec_bruit, SymbolesMapping),2);
    TEB_bruit_bpsk(i) = bit_errone_avec_bruit/bit_transmis;
    %fprintf("le TEB est: TEB=%0.4e\n",TEB_bruit(i));
end;

TEB_theorique_bpsk = qfunc(sqrt(2*10.^(SNR_dB/10)));


%% Module QPSK
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
plot(ak,bk, '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal émis")

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
diag_oeil_qpsk=reshape(real(x_hr), Ns, length(x_hr)/Ns); 

% Echantillonage
t0=1;
x_e = x_hr(t0:Ns:end);

% Decision
x_reel_recu = sign(real(x_e));
x_im_recu = sign(imag(x_e));
z_recu_qpsk = x_reel_recu + 1i*x_im_recu;
subplot(3,3,2)
plot(z_recu_qpsk, '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal detecte sans bruit")

% TEB sans bruit
erreur = find(z_recu_qpsk ~= dk);
nbBitsEr = length(erreur);
TEB_qpsk = nbBitsEr/n;
fprintf("le TEB du signal qpqk sans bruit est: TEB=%0.3e\n",TEB_qpsk)

M = 4; % ordre de modulation
SNR_dB = [0:6];
Eb_N0 = 10.^(SNR_dB/10);
TEB_bruit_qpsk = zeros(1,7);
Pr = mean(abs(x_h.^(2)));
for i = 1:7
    % Ajout du bruit
    Pb = Pr*Ns/(2*log2(M)*Eb_N0(i));
    nI = sqrt(Pb)*randn(1,n*Ns/2);
    nQ = sqrt(Pb)*randn(1,n*Ns/2);
    bruit = nI + 1i*nQ;
    x_bruit = x_h + bruit;
       
    %filtrage de réception
    x_hr_bruit = filter(hr,1,[x_bruit zeros(1,retard)]);
    x_hr_bruit = x_hr_bruit(retard+1:end);
    
    % Echantillonage
    x_e_bruit = x_hr_bruit(1:Ns:end);
    subplot(3,3,i+2)
    plot(real(x_e_bruit), imag(x_e_bruit), '*')
    title("Eb/N0 = " + SNR_dB(i))
    
    % Decision
    x_reel_recu_bruit = sign(real(x_e_bruit));
    x_im_recu_bruit = sign(imag(x_e_bruit));
    x_recu_bruit = x_reel_recu_bruit + 1i*x_im_recu_bruit;

   
    % TEB
    erreur_bruit = find(x_recu_bruit ~= dk);
    nbBitsEr_bruit = length(erreur_bruit);
    TEB_bruit_qpsk(i) = nbBitsEr_bruit/n;
end
TEB_theorique_qpsk = qfunc(sqrt(2*10.^(SNR_dB/10)));


%% Module 8-PSK

%% Modulation
%moyenne nulle, 
%Mise en forme rectangulaire
%filtre de réception de réponse impulsionnelle rectangulaire de durée Ts

bits = randi([0,1],1,n); 
X = reshape(bits, length(bits)/3, 3);
map = bi2de(X);
M = 8; % Nombre de symboles
Symboles = pskmod(map, M, pi/M,'gray'); 
figure()
subplot(3,3,1)
plot(real(Symboles), imag(Symboles), '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal émis")

%Génération de la suite de Diracs pondérés
Suite_diracs = kron(Symboles.', [1 zeros(1, Ts - 1)]);

%Réponse impulsionnelle du filtre de mise en forme (NRZ)
alpha = 0.35;
h = rcosdesign(alpha,6,Ts,'sqrt');
%Filtrage de mise en forme
retard = (length(h)-1)/2;
SignalFiltre_8psk = filter(h, 1, [Suite_diracs zeros(1, retard)]);
SignalFiltre_8psk = SignalFiltre_8psk(retard+1:end);


%% Demodulation

%Filtre de réception

%Réponse impulsionelle
hr = fliplr(h);

%%%cas sans bruit%%%

%Filtrage
z_sans_bruit= filter(hr,1,[SignalFiltre_8psk zeros(1,retard)]);
z_sans_bruit = z_sans_bruit(1+retard:end);

%Echantilonnage
diag_oeil_8psk = reshape(real(z_sans_bruit), Ns, length(z_sans_bruit)/Ns);
t0= 1;
ze_sans_bruit = z_sans_bruit(t0:Ts:length(z_sans_bruit));

%Décisions - détecteur

z_detecte = pskdemod(ze_sans_bruit, M, pi/M,'gray');
subplot(3,3,2)
plot(real(z_detecte), imag(z_detecte), '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal détecté sans bruit")
Y = de2bi(z_detecte.');

% Mapping inverse
bits_detecte = reshape(Y,1,n);

% TEB sans bruit

%Démapping
bit_transmis = length(SymbolesMapping);
bit_errone_sans_bruit = sum(ne(bits_detecte, bits));
TEB_8psk = bit_errone_sans_bruit/bit_transmis;
fprintf("le TEB du signal 8-PSK sans bruit est: TEB=%0.3e\n",TEB_8psk)

%%%cas avec bruit%%%


%Ajout du bruit
Pr = mean(abs(SignalFiltre_8psk).^2);
SNR_dB = linspace(0,6,7);
N= length(SignalFiltre_8psk);
TEB_bruit_8psk = zeros(1,length(SNR_dB));
TEB_theorique_8psk = zeros(1,length(SNR_dB));
M=8;
for i=1:length(SNR_dB)
    %Ajout du bruit
    
    Pb = Pr*Ns/(2*log2(M)*(10^(SNR_dB(i)/10)));
    nI = sqrt(Pb) * randn(1,N); 
    nQ = sqrt(Pb) * randn(1,N);
    bruit = nI + 1i*nQ;
    canal = SignalFiltre_8psk + bruit;
        
    %Filtrage
    z_avec_bruit= filter(hr,1,[canal zeros(1,retard)]);
    z_avec_bruit= z_avec_bruit(1+retard:end);
    
    %Echantilonnage
    t0= 1;
    ze_avec_bruit_8psk = z_avec_bruit(t0:Ts:end);
    subplot(3,3,i+2)
    plot(real(ze_avec_bruit_8psk), imag(ze_avec_bruit_8psk),'*')
    title("Eb/N0 = " + SNR_dB(i))
    %Décisions - détecteur

    z_detecte = pskdemod(ze_avec_bruit_8psk, M, pi/M,'gray');
    Y = de2bi(z_detecte.');

    % Mapping inverse
    bits_detecte = reshape(Y,1,n);
       
    %Démapping
    bit_errone_avec_bruit = sum(ne(bits_detecte, bits),2);
    TEB_bruit_8psk(i) = bit_errone_avec_bruit/bit_transmis;
    %fprintf("le TEB est: TEB=%0.4e\n",TEB_bruit(i));
end;

TEB_theorique_8psk = (2*qfunc(sqrt(2*Eb_N0*log2(M))*sin(pi/M)))/log2(M); 
%TEB_theorique_8psk = 2*qfunc(sqrt(2*Eb_N0*sin(pi/M))); 


%% Module 16-QAM

%% Modulation
%moyenne nulle, 
%Mise en forme rectangulaire
%filtre de réception de réponse impulsionnelle rectangulaire de durée Ts

X=reshape(bits,length(bits)/4,4);
M=16;
map=bi2de(X);
Symboles=qammod(map,M,'gray');
figure()
subplot(3,3,1)
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
plot(real(Symboles), imag(Symboles), '*')
title("Signal émis")

%Génération de la suite de Diracs pondérés
Suite_diracs=kron(Symboles.', [1 zeros(1,Ts-1)]);

%Réponse impulsionnelle du filtre de mise en forme (NRZ)
alpha = 0.35;
h = rcosdesign(alpha,6,Ts,'sqrt');
%Filtrage de mise en forme
retard = (length(h)-1)/2;
SignalFiltre_16qam = filter(h, 1, [Suite_diracs zeros(1,retard)]);
SignalFiltre_16qam = SignalFiltre_16qam(1+retard:end);


%% Demodulation

%Filtre de réception

%Réponse impulsionelle
hr = fliplr(h);

%%%cas sans bruit%%%

%Filtrage
z_sans_bruit= filter(hr,1,[SignalFiltre_16qam zeros(1,retard)]);
z_sans_bruit = z_sans_bruit(1+retard:end);

%Echantilonnage
diag_oeil_16qam = reshape(real(z_sans_bruit), Ns, length(z_sans_bruit)/Ns);
t0= 1;
ze_sans_bruit = z_sans_bruit(t0:Ts:length(z_sans_bruit));

%Décisions - détecteur
%Démapping
z_recu_qam = qamdemod(ze_sans_bruit, M,'gray');
subplot(3,3,2)
plot(real(z_recu_qam), imag(z_recu_qam), '*')
xlim([-1.25,1.25]);
ylim([-1.25,1.25]);
title("Signal recu sans bruit")
Y = de2bi(z_recu_qam); 
bits_recu = reshape(Y,1,n);
bit_transmis = length(SymbolesMapping);
bit_errone_sans_bruit = sum(ne(bits_recu, bits));
TEB_16qam = bit_errone_sans_bruit/bit_transmis;
fprintf("le TEB du signal 16-QAM sans bruit est: TEB=%0.3e\n",TEB_16qam)

%%%cas avec bruit%%%

%Ajout du bruit
Pr = mean(abs(SignalFiltre_16qam).^2);
SNR_dB = linspace(0,6,7);
N= length(SignalFiltre_16qam);
TEB_bruit_16qam = zeros(1,length(SNR_dB));
M=16;
for i=1:length(SNR_dB)
    %Ajout du bruit
    
    Pb = Pr*Ns/(2*log2(M)*(10^(SNR_dB(i)/10)));
    nI = sqrt(Pb) * randn(1,N); 
    nQ = sqrt(Pb) * randn(1,N);
    bruit = nI + 1i*nQ;
    canal = SignalFiltre_16qam + bruit;
        
    %Filtrage
    z_avec_bruit= filter(hr,1,[canal zeros(1,retard)]);
    z_avec_bruit= z_avec_bruit(1+retard:end);
    
    %Echantilonnage
    t0= 1;
    ze_avec_bruit_16qam = z_avec_bruit(t0:Ts:end);
    subplot(3,3,i+2)
    plot(ze_avec_bruit_16qam,'*')
    title("Eb/N0 = " + SNR_dB(i))
    %Décision
    %Démapping
    z_recu_qam = qamdemod(ze_avec_bruit_16qam,M,'gray');  
    Y = de2bi(z_recu_qam);
    bits_recu = reshape(Y,1,n);
    bit_errone_avec_bruit = sum(ne(bits_recu, bits),2);
    TEB_bruit_16qam(i) = bit_errone_avec_bruit/bit_transmis;
    %fprintf("le TEB est: TEB=%0.4e\n",TEB_bruit(i));
end;

TEB_theorique_16qam =(4*(1-1/sqrt(M))*qfunc(sqrt((3*log2(M)*Eb_N0)/(M-1))))/log2(M);


%% Tracé des graphique

%Les diagrammes de l'oeils
figure()
subplot(2,2,1)
plot(diag_oeil_bpsk);
title("BPSK")

subplot(2,2,2)
plot(diag_oeil_qpsk)
title("QPSK")

subplot(2,2,3)
plot(diag_oeil_8psk)
title("8-PSK")

subplot(2,2,4)
plot(diag_oeil_16qam)
title("16-QAM")

%Les TEB reçues/théoriques
figure()
subplot(2,2,1)
semilogy(SNR_dB, TEB_bruit_bpsk, '*');
hold on;
semilogy(SNR_dB, TEB_theorique_bpsk,'r');
legend("TEB calculé", "TEB théorique");
xlabel("Eb/N0 en dB")
ylabel("TEB")
title("BPSK");

subplot(2,2,2)
semilogy(SNR_dB, TEB_bruit_qpsk, '*');
hold on;
semilogy(SNR_dB, TEB_theorique_qpsk,'r');
legend("TEB calculé", "TEB théorique");
xlabel("Eb/N0 en dB")
ylabel("TEB")
title("QPSK");

subplot(2,2,3)
semilogy(SNR_dB, TEB_bruit_8psk, '*');
hold on;
semilogy(SNR_dB, TEB_theorique_8psk,'r');
legend("TEB calculé", "TEB théorique");
xlabel("Eb/N0 en dB")
ylabel("TEB")
title("8-PSK");

subplot(2,2,4)
semilogy(SNR_dB, TEB_bruit_16qam, '*');
hold on;
semilogy(SNR_dB, TEB_theorique_16qam,'r');
legend("TEB calculé", "TEB théorique");
xlabel("Eb/N0 en dB")
ylabel("TEB")
title("16-QAM");

%Efficacité spectrale
% figure()
% p = nextpow2(length(SignalFiltre_bpsk));
% nfft = 2^p;
% Sxp= ((abs(fft(SignalFiltre_bpsk,nfft)))).^2;
% Sxp=fftshift(Sxp);
% xf=linspace(-Ts/2,Ts/2,nfft);
% semilogy(xf,Sxp)
% title("BPSK")
% xlabel('kHz')
% 
% 
% figure
% p = nextpow2(length(x_h));
% nfft = 2^p;
% Sxp= ((abs(fft(x_h,nfft)))).^2;
% Sxp=fftshift(Sxp);
% xf=linspace(-Ts/2,Ts/2,nfft);
% semilogy(xf,Sxp)
% 
% title("QPSK");

figure
p = nextpow2(length(SignalFiltre_8psk));
nfft = 2^p;
Sxp= ((abs(fft(SignalFiltre_8psk,nfft)))).^2;
Sxp=fftshift(Sxp);
xf=linspace(-Ts/2,Ts/2,nfft);
semilogy(xf,Sxp)

title("QPSK");

% figure
% p = nextpow2(length(SignalFiltre_16qam));
% nfft = 2^p;
% Sxp= ((abs(fft(SignalFiltre_16qam,nfft)))).^2;
% Sxp=fftshift(Sxp);
% xf=linspace(-Ts/2,Ts/2,nfft);
% semilogy(xf,Sxp)
% title("16-QAM");


%Efficacité en puissance
figure
TEBs = [TEB_bruit_bpsk; TEB_bruit_qpsk; TEB_bruit_8psk; TEB_bruit_16qam]
semilogy(SNR_dB, TEBs);
legend("TEB BPSK", "TEB QPSK", "TEB 8PSK", "TEB 16QAM");
xlabel("Eb/N0 en dB")
ylabel("TEB")