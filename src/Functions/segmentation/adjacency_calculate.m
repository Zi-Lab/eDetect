function [ adjacency ] = adjacency_calculate( L  )
adjacency.object_labels = setdiff(unique(L(:)), 0);
n = length(adjacency.object_labels);
%%
adjacency.is_adjacent = zeros(n) == 1;
adjacency.pair_objectids = [];
adjacency.pair_border_lengths = [];
%adjacency.objects = cell([n,1]);
adjacency.object_borders = cell([n,1]);
adjacency.object_border_lengths = zeros([n,1]);
adjacency.object_areas = zeros([n,1]);
adjacency.pair_borders = cell([0,1]);
adjacency.erroneous = [];
%%
ob_di = cell([n,1]);
ob_xy_ranges = zeros([n,4]);
SE1 = strel('square',3);
for i = 1:n
    objects = L == adjacency.object_labels(i);
    %adjacency.objects{i} = find(objects);
    adjacency.object_areas(i) = length(find(objects));
    objects_dilated = imdilate(objects, SE1);
    adjacency.object_borders{i} = find(objects_dilated & ~objects);
    adjacency.object_border_lengths(i) = length(adjacency.object_borders{i});
    [ys,xs] = find(objects_dilated);
    ob_di{i} = find(objects_dilated);
    ob_xy_ranges(i,:) = [ min(ys)  max(ys)  min(xs)  max(xs) ];
end
%%
for i = 1:n
    for j = (i+1):n
        if ( ob_xy_ranges(i,1) <= ob_xy_ranges(j,2) && ob_xy_ranges(i,1) >= ob_xy_ranges(j,1) ) || ( ob_xy_ranges(j,1) <= ob_xy_ranges(i,2) && ob_xy_ranges(j,1) >= ob_xy_ranges(i,1) )
            if ( ob_xy_ranges(i,3) <= ob_xy_ranges(j,4) && ob_xy_ranges(i,3) >= ob_xy_ranges(j,3) ) || ( ob_xy_ranges(j,3) <= ob_xy_ranges(i,4) && ob_xy_ranges(j,3) >= ob_xy_ranges(i,3) )
                objects_dilated_1 = false(size(L));
                objects_dilated_2 = false(size(L));
                objects_dilated_1(ob_di{i}) = true;
                objects_dilated_2(ob_di{j}) = true;
                temp = objects_dilated_1 & objects_dilated_2;
                adjacency.is_adjacent(i,j) = any(any(temp));
                adjacency.is_adjacent(j,i) = adjacency.is_adjacent(i,j);
                if adjacency.is_adjacent(i,j)
                    adjacency.pair_objectids = [adjacency.pair_objectids; i j];
                    adjacency.pair_borders = [adjacency.pair_borders ; {find(temp)}];
                    adjacency.pair_border_lengths = [adjacency.pair_border_lengths; sum(sum(temp))];
                end
            end
        end
    end
end
end