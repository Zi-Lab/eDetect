function [L_new , ADJ_new] = merge_groups_objects(L , ADJ , groups )
exist_objects_to_be_merged = true;
while exist_objects_to_be_merged
    exists = false;
    for i = 1:length(groups)
        [L , ADJ] = objects_merge(L  , ADJ , groups{i});
        groups(2:end) = update_ids(groups(2:end),groups{1});
        groups(1) = [];
        exists = true;
        break;
    end
    if ~exists
        exist_objects_to_be_merged = false;
    end
end
[L_new, ADJ_new] = rearrange_labels(L , ADJ);
end

