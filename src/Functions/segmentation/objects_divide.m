function [ L_new , ADJ_new , info_new ] = objects_divide( L , ADJ , info , curveobject)
L_new = L;
ADJ_new = ADJ;
info_new = info;
if isempty(curveobject)
    msgbox('Please draw at least one curve before clicking this tool.','Error','error');
    return;
end
%%
H = size(L,1);
W = size(L,2);
n_f = length(curveobject);
pos = cell([1,n_f]);
for i = 1:n_f
    if ~isvalid(curveobject(i))
        continue;
    end
    pos{i} = getPosition(curveobject(i));
    division_line = NaN([0,2]);
    for j = 1:(size(pos{i},1)-1)
        x1 = pos{i}(j+0,1);
        y1 = pos{i}(j+0,2);
        x2 = pos{i}(j+1,1);
        y2 = pos{i}(j+1,2);
        vec = [x2-x1,y2-y1];
        for k = 0:0.5:ceil(norm(vec))
            point = [x1,y1] + k * vec / norm(vec);
            division_line = [division_line; [ floor(point(1)) floor(point(2)) ] ;[ ceil(point(1)) ceil(point(2)) ] ;[ ceil(point(1)) floor(point(2)) ] ;[ floor(point(1)) ceil(point(2)) ] ];
        end
    end
    division_line = division_line( division_line(:,1)>=1 & division_line(:,1)<=W & division_line(:,2)>=1 & division_line(:,2)<=H,:);
    [ idset ] = image_xy_2_id(  division_line(:,2) , division_line(:,1) , H );
    L_new(idset) = 0;
end
for i = 1:n_f
    delete(curveobject(i));
end
%%
L_new = uint16(bwlabel(L_new > 0));
ADJ_new = adjacency_calculate(L_new);
[L_new, ADJ_new] = rearrange_labels(L_new , ADJ_new);
end

