function param = GenerateFilenames(param)
%%
param.tmp.path_projectfile      = param.dir.path_projectfile;
param.tmp.dir_nucleimarker      = absolutepath(param.dir.path_projectfile , param.dir.dir_nucleimarker);
param.tmp.dir_proteinofinterest = absolutepath(param.dir.path_projectfile , param.dir.dir_proteinofinterest);
param.tmp.dir_label_nuclei      = absolutepath(param.dir.path_projectfile , param.dir.dir_label_nuclei);
param.tmp.dir_feature           = absolutepath(param.dir.path_projectfile , param.dir.dir_feature);
param.tmp.dir_lineage           = absolutepath(param.dir.path_projectfile , param.dir.dir_lineage);
param.tmp.dir_label_measurement = absolutepath(param.dir.path_projectfile , param.dir.dir_label_measurement);
param.tmp.dir_measurement       = absolutepath(param.dir.path_projectfile , param.dir.dir_measurement);
%%
if ~ismember('<',param.met.filename_format_nucleimarker)
    param.tmp.min_scene = 1;
    param.tmp.max_scene = 1;
    param.tmp.n_scene = 1;
    param.tmp.scenes_all = 1;
else
    param.tmp.min_scene = round(str2double(param.met.min_scene));
    param.tmp.max_scene = round(str2double(param.met.max_scene));
    param.tmp.n_scene = param.tmp.max_scene - param.tmp.min_scene + 1;
    param.tmp.scenes_all = param.tmp.min_scene : param.tmp.max_scene;
end
if ~ismember('>',param.met.filename_format_nucleimarker)
    param.tmp.min_time = 1;
    param.tmp.max_time = 1;
    param.tmp.n_time = 1;
    param.tmp.times_all = 1;
else
    param.tmp.min_time = round(str2double(param.met.min_time));
    param.tmp.max_time = round(str2double(param.met.max_time));
    param.tmp.n_time = param.tmp.max_time - param.tmp.min_time + 1;
    param.tmp.times_all = param.tmp.min_time : param.tmp.max_time;
end
%%
param.tmp.digits_scene = length(strfind(param.met.filename_format_nucleimarker,'<'));
param.tmp.digits_time  = length(strfind(param.met.filename_format_nucleimarker,'>'));
param.tmp.filenames_nucleimarker      = cell([param.tmp.n_scene , param.tmp.n_time]);
param.tmp.filenames_proteinofinterest = cell([param.tmp.n_scene , param.tmp.n_time]);
param.tmp.filename_format_nucleimarker      = param.met.filename_format_nucleimarker;
param.tmp.filename_format_proteinofinterest = param.met.filename_format_proteinofinterest;
temp0 = 0;
for i = 1:param.tmp.n_scene
    for j = 1:param.tmp.n_time
        temp1 = strrep(param.tmp.filename_format_nucleimarker , repmat('<',[1,param.tmp.digits_scene]) , num2strdigits(param.tmp.scenes_all(i),param.tmp.digits_scene));
        temp2 = strrep(temp1, repmat('>',[1,param.tmp.digits_time]) , num2strdigits(param.tmp.times_all(j),param.tmp.digits_time));
        param.tmp.filenames_nucleimarker{i,temp0+j} = temp2;
    end
end
if ~isempty(param.met.filename_format_proteinofinterest)
    temp0 = 0;
    for i = 1:param.tmp.n_scene
        for j = 1:param.tmp.n_time
            temp3 = strrep(param.tmp.filename_format_proteinofinterest , repmat('<',[1,param.tmp.digits_scene]) , num2strdigits(param.tmp.scenes_all(i),param.tmp.digits_scene));
            temp4 = strrep(temp3, repmat('>',[1,param.tmp.digits_time]) , num2strdigits(param.tmp.times_all(j),param.tmp.digits_time));
            param.tmp.filenames_proteinofinterest{i,temp0+j} = temp4;
        end
    end
