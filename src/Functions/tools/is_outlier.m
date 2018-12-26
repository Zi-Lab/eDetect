function [ result ] = is_outlier( x , cutoff)
med = median(x);
mad = median(abs(x-median(x)));
c = 1/(sqrt(2)*erfinv(1/2));
result = (abs(x-med) > cutoff * c * mad);
end