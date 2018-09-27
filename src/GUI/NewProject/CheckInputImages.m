function [ flag ] = CheckInputImages(dir , filenames, scenes_all , scene_array_str , n_time , check_channels)
flag = true;
scene_array = str2double(strsplit(scene_array_str,' '));
if isnan(scene_array)
    scene_array = scenes_all;
end
if isempty(filenames)
    flag = false;
end
for i = 1:length(scene_array)
    id = find(scenes_all == scene_array(i));
    for j = 1:n_time
        if isempty(filenames{id,j})
            flag = false;
            return;
        elseif exist(fullfile(dir , filenames{id,j}),'file') ~= 2
            flag = false;
            msgbox('Image file missing.','Error','error');
            return;
        else
            if check_channels
                I_temp = imread(fullfile(dir , filenames{id,j}));
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

