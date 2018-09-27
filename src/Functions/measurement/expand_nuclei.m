% modified from CellProfiler
function [Cell ] = expand_nuclei(Nuclei , thickness)
if isempty(thickness) || isnan(thickness)
    Cell = [];
elseif thickness == 0
    Cell = Nuclei;
else
    Cell = zeros(size(Nuclei),class(Nuclei));
    l = size(Nuclei,3);
    if thickness > 0
        for i = 1:l
            temp1 = Nuclei(:,:,i);
            temp2 = bwmorph(temp1 , 'thicken' , thickness);
            [L,num] = bwlabel(temp2);
            temp3 = zeros(size(temp2));
            for k = 1:num
                index = find(L==k);
                OriginalLabel = temp1(index);
                fooindex = find(OriginalLabel);
                temp3(index) = OriginalLabel(fooindex(1));
            end
            Cell(:,:,i) = temp3;
        end
    elseif thickness < 0
        Cell = zeros(size(Nuclei),class(Nuclei));
        for i = 1:l
            temp1 = Nuclei(:,:,i);
            temp2 = bwmorph(temp1, 'thin', -thickness);
            %temp3 = temp2.*temp1;
            temp3 = temp1;
            temp3(~temp2) = 0;
            Cell(:,:,i) = temp3;
        end
    end
end
end