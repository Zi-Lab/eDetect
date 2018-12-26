function [ label_info] = get_label_info(dir_label , filename)
label_data_file_name = fullfile(dir_label , filename );
if exist(label_data_file_name, 'file') == 2
    tempdata = load(label_data_file_name);
    label_info = tempdata.label_info;
else
    label_info.erroneous = [];
end
end