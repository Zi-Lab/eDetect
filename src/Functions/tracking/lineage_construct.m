function [ lineage ] = lineage_construct( track )
nt = length(track);
ntracks = 0;
lineage = zeros([ntracks,nt]);
visited = cell([nt,1]);
for i = 1:nt
    visited{i} = zeros([size(track{i},1),1]);
end
for i = nt:(-1):1
    l = length(visited{i});
    for j = l:(-1):1
        if visited{i}(j) == 0
            lineage = [lineage ; zeros([1,nt])];
            ntracks = ntracks + 1;
            k = j;
            ii = i;
            while ii > 0
                lineage(ntracks,ii) = k;
                visited{ii}(k) = 1;
                if track{ii}(k,1) > 0
                    k = track{ii}(k,1);
                    ii = ii - 1;
                else
                    break;
                end
            end
        end
    end
end
end