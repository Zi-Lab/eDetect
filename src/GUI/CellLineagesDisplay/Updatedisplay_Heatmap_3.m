function param = Updatedisplay_Heatmap_3(param)
directory_lineage = param.tmp.dir_lineage;
filenames_lineage = param.tmp.filenames_lineage;
directories_feature = param.tmp.directories_feature;
filenames_feature = param.tmp.filenames_feature;
directories_measurement = param.tmp.directories_measurement;
filenames_measurement = param.tmp.filenames_measurement;
%%
if param.tmp.n_scene == 1
    s = param.tmp.min_scene;
else
    s = round((get(param.hLineage.SliderFrame1,'Value')));
end
s_id = find(param.tmp.scenes_all == s);
file_lineage = fullfile(directory_lineage, filenames_lineage{s_id});
files_feature = dir(directories_feature{s_id});
files_measure = dir(directories_measurement{s_id});
%%
param.tmp.feature_names = [];
if ~isempty(files_feature)
    files_feature(1:2) = [];
    samplefile = load(fullfile(files_feature(1).folder , files_feature(1).name));
    if isfield(samplefile,'feature_sha_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_sha_name];
    end
    if isfield(samplefile,'feature_coo_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_coo_name];
    end
    if isfield(samplefile,'feature_int_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_int_name];
    end
    if isfield(samplefile,'feature_zer_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_zer_name];
    end
    if isfield(samplefile,'feature_har_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_har_name];
    end
    if isfield(samplefile,'feature_add_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_add_name];
    end
    if ~isempty(files_measure)
        files_measure(1:2) = [];
        samplefile1 = load(fullfile(files_measure(1).folder , files_measure(1).name));
        measure_names = fieldnames(samplefile1);
        for i = 1:length(measure_names)
            param.tmp.feature_names = [param.tmp.feature_names {measure_names{i}}];
        end
    end
    param.tmp.current_feature_name = param.tmp.feature_names{1};
    if isfield(param.tmp,'previous_feature_name')
        if ~isempty(param.tmp.previous_feature_name)
            if ismember(param.tmp.previous_feature_name,param.tmp.feature_names)
                param.tmp.current_feature_name = param.tmp.previous_feature_name;
            end
        end
    end
end
%%
if ~isempty(files_feature)
    if exist(file_lineage,'file') == 2
        %%
        temp_lineage = load(file_lineage);
        param.tmp.manual_lineage_tree = sortrows(temp_lineage.lineage);
        %%
        param.tmp.track_feature = cell([param.tmp.n_time,1]);
        for t = 1:param.tmp.n_time
            tempdata = load(fullfile(directories_feature{s_id}, filenames_feature{s_id,t}));
            param.tmp.track_feature{t} = [];
            if isfield(tempdata,'feature_sha_value')
                param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata.feature_sha_value];
            end
            if isfield(tempdata,'feature_coo_value')
                param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata.feature_coo_value];
            end
            if isfield(tempdata,'feature_int_value')
                param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata.feature_int_value];
            end
            if isfield(tempdata,'feature_zer_value')
                param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata.feature_zer_value];
            end
            if isfield(tempdata,'feature_har_value')
                param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata.feature_har_value];
            end
            if isfield(tempdata,'feature_add_value')
                param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata.feature_add_value];
            end
        end
        n_col_feature = size(param.tmp.track_feature{t},2);
        if ~isempty(files_measure)
            for t = 1:param.tmp.n_time
                tempdata1 = load(fullfile(directories_measurement{s_id}, filenames_measurement{s_id,t}));
                measure_names = fieldnames(tempdata1);
                valid_col_measure = [];
                for i = 1:length(measure_names)
                    eval(['l_temp = size(tempdata1.' measure_names{i} ',1);']);
                    if l_temp == size(param.tmp.track_feature{t},1)
                        eval(['param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata1.' measure_names{i} '];']);
                        valid_col_measure = union(valid_col_measure,i);
                    end
                end
            end
            param.tmp.feature_names = param.tmp.feature_names([1:n_col_feature n_col_feature + valid_col_measure]);
        end
    end
end
%%
if ~isempty(param.tmp.feature_names)
    set(param.hLineage.Drop1,'String', param.tmp.feature_names);
end
%%
param = Updatedisplay_Heatmap_2(param);
end