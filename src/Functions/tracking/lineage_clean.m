function [ newlineage ]  = lineage_clean( lineage , t , l )
newlineage = lineage;
[~,nt] = size(newlineage);
if t < 1 || t > nt
    return;
end
filt = newlineage(:,t) <= l;
newlineage = newlineage(filt,:);
end

