function CellSegmentation( h,~ )
param = guidata(h);
%%
scene_array = str2double(strsplit(param.tmp.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
scenes_for_segmentation = scene_array;
%%
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
%%
if param.set.source_segmentation == 2
    [new_dir,path] = uigetfile('*.*','MultiSelect', 'on');
    if isa(new_dir,'double')
        return;
    end
    [~,~,ext] = fileparts(new_dir{1});
    for i = 1:length(scenes_for_segmentation)
        s = scenes_for_segmentation(i);
        s_id = find(param.tmp.scenes_all == s);
        for t = 1:param.tmp.n_time
            [~,filename,~] = fileparts(filenames_nucleimarker{s_id,t});
            if exist(fullfile(path ,[filename ext]) , 'file') ~= 2
                msgbox('CellProfiler segmentation masks missing.','Filenames','error');
                return;
            end
        end
    end
else
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
    param_seg = param.seg;
    max_depth = param.set.segmentation_max_depth;
    max_runtime = param.set.segmentation_max_runtime;
    sensitivity = param.set.segmentation_sensitivity;
    medfilt2size = param.set.segmentation_medfilt2size;
    gaufilt2size = param.set.segmentation_gaufilt2size;
    gaufilt2sigm = param.set.segmentation_gaufilt2sigm;
end
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
if param.tmp.processing_number_of_cores > 1
    p = gcp('nocreate');
    if isempty(p)
        hMsg = msgbox('Starting parallel pool...','Information','help');
        delete(findobj(hMsg,'string','OK'));
        try
            parpool('local',param.tmp.processing_number_of_cores);
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
    if exist(directories_label_info{ s_id},'dir') ~= 7
        mkdir(directories_label_info{ s_id});
    end
    if exist(directories_label_data{ s_id},'dir') ~= 7
        mkdir(directories_label_data{ s_id});
    end
    if param.set.source_segmentation == 2
        if param.tmp.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                [~,filename,~] = fileparts(filenames_nucleimarker{s_id,t});
                label_gray = imread(fullfile(path , [filename ext] ));
                label_gray = transfer_CellProfiler_label(label_gray);
                label_data = adjacency_calculate(label_gray );
                [label_gray, label_data] = rearrange_labels(label_gray , label_data);
                imwrite(label_gray                 , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
                savefile(label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
                hbar.iterate(1);
            end
        else
            for t = 1:param.tmp.n_time
                [~,filename,~] = fileparts(filenames_nucleimarker{s_id,t});
                label_gray = imread(fullfile(path , [filename ext] ));
                label_gray = transfer_CellProfiler_label(label_gray);
                label_data = adjacency_calculate(label_gray );
                [label_gray, label_data] = rearrange_labels(label_gray , label_data);
                imwrite(label_gray                 , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
                savefile(label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
                hbar.iterate(1);
            end
        end
    else
        if param.tmp.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                I_temp = imread(fullfile(dir_nucleimarker , filenames_nucleimarker{s_id,t} ));
                [ label_gray , label_data ] = nuclei_segmentation_adaptive_thresholding_1( I_temp , param_seg , medfilt2size , gaufilt2size , gaufilt2sigm , sensitivity , max_depth , max_runtime, declump , merge);
                %label_color = label2text(label_gray , 'black');
                imwrite(label_gray                 , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
                %imwrite(label_color                , fullfile(directories_label_color{s_id}, filenames_label_color{s_id,t} ));
                savefile(label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
                hbar.iterate(1);
            end
        else
            for t = 1:param.tmp.n_time
                I_temp = imread(fullfile(dir_nucleimarker , filenames_nucleimarker{s_id,t} ));
                [ label_gray , label_data ] = nuclei_segmentation_adaptive_thresholding_1( I_temp , param_seg , medfilt2size , gaufilt2size , gaufilt2sigm , sensitivity , max_depth , max_runtime, declump , merge);
                %label_color = label2text(label_gray , 'black');
                imwrite(label_gray                 , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
                %imwrite(label_color                , fullfile(directories_label_color{s_id}, filenames_label_color{s_id,t} ));
                savefile(label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
                hbar.iterate(1);
            end
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