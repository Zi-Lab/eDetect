function [ absolute ] = absolutepath( start, relative )
absolute = start;
[C,~] = strsplit(relative,{'\','/'},'CollapseDelimiters',false);
l = length(C);
for i = 1:l
    if strcmp(C{i},'.') || strcmp(C{i},'')
        
    elseif strcmp(C{i},'..')
        seps = strfind(absolute,filesep);
        if ~isempty(seps)
            if strcmp(absolute(end),filesep)
                absolute = absolute(1:seps(end-1)-1);
            else
                absolute = absolute(1:seps(end)-1);
            end
        end
    else
        absolute = fullfile(absolute,C{i});
    end
end
end

