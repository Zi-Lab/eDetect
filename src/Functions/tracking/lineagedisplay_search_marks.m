function marks = lineagedisplay_search_marks( lineage , daughters )
[~,nt] = size(lineage);
marks = NaN([0,4]);
for i = 1:nt
    if ~isempty(daughters{i})
        list = find(ismember(lineage(:,i),daughters{i}(:,1)));
        for j = 1:length(list)
            marks = [marks; i-0.5 i-0.5 list(j)-0.5 list(j)+0.5];
        end
    end
end
end

