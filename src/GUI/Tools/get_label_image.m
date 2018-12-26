function [label_gray ] = get_label_image(dir_label , filename )
label_gray_file_name = fullfile(dir_label , filename);
if exist(label_gray_file_name, 'file') == 2
    label_gray = imread(label_gray_file_name);
else
    label_gray = [];
end

end