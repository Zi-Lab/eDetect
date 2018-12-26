function [feature , names] = calculate_feature_additional(L , I)
I = double(I);
names = {'radial distribution'};
ids = setdiff(unique(L(:)),0);
feature = zeros([length(ids),1]);
table_struct  = regionprops('table', L, 'BoundingBox' );
table = table2array(table_struct);
for i = 1:length(ids)
    label = ids(i);
    xmin = ceil(table(i,1));
    ymin = ceil(table(i,2));
    xmax = floor(table(i,1)+table(i,3));
    ymax = floor(table(i,2)+table(i,4));
    L_crop = L( ymin:ymax , xmin:xmax );
    I_crop = I( ymin:ymax , xmin:xmax );
    L_crop( L_crop ~= label ) = 0;
    I_crop( L_crop ~= label ) = 0;
    L_crop = padarray(L_crop,[1,1]);
    I_crop = padarray(I_crop,[1,1]);
    D_crop = bwdist(L_crop == 0);
    feature(i) = sum(sum( I_crop .* D_crop )) / ( sum(I_crop(:)) * max(D_crop(:)) );
end
end