end
%%
%%
param.tmp.directories_label_gray    = cell([param.tmp.n_scene , 1]);
%param.tmp.directories_label_color   = cell([param.tmp.n_scene , 1]);
param.tmp.directories_label_info    = cell([param.tmp.n_scene , 1]);
param.tmp.directories_label_data    = cell([param.tmp.n_scene , 1]);
param.tmp.directories_feature       = cell([param.tmp.n_scene , 1]);
param.tmp.directories_label_measure = cell([param.tmp.n_scene , 1]);
param.tmp.directories_measurement   = cell([param.tmp.n_scene , 1]);
param.tmp.directories_crop_video    = cell([param.tmp.n_scene , 1]);
%%
param.tmp.filenames_label_gray    = cell([param.tmp.n_scene , param.tmp.n_time]);
%param.tmp.filenames_label_color   = cell([param.tmp.n_scene , param.tmp.n_time]);
param.tmp.filenames_label_info    = cell([param.tmp.n_scene , param.tmp.n_time]);
param.tmp.filenames_label_data    = cell([param.tmp.n_scene , param.tmp.n_time]);
param.tmp.filenames_feature       = cell([param.tmp.n_scene , param.tmp.n_time]);
param.tmp.filenames_label_measure = cell([param.tmp.n_scene , param.tmp.n_time]);
param.tmp.filenames_measurement   = cell([param.tmp.n_scene , param.tmp.n_time]);
%%
param.tmp.filenames_track       = cell([param.tmp.n_scene , 1]);
param.tmp.filenames_lineage     = cell([param.tmp.n_scene , 1]);
param.tmp.filenames_table_lineage_filtered     = cell([param.tmp.n_scene , 1]);
param.tmp.filenames_table_measurement_filtered = cell([param.tmp.n_scene , 1]);
%%
for i = 1:size(param.tmp.filenames_nucleimarker , 1)
    s = param.tmp.scenes_all(i);
    s_str = num2strdigits(s,param.tmp.digits_scene(1));
    %%
    param.tmp.directories_label_gray{i,1}    = fullfile(param.tmp.dir_label_nuclei         , ['s' s_str], 'label_gray' );
    %param.tmp.directories_label_color{i,1}   = fullfile(param.tmp.dir_label_nuclei         , ['s' s_str], 'label_color');
    param.tmp.directories_label_info{i,1}    = fullfile(param.tmp.dir_label_nuclei         , ['s' s_str], 'label_info' );
    param.tmp.directories_label_data{i,1}    = fullfile(param.tmp.dir_label_nuclei         , ['s' s_str], 'label_data' );
    param.tmp.directories_feature{i,1}       = fullfile(param.tmp.dir_feature              , ['s' s_str]);
    param.tmp.directories_label_measure{i,1} = fullfile(param.tmp.dir_label_measurement    , ['s' s_str], 'label_data' );
    param.tmp.directories_measurement{i,1}   = fullfile(param.tmp.dir_measurement          , ['s' s_str]);
    param.tmp.directories_crop_video{i,1}    = fullfile(param.tmp.dir_lineage              , ['cropped_videos_s' s_str]);
    %%
    param.tmp.filenames_track{i,1}   = ['s' s_str '_track.mat'];
    param.tmp.filenames_lineage{i,1} = ['s' s_str '_lineage.mat'];
    param.tmp.filenames_table_lineage_filtered{i,1}       = ['s' s_str '_table_lineage_filtered.txt'];
    param.tmp.filenames_table_measurement_filtered{i,1}   = ['s' s_str '_table_measurement_filtered.txt'];
    %%
    for j = 1:size(param.tmp.filenames_nucleimarker , 2)
        param.tmp.filenames_label_gray{i,j}    = [ param.tmp.filenames_nucleimarker{i,j} '_label_gray.tif' ];
        %param.tmp.filenames_label_color{i,j}   = [ param.tmp.filenames_nucleimarker{i,j} '_label_color.tif'];
        param.tmp.filenames_label_info{i,j}    = [ param.tmp.filenames_nucleimarker{i,j} '_label_info.mat' ];
        param.tmp.filenames_label_data{i,j}    = [ param.tmp.filenames_nucleimarker{i,j} '_label_data.mat' ];
        param.tmp.filenames_feature{i,j}       = [ param.tmp.filenames_nucleimarker{i,j} '_feature.mat'    ];
        param.tmp.filenames_label_measure{i,j} = [ param.tmp.filenames_nucleimarker{i,j} '_label_data.mat' ];
        param.tmp.filenames_measurement{i,j}   = [ param.tmp.filenames_nucleimarker{i,j} '_measurement.mat'];
    end
end
end