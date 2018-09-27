function [ L_new , ADJ_new, info_new] = objects_split( L , ADJ , info , ids , controlled)
L_new = L;
ADJ_new = ADJ;
info_new = info;
if length(ids) ~= 1
    return;
end
%%
[ys,xs] = find(L == ADJ.object_labels(ids));
min_y = min(ys);
max_y = max(ys);
min_x = min(xs);
max_x = max(xs);
L1 = zeros( [max_y-min_y+1 , max_x-min_x+1]  , class(L) );
for i = 1:length(ys)
    L1( ys(i)-min_y+1 , xs(i)-min_x+1 ) = 1;
end
%%
I6 = L1 > 0;
D0 = bwdist(~I6);
if controlled
    tolerance = 0.5;
    D0 = imhmax(D0,tolerance);
end
D1 = -D0;
D1(~I6) = Inf;
DL = watershed(D1);
DL(~I6) = 0;
list = setdiff(unique(DL(:)),[0]);
%%
L_new(L >  ADJ.object_labels(ids)) = L_new(L >  ADJ.object_labels(ids)) - 1 + length(list);
L_new(L == ADJ.object_labels(ids)) = 0;
for i = 1:length(list)
    [ys_,xs_] = find(DL == list(i));
    for j = 1:length(ys_)
        L_new(ys_(j)+min_y-1,xs_(j)+min_x-1) = ADJ.object_labels(ids) - 1 + i;
    end
end
ADJ_new = adjacency_calculate(L_new);
%%
info_new.erroneous( info.erroneous > ids ) = info_new.erroneous( info.erroneous > ids ) - 1 + length(list);
%%
[L_new, ADJ_new] = rearrange_labels(L_new , ADJ_new);
end

