function [ newlineage ]  = lineage_clean( lineage , t , l )
newlineage = lineage;
[~,nt] = size(newlineage);
if t < 1 || t > nt
    return;
end
keep = find(newlineage(:,t) <= l);
del = find(newlineage(:,t) > l);
final = [];
for i = del'
    if isempty( intersect( newlineage(keep,1:t-1) , newlineage(i,1:t-1) ,'rows'   ))
        newlineage(i,t) = 0;
    else
        final = [final;i];
    end
end
newlineage(final,:) = [];
end

