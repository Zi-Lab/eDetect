function [ L_new , ADJ_new , info_new] = objects_merge( L , ADJ , info , ids )
[h,w] = size(L);
L_new = L;
ADJ_new = ADJ;
info_new = info;
if length(ids)<=1
    return;
end
id1 = min(ids);
aaa = ADJ.object_labels(id1);
for i = 1:length(ids)
    L_new(L == ADJ.object_labels(ids(i))) = aaa;
end
for i = 1:length(ids)
    for j = 1:length(ids)
        if ADJ.is_adjacent(ids(i),ids(j))
            temp0 = (ADJ.pair_objectids(:,1) == ids(i) & ADJ.pair_objectids(:,2) == ids(j))  |  (ADJ.pair_objectids(:,1) == ids(j) & ADJ.pair_objectids(:,2) == ids(i));
            temp1 = false(size(L));
            temp1(ADJ.pair_borders{temp0}) = true;
            L_new(temp1) = aaa;
            [ys,xs] = find(temp1);
            for k = 1:length(ys)
                y = ys(k);
                x = xs(k);
                if y - 1 >= 1
                    if L_new(y-1,x) ~= 0 && L_new(y-1,x) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
                if y + 1 <= h
                    if L_new(y+1,x) ~= 0 && L_new(y+1,x) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
                if x - 1 >= 1
                    if L_new(y,x-1) ~= 0 && L_new(y,x-1) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
                if x + 1 <= w
                    if L_new(y,x+1) ~= 0 && L_new(y,x+1) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
                if y - 1 >= 1 && x - 1 >= 1
                    if L_new(y-1,x-1) ~= 0 && L_new(y-1,x-1) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
                if y - 1 >= 1 && x + 1 <= w
                    if L_new(y-1,x+1) ~= 0 && L_new(y-1,x+1) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
                if y + 1 <= h && x - 1 >= 1
                    if L_new(y+1,x-1) ~= 0 && L_new(y+1,x-1) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
                if y + 1 <= h && x + 1 <= w
                    if L_new(y+1,x+1) ~= 0 && L_new(y+1,x+1) ~= aaa
                        L_new(y,x) = 0;
                        continue;
                    end
                end
            end
        end
    end
end
%%
[ ADJ_new ] = adjacency_update( ADJ, L_new, ids );
%%
id2 = setdiff(ids,id1);
l = length(id2);
if ~isempty(info)
    for i = l:(-1):1
        info_new.erroneous( info_new.erroneous > id2(i) ) = info_new.erroneous( info_new.erroneous > id2(i) ) - 1;
    end
end
%%
[L_new, ADJ_new] = rearrange_labels(L_new , ADJ_new);
end

