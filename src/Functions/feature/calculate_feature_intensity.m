% from CellProfiler
function [features, BasicFeatures] = calculate_feature_intensity(L , I )

BasicFeatures = {
    'IntegratedIntensity',...
    'MeanIntensity',...
    'StdIntensity',...
    'MinIntensity',...
    'MaxIntensity',...
    'IntegratedIntensityEdge',...
    'MeanIntensityEdge',...
    'StdIntensityEdge',...
    'MinIntensityEdge',...
    'MaxIntensityEdge',...
    'MassDisplacement'
    };

[h,w] = size(I);
labels = setdiff(unique(L(:)),0)';
ll = length( labels );
features = zeros([ll,11]);
for i = 1:ll
    temp1 = false([h,w]);
    temp1(L == labels(i)) = true;
    temp2 = bwboundaries(temp1);
    id_ob = temp1;
    id_pe_xy = temp2{1};
    y_temp = id_pe_xy(:,1);
    x_temp = id_pe_xy(:,2);
    id_pe = false([h,w]);
    id_pe(y_temp,x_temp) = true;
    I_temp = I(min(y_temp):max(y_temp),min(x_temp):max(x_temp));
    id_ob = id_ob(min(y_temp):max(y_temp),min(x_temp):max(x_temp));
    id_pe = id_pe(min(y_temp):max(y_temp),min(x_temp):max(x_temp));
    %
    features(i,1)  =  sum(  double( I_temp(   id_ob(:)   )   ) );
    features(i,2)  = mean(  double( I_temp(   id_ob(:)   )   ) );
    features(i,3)  =  std(  double( I_temp(   id_ob(:)   )   ) );
    features(i,4)  =  min(  double( I_temp(   id_ob(:)   )   ) );
    features(i,5)  =  max(  double( I_temp(   id_ob(:)   )   ) );
    features(i,6)  =  sum(  double( I_temp(   id_pe(:)   )   ) );
    features(i,7)  = mean(  double( I_temp(   id_pe(:)   )   ) );
    features(i,8)  =  std(  double( I_temp(   id_pe(:)   )   ) );
    features(i,9)  =  min(  double( I_temp(   id_pe(:)   )   ) );
    features(i,10) =  max(  double( I_temp(   id_pe(:)   )   ) );
    [ys,xs] = find(id_ob);
    ys = double(ys);
    xs = double(xs);
    is = double(   I_temp(id_ob(:))  );
    y1 = mean(ys);
    x1 = mean(xs);
    y2 = sum(ys.*is) / sum(is);
    x2 = sum(xs.*is) / sum(is);
    features(i,11) =  sqrt((x1-x2)^2+(y1-y2)^2);
end
end
