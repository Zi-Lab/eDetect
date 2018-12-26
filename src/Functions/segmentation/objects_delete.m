function [info_new] = objects_delete( info , ids )
info_new = info;
if isempty(ids)
    return;
end
if isfield(info,'erroneous')
    info_new.erroneous = union(info_new.erroneous , ids);
else
    info_new.erroneous = ids;
end
info_new.erroneous = info_new.erroneous(:)';
end

