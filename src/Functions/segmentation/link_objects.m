function [ comp ] = link_objects( object_ids , linked_edges )
n = length(object_ids);
m = size(linked_edges,1);
l = n;
comp = cell([l,1]);
for i = 1:l
    comp{i} = object_ids(i);
end
for j = 1:m
    edge = linked_edges(j,:);
    pos = [0 0];
    for i = 1:l
        if ismember(edge(1),comp{i})
            pos(1) = i;
        end
        if ismember(edge(2),comp{i})
            pos(2) = i;
        end
    end
    if pos(1) ~= pos(2)
        comp{pos(1)} = [ comp{pos(1)} comp{pos(2)} ];
        comp(pos(2)) = [];
        l = l - 1;
    end
end
for i = 1:l
    comp{i} = sort(comp{i});
end
end

