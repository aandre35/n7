function [frequences_triees,indices_frequences_triees] = tri (selection_frequences)
n= length (selection_frequences);
for i=1:(n-1)
    max = i;
    for j=i+1:n
        if selection_frequences(j) > selection_frequences(max)
            max = j;
        end
    end
    if max > i
        x= selection_frequences (i);
        indices_frequences_triees(i) = max;
        selection_frequences (i) = selection_frequences (max);
        selection_frequences (max) = x;
    end
end
frequences_triees = selection_frequences;
end