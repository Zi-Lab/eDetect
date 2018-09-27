function CellSegmentation( h , ~ )
param = guidata(h);
%%
if     param.set.segmentation_declump_merge == 1
    declump = false;
    merge = false;
elseif param.set.segmentation_declump_merge == 2
    declump = true;
    merge = false;
elseif param.set.segmentation_declump_merge == 3
    declump = true;
    merge = true;
end
%%
scene_array = str2double(strsplit(param.set.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
scenes_for_segmentation = scene_array;
%%
param_seg = param.seg;
max_depth = param.set.segmentation_max_depth;
max_runtime = param.set.segmentation_max_runtime;
%%
dir_nucleimarker = param.tmp.dir_nucleimarker;
filenames_nucleimarker = param.tmp.filenames_nucleimarker;
directories_label_gray  = param.tmp.directories_label_gray;
%directories_label_color = param.tmp.directories_label_color;
directories_label_info  = param.tmp.directories_label_info;
directories_label_data  = param.tmp.directories_label_data;
filenames_label_gray  = param.tmp.filenames_label_gray;
%filenames_label_color = param.tmp.filenames_label_color;
%filenames_label_info  = param.tmp.filenames_label_info;
filenames_label_data  = param.tmp.filenames_label_data;
%%
CloseAllInterfacesButMain(param);
%%
if exist(param.tmp.dir_label_nuclei,'dir') == 7
    ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
    switch ButtonName
        case 'Yes'
            [status, message, messageid] = rmdir(param.tmp.dir_label_nuclei, 's');
        case 'Cancel'
            return;
        case ''
            return;
    end
end
%%
if param.set.processing_number_of_cores > 1
    p = gcp('nocreate');
    if isempty(p)
        hMsg = msgbox('Starting parallel pool...','Information','help');
        delete(findobj(hMsg,'string','OK'));
        try
            parpool('local',param.set.processing_number_of_cores);
        catch e
            msgbox([e.message],'Warning','warn');
        end
        if isvalid(hMsg)
            close(hMsg);
        end
    end
end
%%
hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_segmentation) ,param.tmp.dir_label_nuclei , 'Computing...');
for i = 1:length(scenes_for_segmentation)
    s = scenes_for_segmentation(i);
    s_id = find(param.tmp.scenes_all == s);
    if exist(directories_label_gray{ s_id},'dir') ~= 7
        mkdir(directories_label_gray{ s_id});
    end
    %if exist(directories_label_color{s_id},'dir') ~= 7
    %    mkdir(directories_label_color{s_id});
    %end
    if exist(directories_label_info{ s_id},'dir') ~= 7
        mkdir(directories_label_info{ s_id});
    end
    if exist(directories_label_data{ s_id},'dir') ~= 7
        mkdir(directories_label_data{ s_id});
    end
    if param.set.processing_number_of_cores > 1
        parfor t = 1:param.tmp.n_time
            I_temp = imread(fullfile(dir_nucleimarker , filenames_nucleimarker{s_id,t} ));
            [ label_gray , label_data ] = nuclei_segmentation_adaptive_thresholding_1( I_temp , param_seg , max_depth , max_runtime, declump , merge);
            %label_color = label2text(label_gray , 'black');
            imwrite(label_gray                 , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
            %imwrite(label_color                , fullfile(directories_label_color{s_id}, filenames_label_color{s_id,t} ));
            savefile(label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
            hbar.iterate(1);
        end
    else
        for t = 1:param.tmp.n_time
            I_temp = imread(fullfile(dir_nucleimarker , filenames_nucleimarker{s_id,t} ));
            [ label_gray , label_data ] = nuclei_segmentation_adaptive_thresholding_1( I_temp , param_seg , max_depth , max_runtime, declump , merge);
            %label_color = label2text(label_gray , 'black');
            imwrite(label_gray                 , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
            %imwrite(label_color                , fullfile(directories_label_color{s_id}, filenames_label_color{s_id,t} ));
            savefile(label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
            hbar.iterate(1);
        end
    end
end
close(hbar);
%%
param = Updatedisplay_Image_1(param);
%%
if exist(param.tmp.dir_feature,'dir') == 7
    [status, message, messageid] = rmdir(param.tmp.dir_feature, 's');
end
if exist(param.tmp.dir_lineage,'dir') == 7
    [status, message, messageid] = rmdir(param.tmp.dir_lineage, 's');
end
if exist(param.tmp.dir_label_measurement,'dir') == 7
    [status, message, messageid] = rmdir(param.tmp.dir_label_measurement, 's');
end
if exist(param.tmp.dir_measurement,'dir') == 7
    [status, message, messageid] = rmdir(param.tmp.dir_measurement, 's');
end
[ param ] = CheckStatus( param );
InformAllInterfaces(param);
end
%%