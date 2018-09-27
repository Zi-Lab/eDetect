function [ new_lineage ] = lineage_edit( lineage , frame_child , id_child , id_parent )
new_lineage = lineage;
[~,nt] = size(new_lineage);
%%
if frame_child <= 1 || frame_child > nt
    return;
end
lines = find(new_lineage(:,frame_child) == id_child);
if isempty(lines)
    new_lineage = [new_lineage;[ zeros([1,frame_child-1]) id_child zeros([1,nt-frame_child])] ];
    lines = find(new_lineage(:,frame_child) == id_child);
end
if new_lineage(lines(1),frame_child-1) == id_parent
    return;
end
%%
record = new_lineage(lines(1),1:frame_child-1);
if id_parent == 0
    for i = lines'
        new_lineage(i,1:frame_child-1) = 0;
    end
else
    line = find(new_lineage(:,frame_child-1) == id_parent,1);
    if isempty(line)
        for i = lines'
            new_lineage(i,frame_child-1) = id_parent;
            if frame_child > 2
                new_lineage(i,1:frame_child-2) = 0;
            end
        end
    else
        segment = new_lineage(line,1:frame_child-1);
        flag = false;
        for i = lines'
            new_lineage(i,1:frame_child-1) = segment;
            ids = new_lineage(line,:) ~= new_lineage(i,:);
            if all(new_lineage(line,ids)==0)
                flag = true;
            end
        end
        if flag
            new_lineage(line,:) = [];
        end
    end
end
if any(record ~= 0)
    if ~any(all(new_lineage(:,1:frame_child-1) == repmat(record,[size(new_lineage,1),1]),2),1)
        new_lineage = [ new_lineage; record , zeros([1,nt-(frame_child-1)]) ];
    end
end
end

