function [ diff_1 ] = lineagedisplay_ignore_changes_near_divisions( diff_0 , lineage , daughters , n_before , n_after)
diff_1 = diff_0;
l = length(daughters);
%%
for i = 1:l
    if ~isempty(daughters{i})
        lines = ismember(lineage(:,i) , daughters{i}(:,1));
        diff_1(lines,max(1,i-n_before):min(l,i+n_after)) = NaN;
    end
end
end