function [ feature , name ] = calculate_feature_coordinate( Labels )
name = {'x','y'};
feature_struct  = regionprops('table', Labels, 'Centroid' );
feature = table2array(feature_struct);
if isempty(feature)
    feature = zeros([0,length(name)]);
end
end

