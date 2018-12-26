function [ L_new , ADJ_new , info_new ] = objects_split( L , ADJ , info , ids , controlled)
L_new = L;
info_new = info;
H = size(L,1);
ids = sort(ids);
n = length(ids);
ys = cell([n,1]);
xs = cell([n,1]);
DL = cell([n,1]);
list = cell([n,1]);
min_y = NaN([n,1]);
max_y = NaN([n,1]);
min_x = NaN([n,1]);
max_x = NaN([n,1]);
for k = 1:n
    [ys{k},xs{k}] = find(L == ADJ.object_labels(ids(k)));
    min_y(k) = min(ys{k});
    max_y(k) = max(ys{k});
    min_x(k) = min(xs{k});
    max_x(k) = max(xs{k});
end
for k = 1:n
    L1 = zeros( [max_y(k)-min_y(k)+1 , max_x(k)-min_x(k)+1]  , class(L) );
    tmp1 = image_xy_2_id( ys{k}-min_y(k)+1 , xs{k}-min_x(k)+1 , max_y(k) - min_y(k) + 1 );
    L1(tmp1) = 1;
    %%
    I6 = L1 > 0;
    D0 = bwdist(~I6);
    if controlled
        tolerance = 0.5;
        D0 = imhmax(D0,tolerance);
    end
    D1 = -D0;
    D1(~I6) = Inf;
    DL{k} = watershed(D1);
    DL{k}(~I6) = 0;
    list{k} = setdiff(unique(DL{k}(:)),[0]);
end
    %%
for k = 1:n
    info_new.erroneous( info.erroneous > ids(k) ) = info_new.erroneous( info.erroneous > ids(k) ) - 1 + length(list{k});
    L_new(L >  ADJ.object_labels(ids(k))) = L_new(L >  ADJ.object_labels(ids(k))) - 1 + length(list{k});
    L_new(L == ADJ.object_labels(ids(k))) = 0;
end
counter = 0;
for k = 1:n
    for i = 1:length(list{k})
        [ys_,xs_] = find(DL{k} == list{k}(i));
        tmp2 = image_xy_2_id(  ys_+ min_y(k) - 1 , xs_ + min_x(k) - 1 , H );
        L_new(tmp2) = ADJ.object_labels(ids(k)) - 1 + i + counter;
    end
    counter = counter + length(list{k}) - 1;
end
ADJ_new = adjacency_calculate(L_new);
[L_new, ADJ_new] = rearrange_labels(L_new , ADJ_new);
end

