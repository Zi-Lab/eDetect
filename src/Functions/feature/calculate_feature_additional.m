function [feature , names] = calculate_feature_additional(L , I)
I = double(I);
names = {'radial distribution'};
ids = setdiff(unique(L(:)),0);
feature = zeros([length(ids),1]);
for i = 1:length(ids)
    label = ids(i);
    [ys , xs] = find( L == label );
    ymin = min(ys);
    ymax = max(ys);
    xmin = min(xs);
    xmax = max(xs);
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