function [ L_new ,ADJ_new] = merge_oversegmented_objects_ellipsoid( L , ADJ , max_area , max_layer , max_runtime )
L_new = L;
n = length(ADJ.object_labels);
G = graph(ADJ.is_adjacent);
bins = conncomp(G);
comp = unique(bins);
m = length(comp);
ids = cell(1,m);
subgraphs = zeros([n,n,m])==1;
edges = cell(1,m);
for i = 1:m
    ids{i} = find(bins == comp(i));
    subgraphs(ids{i},ids{i},i) = ADJ.is_adjacent(ids{i},ids{i});
    [temp1,temp2] = find(subgraphs(:,:,i));
    edges{i} = unique(sort([temp1,temp2],2),'rows');
end
for i = 1:m
    if length(ids{i}) == 1
        continue;
    end
    edges{i}(ismember(edges{i}(:,1),find(ADJ.object_areas > max_area)) | ismember(edges{i}(:,2),find(ADJ.object_areas > max_area)) ,:) = [];
    start = tic;
    [best_division, ~ , ~ , ~ , ~ ] = merge_recursion_ellipsoid(L_new , ADJ , ids{i} , edges{i} , zeros([0,2]) , cell([0,1]) , cell([0,3]) , max_area , max_layer  , max_runtime , start);
    comp_ids = link_objects( ids{i} , best_division);
    for j = 1:length(comp_ids)
        [ L_new , ADJ , ~] = objects_merge( L_new  , ADJ , [] , comp_ids{j} );
        edges = update_ids( edges , comp_ids{j}  );
        ids = update_ids( ids , comp_ids{j}  );
        comp_ids = update_ids( comp_ids , comp_ids{j}  );
    end
end
[L_new, ADJ_new] = rearrange_labels(L_new , ADJ);
end

