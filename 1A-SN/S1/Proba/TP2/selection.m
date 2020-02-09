function [selection_frequences,selection_alphabet] = selection(frequences, alphabet)
indices = find (frequences > 0);
for i=1:length(indices)
    selection_frequences(i) = frequences(indices(i));
    selection_alphabet(i) = alphabet (indices(i));
end
end