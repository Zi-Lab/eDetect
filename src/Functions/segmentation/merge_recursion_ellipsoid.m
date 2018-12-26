function [ best_division , extreme_value , visited_divisions , calculated_areas , stop] = merge_recursion_ellipsoid(L, ADJ, ids, edges , linked_edges , visited_divisions , calculated_areas , max_area , max_layer , max_runtime , runtime)
comp_ids = link_objects(ids,linked_edges);
l = length(comp_ids);
comps = false([size(L) , l]);
object_area = zeros([l , 1]);
ellipse_area = zeros([l , 1]);
stop = false;
%%
for i = 1:l
    calculated = -1;
    for j = 1:size(calculated_areas,1)
        vec1 = calculated_areas{j,1};
        vec2 = comp_ids{i};
        if length(vec1) == length(vec2)
            if isequal(sort(vec1),sort(vec2))
                calculated = j;
            end
        end
    end
    if calculated > 0
        ellipse_area(i) = calculated_areas{calculated,2};
        object_area(i)  = calculated_areas{calculated,3};
    else
        for j = comp_ids{i}
            temp0 = false(size(L));
            %temp0(ADJ.objects{j}) = true;
            temp0(L == ADJ.object_labels(j)) = true;
            comps(:,:,i) = comps(:,:,i) | temp0;
        end
        for j = comp_ids{i}
            for k  = comp_ids{i}
                if ADJ.is_adjacent(j,k)
                    temp1 = (ADJ.pair_objectids(:,1) == j & ADJ.pair_objectids(:,2) == k) | (ADJ.pair_objectids(:,1) == k & ADJ.pair_objectids(:,2) == j);
                    temp2 = false(size(L));
                    temp2(ADJ.pair_borders{temp1}) = true;
                    comps(:,:,i) = comps(:,:,i) | temp2;
                end
            end
        end
        object_area(i) = sum(sum(comps(:,:,i)));
        %
        if object_area(i) < max_area
            ellipse_area(i) = MinVolEllipseArea( comps(:,:,i) );
        else
            if length(comp_ids{i}) == 1
                ellipse_area(i) = object_area(i);
            else
                ellipse_area(i) = size(L,1) * size(L,2);
                stop = true;
            end
        end
        %}
        %ellipse_area(i) = MinVolEllipseArea( comps(:,:,i) );
        calculated_areas = [calculated_areas; {comp_ids{i} , ellipse_area(i) , object_area(i)}];
    end
    if length(comp_ids{i}) >= max_layer || toc(runtime) > max_runtime
        stop = true;
    end
end
%%
best_division = linked_edges;
extreme_value = sum(ellipse_area);
visited_divisions_temp =  link_objects( ids , linked_edges);
visited_divisions = [visited_divisions ; { visited_divisions_temp } ];
if stop
    return;
end
%%
remaining_edges = setdiff( edges , [ linked_edges ; linked_edges(:,[2 1]) ] , 'rows' );
for i = 1:size(remaining_edges,1)
    temp3 = false;
    comp0 = link_objects( ids , [ linked_edges ; remaining_edges(i,:) ] );
    for j = 1:length(visited_divisions)
        comp1 = visited_divisions{j};
        if length(comp1) == length(comp0)
            if cell_vector_equal(comp1,comp0)
                temp3 = true;
                break;
            end
        end
    end
    if ~temp3
        [ division , value , visited_divisions , calculated_areas , stop] = merge_recursion_ellipsoid(L, ADJ, ids, edges , [linked_edges ; remaining_edges(i,:)] , visited_divisions , calculated_areas , max_area , max_layer , max_runtime , runtime);
        if value <= extreme_value
            best_division = division;
            extreme_value = value;
        end
    end
end
%%
end

