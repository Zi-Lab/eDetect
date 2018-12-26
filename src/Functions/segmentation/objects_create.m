function [ L_new , ADJ_new , info_new ] = objects_create( L , ADJ , info , freehandobject)
L_new = L;
ADJ_new = ADJ;
info_new = info;
if isempty(freehandobject)
    msgbox('Please draw at least one shape before clicking this tool.','Error','error');
    return;
end
%%
valid_objects_ids = false(size(freehandobject));
for i = 1:length(valid_objects_ids)
    if isvalid(freehandobject(i))
        valid_objects_ids(i) = true;
    end
end
validfreehandobject = freehandobject(valid_objects_ids);
%%
n_f = length(validfreehandobject);
pos0 = cell([1,n_f]);
pos1 = cell([1,n_f]);
pos2 = cell([1,n_f]);
H = size(L,1);
W = size(L,2);
for i = 1:n_f
    pos0{i} = round(getPosition(validfreehandobject(i)));
    pos0{i} = max(pos0{i},repmat([1,1],size(pos0{i},1),1));
    pos0{i} = min(pos0{i},repmat([W,H],size(pos0{i},1),1));
    xmax = max(pos0{i}(:,1));
    xmin = min(pos0{i}(:,1));
    ymax = max(pos0{i}(:,2));
    ymin = min(pos0{i}(:,2));
    n_x = xmax-xmin+1;
    n_y = ymax-ymin+1;    
    x_mat = repmat((1:n_x) ,[n_y,1])+xmin;
    y_mat = repmat((1:n_y)',[1,n_x])+ymin;
    xlist = x_mat(:);
    ylist = y_mat(:);
    in = inpolygon(xlist,ylist,pos0{i}(:,1),pos0{i}(:,2));
    xs = xlist(in);
    ys = ylist(in);
    I_temp1 = false([H,W]);
    I_temp1(image_xy_2_id(  ys , xs , H )) = true;
    I_temp2 = bwmorph(I_temp1,'thicken',1);
    [y1, x1] = find(I_temp1);
    [y2, x2] = find(I_temp2);
    pos1{i} = [x1, y1];
    pos2{i} = [x2, y2];
end
%%
for i = 1:(n_f-1)
    for j = (i+1):n_f
        [ c , ~ , ~ ] = intersect(pos2{i},pos2{j},'rows');
        if ~isempty(c)
            msgbox('Objects overlap with each other.','Error','error');
            return;
        end
    end
end
%%
n_o = length(unique(L(:))) - 1;
for i = 1:n_f
    [ idset2 ] = image_xy_2_id(  pos2{i}(:,2) , pos2{i}(:,1) , size(L_new,1) );
    if any(L_new(idset2) ~= 0)
        msgbox('The shape is overlapping with other objects.','Error','error');
        return;
    end
end
for i = 1:n_f
    [ idset1 ] = image_xy_2_id(  pos1{i}(:,2) , pos1{i}(:,1) , size(L_new,1) );
    L_new(idset1) = n_o+i;
end
for i = 1:n_f
    delete(validfreehandobject(i));
end
%%
ADJ_new = adjacency_calculate(L_new);
[L_new, ADJ_new] = rearrange_labels(L_new , ADJ_new);
end

