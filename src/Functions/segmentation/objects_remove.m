function [ L_new , ADJ_new , info_new ] = objects_remove( L , ADJ , info , ids )
L_new = L;
ADJ_new = ADJ;
info_new = info;
if isempty(ids)
    return;
end
for i = 1:length(ids)
    L_new(L == ADJ.object_labels(ids(i))) = 0;
end
%%
ADJ_new = adjacency_calculate(L_new);
[L_new, ADJ_new] = rearrange_labels(L_new , ADJ_new);
%%
l = length(ids);
if ~isempty(info)
    for i = l:(-1):1
        info_new.erroneous( info_new.erroneous > ids(i) ) = info_new.erroneous( info_new.erroneous > ids(i) ) - 1;
    end
end
end

