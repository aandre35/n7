function [frequences] = calcul_frequences (texte, alphabet)
frequences = zeros (128);
for i= 1:length (texte)
    indice = find(alphabet == texte(i));
    frequences (indice) = frequences (indice) + 1;
end
for i= 1:length (frequences)
    frequences(i) = frequences(i)/length(texte);
end
