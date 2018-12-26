function [L_new, ADJ_new] = rearrange_labels(L , ADJ)
L_new = L;
ADJ_new = ADJ;
labels = setdiff(unique(L_new),0);
for i = 1:length(labels)
    if labels(i) ~= i
        L_new(L_new == labels(i)) = i;
        ADJ_new.object_labels(i) = i;
    end
end
end

