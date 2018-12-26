function [ feature_touch_border ] = calculate_feature_touch_border( Labels )
l = size(Labels,3);
feature_touch_border = cell([l,1]);
for i = 1:l
    label = Labels(:,:,i);
    l_temp = setdiff( unique(label(:)) , 0 );
    set = setdiff( unique([label(1,:) label(end,:) label(:,1)' label(:,end)']) , [0] );    
    feature_touch_border{i} = ismember(l_temp , set);
end
if l == 1
    feature_touch_border = feature_touch_border{1};
end

end

