function [ info_new] = objects_recover( info , ids )
info_new = info;
if isempty(ids)
    return;
end
info_new.erroneous = setdiff(info_new.erroneous , ids);
info_new.erroneous = info_new.erroneous(:)';
end

