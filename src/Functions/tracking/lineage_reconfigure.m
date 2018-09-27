function new_lineage = lineage_reconfigure(lineage , t , track)
new_lineage = lineage;
for i = t:min(t+1,length(track))
    for j = 1:length(track{i})
        [ new_lineage ]  = lineage_edit( new_lineage , i , j , track{i}(j) );
    end
end
for i = t:min(t+1,length(track))
    [ new_lineage ]  = lineage_clean( new_lineage , i   , length(track{i}) );
end
end

