function [ label_data] = get_label_data(dir_label , filename)
label_data_file_name = fullfile(dir_label , filename );
if exist(label_data_file_name, 'file') == 2
    tempdata = load(label_data_file_name);
    label_data = tempdata.label_data;
else
    label_data = [];
end
end