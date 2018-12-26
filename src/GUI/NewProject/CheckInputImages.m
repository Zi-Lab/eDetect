function [ flag ] = CheckInputImages(dir , filenames, scenes , n_time , check_channels)
flag = true;
if isempty(filenames)
    flag = false;
    return;
end
if ~iscell(filenames)
    flag = false;
    return;
end
if size(filenames,1) ~= length(scenes) || size(filenames,2) ~= n_time
    flag = false;
    return;
end
for i = 1:length(scenes)
    for j = 1:n_time
        if isempty(filenames{i,j})
            flag = false;
            return;
        elseif exist(fullfile(dir , filenames{i,j}),'file') ~= 2
            flag = false;
            msgbox('Image file missing.','Error','error');
            return;
        else
            if check_channels
                I_temp = imread(fullfile(dir , filenames{i,j}));
                if size(I_temp,3) > 1
                    flag = false;
                    msgbox('Image file is not grayscale.','Error','error');
                    return;
                end
            end
        end
    end
end
end