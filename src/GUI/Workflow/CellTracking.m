function CellTracking(h,~)
param = guidata(h);
%%
directories_label_info  = param.tmp.directories_label_info;
filenames_label_info  = param.tmp.filenames_label_info;
directories_feature = param.tmp.directories_feature;
filenames_feature = param.tmp.filenames_feature;
directory_track = param.tmp.dir_lineage;
filenames_track = param.tmp.filenames_track;
%%
scene_array = str2double(strsplit(param.tmp.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
scenes_for_tracking = scene_array;
if param.set.source_tracking == 2
    [ FileName , PathName , ~ ] = uigetfile('*.csv');
    if isa(PathName,'double')
        return;
    end
    M = csvread(fullfile(PathName,FileName),1,0);
    image_numbers = unique(M(:,1));
    if length(scenes_for_tracking) * param.tmp.n_time ~= length(image_numbers)
        msgbox('Number of images is incorrect.','Error','error');
        return;
    end
end
%%
CloseAllInterfacesButMain(param);
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
if param.set.border_objects_tracked == 1
    include_border_object = false;
else
    include_border_object = true;
end
if exist(directory_track,'dir') ~= 7
    mkdir(directory_track);
end
hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_tracking) , param.tmp.dir_lineage , 'Computing...');
for i = 1:length(scenes_for_tracking)
    s = scenes_for_tracking(i);
    s_id = find(param.tmp.scenes_all == s);
    if param.set.source_tracking == 2
        track = cell([param.tmp.n_time,1]);
        for t = 1:param.tmp.n_time
            track{t} = M(M(:,1)==image_numbers((i-1)*param.tmp.n_time+t),3);
            if t == 1
                track{t} = zeros(size(track{t}));
            end
            hbar.iterate(1);
        end
    else
        info = cell([param.tmp.n_time,1]);
        coo = cell([param.tmp.n_time,1]);
        tbd = cell([param.tmp.n_time,1]);
        if param.tmp.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                [info{t}] = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t});
                tempdata2 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}));
                coo{t} = tempdata2.feature_coo_value;
                tbd{t} = tempdata2.feature_touch_border;
                hbar.iterate(1);
            end
        else
            for t = 1:param.tmp.n_time
                [info{t}] = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t});
                tempdata2 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}));
                coo{t} = tempdata2.feature_coo_value;
                tbd{t} = tempdata2.feature_touch_border;
                hbar.iterate(1);
            end
        end
        [ track ] = track_nuclei(info , coo , tbd , param.tra.max_frame_displacement , param.set.tracking_max_deviation , include_border_object);
    end
    savefile(track , 'track' , fullfile(directory_track , filenames_track{s_id}));
end
close(hbar);
%%
for i = 1:length(param.tmp.filenames_lineage)
    if exist(fullfile(param.tmp.dir_lineage,param.tmp.filenames_lineage{i}),'file')
        delete(fullfile(param.tmp.dir_lineage,param.tmp.filenames_lineage{i}));
    end
end
[ param ] = CheckStatus( param );
InformAllInterfaces(param);
CellPairGating(h);
end