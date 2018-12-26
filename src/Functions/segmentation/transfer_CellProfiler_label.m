function [ L_new ] = transfer_CellProfiler_label( L )
L = padarray(L,[1,1]);
[H,W] = size(L);
labels = setdiff(unique(L(:)),0);
for l = labels'
    obj = L == l;
    obj1 = bwmorph(obj,'shrink',2);
    border = obj & ~obj1;
    [ys , xs] = find(border);    
    n = length(ys);
    for i = 1:n
        if ys(i) > 1 && ys(i) < H && xs(i) > 1 && xs(i) < W
            patch = L(ys(i)-1:ys(i)+1,xs(i)-1:xs(i)+1);
            if any( patch(:) ~= 0 & patch(:) ~= L(ys(i),xs(i)) )
                L(ys(i),xs(i)) = 0;
            end
        end
    end
end
L_new = L(2:H-1,2:W-1);
end

