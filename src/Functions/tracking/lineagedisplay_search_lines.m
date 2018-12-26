function lines = lineagedisplay_search_lines(lineage)
[nl,~] = size(lineage);
lines = NaN([0,8]);
i = 1;
while i <= nl
    k = find(lineage(i,:) ~= 0 , 1);
    if isempty(k)
        i = i+1;
    else
        ls = find(lineage(:,k) == lineage(i,k));
        lines = [ lines ; heatmap_search_lines_recursive( lineage , ls , k ) ];
        i = max(ls) + 1;
    end
end
end
%%
function lines = heatmap_search_lines_recursive(mat , rs , c)
lines = NaN([0,8]);
[~,nf] = size(mat);
j = c+1;
while j <= nf && length(setdiff(unique(mat(rs,j)),0)) == 1
    j = j+1;
end
lines = [lines ; c-0.5 j-0.5 mean(rs) mean(rs) c j-1 min(rs) max(rs)];
if j <= nf
    nextids = unique(mat(rs,j));
    if length(nextids) == 2
        n1 = nextids(1);
        n2 = nextids(2);
        lines = [lines ; j-0.5 j-0.5 mean(find(n1 == mat(:,j))) mean(find(n2 == mat(:,j))) NaN NaN NaN NaN];
        lines = [lines ; heatmap_search_lines_recursive(mat,find(mat(:,j)==n1),j)];
        lines = [lines ; heatmap_search_lines_recursive(mat,find(mat(:,j)==n2),j)];
    end
end
end