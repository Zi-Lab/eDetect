function param = Updatedisplay_Heatmap_3(param)
directory_lineage = param.tmp.dir_lineage;
filenames_lineage = param.tmp.filenames_lineage;
directories_feature = param.tmp.directories_feature;
filenames_feature = param.tmp.filenames_feature;
directories_measurement1 = param.tmp.directories_measurement1;
filenames_measurement1 = param.tmp.filenames_measurement1;
directories_measurement2 = param.tmp.directories_measurement2;
filenames_measurement2 = param.tmp.filenames_measurement2;
directories_measurement3 = param.tmp.directories_measurement3;
filenames_measurement3 = param.tmp.filenames_measurement3;
directories_measurement4 = param.tmp.directories_measurement4;
filenames_measurement4 = param.tmp.filenames_measurement4;
%%
if param.tmp.n_scene == 1
    s = param.tmp.min_scene;
else
    s = round((get(param.hLineage.SliderFrame1,'Value')));
end
s_id = find(param.tmp.scenes_all == s);
file_lineage = fullfile(directory_lineage, filenames_lineage{s_id});
files_feature = dir(directories_feature{s_id});
files_measure1 = dir(directories_measurement1{s_id});
files_measure2 = dir(directories_measurement2{s_id});
files_measure3 = dir(directories_measurement3{s_id});
files_measure4 = dir(directories_measurement4{s_id});
%%
param.tmp.feature_names = [];
if ~isempty(files_feature)
    files_feature(1:2) = [];
    samplefile = load(fullfile(files_feature(1).folder , files_feature(1).name));
    if isfield(samplefile,'feature_sha_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_sha_name];
    end
    %if isfield(samplefile,'feature_coo_name')
    %    param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_coo_name];
    %end
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
    if ~isempty(files_measure1)
        files_measure1(1:2) = [];
        if ~isempty(files_measure1)
            samplefile1 = load(fullfile(files_measure1(1).folder , files_measure1(1).name));
            measure_names = fieldnames(samplefile1);
            for i = 1:length(measure_names)
                param.tmp.feature_names = [param.tmp.feature_names {['Channel 2 ' measure_names{i}]}];
            end
        end
    end
    if ~isempty(files_measure2)
        files_measure2(1:2) = [];
        if ~isempty(files_measure2)
            samplefile1 = load(fullfile(files_measure2(1).folder , files_measure2(1).name));
            measure_names = fieldnames(samplefile1);
            for i = 1:length(measure_names)
                param.tmp.feature_names = [param.tmp.feature_names {['Channel 3 ' measure_names{i}]}];
            end
        end
    end
    if ~isempty(files_measure3)
        files_measure3(1:2) = [];
        if ~isempty(files_measure3)
            samplefile1 = load(fullfile(files_measure3(1).folder , files_measure3(1).name));
            measure_names = fieldnames(samplefile1);
            for i = 1:length(measure_names)
                param.tmp.feature_names = [param.tmp.feature_names {['Channel 4 ' measure_names{i}]}];
            end
        end
    end
    if ~isempty(files_measure4)
        files_measure4(1:2) = [];
        if ~isempty(files_measure4)
            samplefile1 = load(fullfile(files_measure4(1).folder , files_measure4(1).name));
            measure_names = fieldnames(samplefile1);
            for i = 1:length(measure_names)
                param.tmp.feature_names = [param.tmp.feature_names {['Channel 5 ' measure_names{i}]}];
            end
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
            %if isfield(tempdata,'feature_coo_value')
            %    param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata.feature_coo_value];
            %end
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
        %%
        tmp1 = param.tmp.feature_names([1:n_col_feature]);
        tmp2 = [];
        tmp3 = [];
        tmp4 = [];
		tmp5 = [];
        flg2 = false;
        flg3 = false;
        flg4 = false;
		flg5 = false;
        %%
        if ~isempty(files_measure1)
            for t = 1:param.tmp.n_time
                tempdata1 = load(fullfile(directories_measurement1{s_id}, filenames_measurement1{s_id,t}));
                measure_names1 = fieldnames(tempdata1);
                valid_col_measure1 = [];
                for i = 1:length(measure_names1)
                    eval(['l_temp = size(tempdata1.' measure_names1{i} ',1);']);
                    if l_temp == size(param.tmp.track_feature{t},1)
                        eval(['param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata1.' measure_names1{i} '];']);
                        valid_col_measure1 = union(valid_col_measure1,i);
                    end
                end
            end
            tmp2 = param.tmp.feature_names([n_col_feature + valid_col_measure1]);
            flg2 = true;
        end
        if ~isempty(files_measure2)
            for t = 1:param.tmp.n_time
                tempdata2 = load(fullfile(directories_measurement2{s_id}, filenames_measurement2{s_id,t}));
                measure_names2 = fieldnames(tempdata2);
                valid_col_measure2 = [];
                for i = 1:length(measure_names2)
                    eval(['l_temp = size(tempdata2.' measure_names2{i} ',1);']);
                    if l_temp == size(param.tmp.track_feature{t},1)
                        eval(['param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata2.' measure_names2{i} '];']);
                        valid_col_measure2 = union(valid_col_measure2,i);
                    end
                end
            end
            tmp3 = param.tmp.feature_names([n_col_feature + length(measure_names1) + valid_col_measure2]);
            flg3 = true;
        end
        if ~isempty(files_measure3)
            for t = 1:param.tmp.n_time
                tempdata3 = load(fullfile(directories_measurement3{s_id}, filenames_measurement3{s_id,t}));
                measure_names3 = fieldnames(tempdata3);
                valid_col_measure3 = [];
                for i = 1:length(measure_names3)
                    eval(['l_temp = size(tempdata3.' measure_names3{i} ',1);']);
                    if l_temp == size(param.tmp.track_feature{t},1)
                        eval(['param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata3.' measure_names3{i} '];']);
                        valid_col_measure3 = union(valid_col_measure3,i);
                    end
                end
            end
            tmp4 = param.tmp.feature_names([n_col_feature + length(measure_names1) + length(measure_names2) + valid_col_measure3]);
            flg4 = true;
        end
        if ~isempty(files_measure4)
            for t = 1:param.tmp.n_time
                tempdata4 = load(fullfile(directories_measurement4{s_id}, filenames_measurement4{s_id,t}));
                measure_names4 = fieldnames(tempdata4);
                valid_col_measure4 = [];
                for i = 1:length(measure_names4)
                    eval(['l_temp = size(tempdata4.' measure_names4{i} ',1);']);
                    if l_temp == size(param.tmp.track_feature{t},1)
                        eval(['param.tmp.track_feature{t} = [param.tmp.track_feature{t} tempdata4.' measure_names4{i} '];']);
                        valid_col_measure4 = union(valid_col_measure4,i);
                    end
                end
            end
            tmp5 = param.tmp.feature_names([n_col_feature + length(measure_names1) + length(measure_names2) + length(measure_names3) + valid_col_measure4]);
            flg5 = true;
        end
        param.tmp.feature_names = tmp1;
        if flg2
            param.tmp.feature_names = [tmp1 tmp2];
            if flg3
                param.tmp.feature_names = [tmp1 tmp2 tmp3];
                if flg4
                    param.tmp.feature_names = [tmp1 tmp2 tmp3 tmp4];
                    if flg5
                        param.tmp.feature_names = [tmp1 tmp2 tmp3 tmp4 tmp5];
                    end
                end
            end
        end 
    end
end
%%
if ~isempty(param.tmp.feature_names)
    set(param.hLineage.Drop1,'String', param.tmp.feature_names);
end
%%
%%
%%
param = Updatedisplay_Heatmap_2(param);
end