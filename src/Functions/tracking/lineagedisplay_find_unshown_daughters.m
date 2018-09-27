function unshown_daughters = lineagedisplay_find_unshown_daughters(lineage , daughters )
[~,nt] = size(lineage);
unshown_daughters = cell(size(daughters));
for i = 1:nt
    if ~isempty(daughters{i})
        list = unique(daughters{i}(:,2));
        for p = list'
            ds = daughters{i}(daughters{i}(:,2)==p,1);
            if ~all(ismember(ds,lineage(:,i)))
                unshown_daughters{i} = [unshown_daughters{i}; ds];
            end
        end    
    end
end
end

