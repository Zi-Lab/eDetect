function [ difference ] = lineagedisplay_difference( lineage_data )
[nl,~] = size(lineage_data);
difference = lineage_data ./ [NaN([nl,1]) lineage_data(:,1:end-1)] - 1;
end

