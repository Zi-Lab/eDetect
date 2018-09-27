function FeatureExtraction(h,~)
param = guidata(h);
%%
directories_label_gray  = param.tmp.directories_label_gray;
filenames_label_gray  = param.tmp.filenames_label_gray;
directories_feature = param.tmp.directories_feature;
filenames_feature = param.tmp.filenames_feature;
%%
scene_array = str2double(strsplit(param.set.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
scenes_for_feature = scene_array;
%%
CloseAllInterfacesButMain(param);
%%
if exist(param.tmp.dir_feature,'dir') == 7
    ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
    switch ButtonName
        case 'Yes'
            [status, message, messageid] = rmdir(param.tmp.dir_feature, 's');
        case 'Cancel'
            return;
        case ''
            return;
    end
end
%%
if param.set.processing_number_of_cores > 1
    p = gcp('nocreate'); % If no pool, do not create new one.
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
param_set = param.set;
directory_nucleimarker = param.tmp.dir_nucleimarker;
filenames_nucleimarker = param.tmp.filenames_nucleimarker;
%%
hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_feature) ,param.tmp.dir_feature , 'Computing...');
for i = 1:length(scenes_for_feature)
    s = scenes_for_feature(i);
	s_id = find(param.tmp.scenes_all == s);
    if exist(directories_feature{s_id} ,'dir') ~= 7
        mkdir(directories_feature{s_id} );
    end
    if param.set.processing_number_of_cores > 1
        parfor t = 1:param.tmp.n_time
            updatefeature(param_set , directory_nucleimarker , filenames_nucleimarker{s_id,t} , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_feature{s_id} , filenames_feature{s_id,t});
            hbar.iterate(1);
        end
    else
        for t = 1:param.tmp.n_time
            updatefeature(param_set , directory_nucleimarker , filenames_nucleimarker{s_id,t} , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_feature{s_id} , filenames_feature{s_id,t});
            hbar.iterate(1);
        end
    end
end
close(hbar);
%%
if exist(param.tmp.dir_lineage,'dir') == 7
    [status, message, messageid] = rmdir(param.tmp.dir_lineage, 's');
end
[ param ] = CheckStatus( param );
InformAllInterfaces(param);
SegmentationGating(h);
end