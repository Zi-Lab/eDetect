function [nuclei_median , cytoplasm_median , nuclei_mean , cytoplasm_mean , background_min , background_max , background_mean , background_median] = calculate_intensity_ratio(intensity , label_nuclei , label_cytoplasm , label_foreground)
temp0 = double(intensity);
temp1 = label_nuclei;
temp2 = label_cytoplasm;
temp4 = label_foreground;
l = length( setdiff(  unique(temp1(:)), 0  ) );
nuclei_median    = NaN([l,1]);
cytoplasm_median = NaN([l,1]);
nuclei_mean      = NaN([l,1]);
cytoplasm_mean   = NaN([l,1]);
for j = 1:l
    nuclei_median(j)    = median(temp0(temp1 == j));
    nuclei_mean(j)      = mean(temp0(temp1 == j));
    cytoplasm_median(j) = median(temp0(temp2 == j));
    cytoplasm_mean(j)   = mean(temp0(temp2 == j));
end
temp5 = temp0(temp4 == 0);
background_min    = double(min(temp5));
background_max    = double(max(temp5));
background_mean   = double(mean(temp5));
background_median = double(median(temp5));
end

