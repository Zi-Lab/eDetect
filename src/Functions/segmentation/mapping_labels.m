function [mapping , unmapped_centroids] = mapping_labels( L1 , L2 )
labels1 = setdiff(unique(L1),0);
for i = 1:length(labels1)
    if labels1(i) ~= i
        L1(L1 == labels1(i)) = i;
    end
end
labels2 = setdiff(unique(L2),0);
for i = 1:length(labels2)
    if labels2(i) ~= i
        L2(L2 == labels2(i)) = i;
    end
end
%%
vec1 = double(L1(:));
vec2 = double(L2(:));
n1 = max(vec1)+1;
n2 = max(vec2)+1;
%%
intersection = hist3( [vec1 vec2] , 'Nbins' , [n1 n2]);
area1 = repmat(histcounts(vec1,n1)',1,n2);
area2 = repmat(histcounts(vec2,n2) ,n1,1);
union = area1 + area2 - intersection;
union = union(2:end,2:end);
intersection = intersection(2:end,2:end);
%%
[ l1 , l2 ] = find(intersection == union & intersection > 0 );
mapping = [l1 l2];
%%
centroids1 = table2array( regionprops( 'table', L1, 'Centroid' ) );
centroids2 = table2array( regionprops( 'table', L2, 'Centroid' ) );
%%
unmapped_centroids = [ centroids1( setdiff( 1:size(centroids1,1), mapping(:,1)) , : )  ;  centroids2( setdiff(1:size(centroids2,1),mapping(:,2) ) , :) ];
end

