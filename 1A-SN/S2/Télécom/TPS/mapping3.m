clear all;
close all;
n=10000;
Ts=4;
Ns = 4;
Te= Ts/Ns;

%% 
%% Génération du 3ème Mapping:
%% 

%% Modulation
%moyenne nulle, 
%Mise en forme rectangulaire
%filtre de réception de réponse impulsionnelle rectangulaire de durée Ts

SymbolesMapping =  2*randi([0, 1], 1, n) - ones(1,n);

%Génération de la suite de Diracs pondérés
Suite_diracs = kron(SymbolesMapping, [1 zeros(1, Ns - 1)]);

%Réponse impulsionnelle du filtre de mise en forme (NRZ)
h= ones(1, Ts);

%Filtrage de mise en forme
SignalFiltre = filter(h, 1, Suite_diracs);



%% Demodulation

%Filtre de réception

%Réponse impulsionelle
hr = ones(1,Ts/2);

%%%cas sans bruit%%%

%Filtrage
z_sans_bruit= filter(hr,1,SignalFiltre);

%Echantilonnage
diagramme_oeil_sans_bruit = reshape(z_sans_bruit, 2*Ts, []);
t0= Ts/2;
ze_sans_bruit = z_sans_bruit(t0:Ts:end);

%Décisions - détecteur
seuil = 0;
indices_positifs = (ze_sans_bruit >= seuil);
indices_negatifs = (ze_sans_bruit < seuil);
signal_detecte_sans_bruit = zeros(size(ze_sans_bruit));
signal_detecte_sans_bruit(indices_positifs) = 1;
signal_detecte_sans_bruit(indices_negatifs) = -1;

%Démapping
bit_transmis = length(SymbolesMapping);
bit_errone_sans_bruit = sum(ne(signal_detecte_sans_bruit, SymbolesMapping));
TEB_sans_bruit = bit_errone_sans_bruit/bit_transmis;
fprintf("le TEB du signal sans bruit est: TEB=%0.3e\n",TEB_sans_bruit)

%%%cas avec bruit%%%


%Ajout du bruit
Pr = mean(abs(SignalFiltre).^2);
SNR_dB = linspace(0,6,7);
N = length(SignalFiltre);
TEB_bruit = zeros(1,length(SNR_dB));
M=2;
for i=1:length(SNR_dB)
    %Ajout du bruit
    Pb = Pr*Ns/(2*log2(M)*(10^(SNR_dB(i)/10)));
    
    bruit_gauss = sqrt(Pb) * randn(1,N);
    canal = SignalFiltre + bruit_gauss;
    %Filtrage
    z_avec_bruit= filter(hr,1,canal);
    %Echantilonnage
    t0= Ts;
    ze_avec_bruit = z_avec_bruit(t0:Ts:end);
    %Décisions - détecteur
    seuil = 0;    
    %Décisions - détecteur
    signal_detecte_avec_bruit = zeros(size(ze_avec_bruit));
    indices_positifs = (ze_avec_bruit >= seuil);
    indices_negatifs = (ze_avec_bruit < seuil);
    signal_detecte_avec_bruit(indices_positifs) = 1;
    signal_detecte_avec_bruit(indices_negatifs) = -1;
    %Démapping
    bit_errone_avec_bruit = sum(ne(signal_detecte_avec_bruit, SymbolesMapping));
    TEB_bruit(i) = bit_errone_avec_bruit/bit_transmis;
    %fprintf("le TEB est: TEB=%0.4e\n",TEB_Signal_recu_avec_bruit(i));
end;

TEB_theorique = qfunc(sqrt(10.^(SNR_dB/10)));
%% Tracé des graphiques

%1er Mapping
figure(1);

subplot(3,3,1);
plot(SymbolesMapping);
title('Symboles 1er Mapping');

subplot(3,3,2);
plot(SignalFiltre);
title('Signal après filtrage de mise en forme');

subplot(3,3,3);
plot(canal);
title('Ajout du bruit');

subplot(3,3,4);
plot(diagramme_oeil_sans_bruit);
title("Diagramme de l'oeil sans bruit");

subplot(3,3,5);
plot(ze_sans_bruit);
title("Signal échantilloné sans bruit");

subplot(3,3,6);
plot(ze_avec_bruit);
title("Signal échantilloné avec bruit");

subplot(3,3,7);
plot(signal_detecte_sans_bruit);
title("Signal détecté sans bruit");

subplot(3,3,8);
plot(signal_detecte_avec_bruit);
title("Signal détecté avec bruit");

figure(2);

loglog(SNR_dB, TEB_bruit, '*'); hold on;
loglog(SNR_dB, TEB_theorique);
xlabel('SNR dB');
ylabel('TEB');
legend('TEB calculé', 'TEB théorique');
title("Mapping 3: TEB théorique et TEB calculé");

figure()
plot(diagramme_oeil_sans_bruit)
title("Mapping 3: diagramme de l'oeil")

%Densité spectrale de puissance
Y = fft(SignalFiltre);
N = length(SignalFiltre);
DSPS = (1/N)*(abs(Y)).^2;
f = [-N/2:N/2]/(N*Ts);
f = f([1:length(f)-1]);
figure(3);
semilogy(f,fftshift(DSPS));
xlabel('frequence (Hz)');
ylabel('DSP');
title('Sx(f) - Chaine 3');