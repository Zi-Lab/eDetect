% from CellProfiler
function [Zernike, ZernikeFeatures] = calculate_feature_zernike(LabelMatrixImage)
NumObjects = max(LabelMatrixImage(:));
% Get index for Zernike functions
Zernikeindex = [];
ZernikeFeatures = {};
for n = 0:9
    for m = 0:n
        if rem(n-m,2) == 0
            Zernikeindex = [Zernikeindex;n m];
            ZernikeFeatures = cat(2,ZernikeFeatures,{sprintf('Zernike_%d_%d',n,m)});
        end
    end
end
lut = construct_lookuptable_Zernike(Zernikeindex);

Zernike = zeros(NumObjects,size(Zernikeindex,1));

for Object = 1:NumObjects
    %%% Calculate Zernike shape features
    [xcord,ycord] = find(LabelMatrixImage==Object);
    %%% It's possible for objects not to have any pixels,
    %%% particularly tertiary objects (such as cytoplasm from
    %%% cells the exact same size as their nucleus).
    if isempty(xcord),
        % no need to create an empty line of data, as that's
        % already done above.
        continue;
    end
    diameter = max((max(xcord)-min(xcord)+1),(max(ycord)-min(ycord)+1));

    if rem(diameter,2)== 0
        % An odd number facilitates implementation
        diameter = diameter + 1;
    end

    % Calculate the Zernike basis functions
    [x,y] = meshgrid(linspace(-1,1,diameter),linspace(-1,1,diameter));
    r = sqrt(x.^2+y.^2);
    phi = atan(y./(x+eps));
    % It is necessary to normalize the bases by area.
    normalization = sum(r(:) <= 1);
    % this happens for diameter == 1
    if (normalization == 0.0),
        normalization = 1.0;
    end

    Zf = zeros(diameter,diameter,size(Zernikeindex,1));

    for k = 1:size(Zernikeindex,1)
        n = Zernikeindex(k,1);
        m = Zernikeindex(k,2); % m = 0,1,2,3,4,5,6,7,8, or 9

        % Optimized
        s_new = zeros(size(x));
        exp_term = exp(sqrt(-1)*m*phi);
        lv_index = [0 : (n-m)/2];
        for i = 1: length(lv_index)
            lv = lv_index(i);
            s_new = s_new + lut(k,i) * r.^(n-2*lv).*exp_term;
        end
        s = s_new;

        s(r>1) = 0;
        Zf(:,:,k) = s / normalization;
    end

    % Get image patch, with offsets to center relative to the Zernike bases
    BWpatch = zeros(diameter, diameter);
    height = max(xcord) - min(xcord) + 1;
    width = max(ycord) - min(ycord) + 1;
    row_offset = floor((diameter - height) / 2) + 1;
    col_offset = floor((diameter - width) / 2) + 1;
    BWpatch(row_offset:(row_offset+height-1), col_offset:(col_offset+width-1)) = (LabelMatrixImage(min(xcord):max(xcord), min(ycord):max(ycord)) == Object);

    % Apply Zernike functions
    try
        Zernike(Object,:) = squeeze(abs(sum(sum(repmat(BWpatch,[1 1 size(Zernikeindex,1)]).*Zf))))';
    catch
        Zernike(Object,:) = 0;
        display(sprintf([ObjectName,' number ',num2str(Object),' was too big to be calculated. Batch Error! (this is included so it can be caught during batch processing without quitting out of the analysis)']))
    end
end
end

%%%
%%% Subfunctions for optimized Zernike
%%%

%function previousely_calculated_value = lookuptable(lv,m,n)
%previousely_calculated_value = (-1)^lv*fak_table(n-lv)/( fak_table(lv) * fak_table((n+m)/2-lv) * fak_table((n-m)/2-lv));

% Zernikeindex =
%      0     0
%      1     1
%      2     0
%      2     2
%      3     1
%      3     3
%      4     0
%      4     2
%      4     4
%      5     1
%      5     3
%      5     5
%      6     0
%      6     2
%      6     4
%      6     6
%      7     1
%      7     3
%      7     5
%      7     7
%      8     0
%      8     2
%      8     4
%      8     6
%      8     8
%      9     1
%      9     3
%      9     5
%      9     7
%      9     9


function lut = construct_lookuptable_Zernike(Zernikeindex)
for k = 1:size(Zernikeindex,1)
    n = Zernikeindex(k,1);
    m = Zernikeindex(k,2); % m = 0,1,2,3,4,5,6,7,8, or 9
    lv_index = [0 : (n-m)/2];
    for i = 1 : length(lv_index)
        lv = lv_index(i);
        lut(k, i) = (-1)^lv*fak_table(n-lv)/( fak_table(lv) * fak_table((n+m)/2-lv) * fak_table((n-m)/2-lv));
    end
end
end


function f = fak_table(n)
switch n
    case 0
        f = 1;
    case 1
        f = 1;
    case 2
        f = 2;
    case 3
        f = 6;
    case 4
        f = 24;
    case 5
        f = 120;
    case 6
        f = 720;
    case 7
        f = 5040;
    case 8
        f = 40320;
    case 9
        f = 362880;
    otherwise
        f = NaN; %
end
end


