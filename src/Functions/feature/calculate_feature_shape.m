function [ feature , feature_names ] = calculate_feature_shape( Labels , I)
feature_list = {'Area','ConvexArea','Eccentricity','EquivDiameter','MajorAxisLength','MinorAxisLength','Orientation','Perimeter','Solidity','MeanIntensity'};
feature_struct  = regionprops('table', Labels, I, feature_list );
feature = table2array(feature_struct);
feature_names = feature_struct.Properties.VariableNames;
if isempty(feature)
    feature = zeros([0,length(feature_names)]);
end
end

