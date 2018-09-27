function [ ADJ_new ] = adjacency_update( ADJ, L_new, ids )
ADJ_new = ADJ;
id1 = min(ids);
id2 = setdiff(ids,id1);
l = length(id2);
%%
for i = 1:l
    ADJ_new.is_adjacent(id1,:) = ADJ_new.is_adjacent(id1,:) | ADJ_new.is_adjacent(id2(i),:);
    ADJ_new.is_adjacent(:,id1) = ADJ_new.is_adjacent(:,id1) | ADJ_new.is_adjacent(:,id2(i));
end
ADJ_new.is_adjacent(id1,id1) = false;
ADJ_new.is_adjacent(id2,:) = [];
ADJ_new.is_adjacent(:,id2) = [];
%
ADJ_new.object_labels(id1);
ADJ_new.object_labels(id2) = [];
%
%ADJ_new.objects{id1} = find(L_new == ADJ.object_labels(id1));
%ADJ_new.objects(id2) = [];
ADJ_new.object_areas(id1) = length(find(L_new == ADJ_new.object_labels(id1)));
ADJ_new.object_areas(id2) = [];
%%
SE1 = strel('square',3);
temp0 = false(size(L_new));
temp0(L_new == ADJ_new.object_labels(id1)) = true;
ADJ_new.object_borders{id1} = find( imdilate(temp0,SE1) & ~temp0 );
ADJ_new.object_borders(id2) = [];
ADJ_new.object_border_lengths(id1) = length(ADJ_new.object_borders{id1});
ADJ_new.object_border_lengths(id2) = [];
%%
del = ismember(ADJ_new.pair_objectids(:,1),ids) | ismember(ADJ_new.pair_objectids(:,2),ids);
ADJ_new.pair_objectids(del,:) = [];
ADJ_new.pair_borders(del) = [];
ADJ_new.pair_border_lengths(del) = [];
for i = l:(-1):1
    ADJ_new.pair_objectids(ADJ_new.pair_objectids > id2(i)) = ADJ_new.pair_objectids(ADJ_new.pair_objectids > id2(i)) - 1;
end
for i = 1:size(ADJ_new.is_adjacent,1)
    for j = (i+1):size(ADJ_new.is_adjacent,2)
        if i == id1 || j == id1
            if ADJ_new.is_adjacent(i,j)
                temp1 = zeros(size(L_new)) == 1;
                temp2 = zeros(size(L_new)) == 1;
                temp1(ADJ_new.object_borders{i}) = true;
                temp2(ADJ_new.object_borders{j}) = true;
                temp3 = temp1 & temp2;
                ADJ_new.pair_objectids = [ADJ_new.pair_objectids; i j];
                ADJ_new.pair_borders = [ ADJ_new.pair_borders ; {find(temp3)}];
                ADJ_new.pair_border_lengths = [ ADJ_new.pair_border_lengths ; length(find(temp3)) ];
            end
        end
    end
end
end