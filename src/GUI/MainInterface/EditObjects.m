function EditObjects(h,~)
param = guidata(h);
if ~isfield(param.tmp,'n_scene')
    return;
elseif isempty(param.tmp.n_scene)
    return;
end
if isempty(param.tmp.manual_list_selected_objects)
    msgbox('Please select at least one object before clicking this tool.','Error','error');
    return;
end
%%
directories_label_gray  = param.tmp.directories_label_gray;
%directories_label_color = param.tmp.directories_label_color;
directories_label_info  = param.tmp.directories_label_info;
directories_label_data  = param.tmp.directories_label_data;
filenames_label_gray  = param.tmp.filenames_label_gray;
%filenames_label_color = param.tmp.filenames_label_color;
filenames_label_info  = param.tmp.filenames_label_info;
filenames_label_data  = param.tmp.filenames_label_data;
directories_feature = param.tmp.directories_feature;
filenames_feature = param.tmp.filenames_feature;
directory_nucleimarker = param.tmp.dir_nucleimarker;
filenames_nucleimarker = param.tmp.filenames_nucleimarker;
filenames_track = param.tmp.filenames_track;
filenames_lineage = param.tmp.filenames_lineage;
%%
if param.tmp.n_scene == 1
    s = param.tmp.min_scene;
else
    s = round((get(param.hMain.SliderFrame1,'Value')));
end
if param.tmp.n_time == 1
    t = param.tmp.min_time;
else
    t = round((get(param.hMain.SliderFrame2,'Value')));
end
s_id = find(param.tmp.scenes_all == s);
%
temp_list = [];
for i = param.tmp.manual_list_selected_objects
    temp_list = [temp_list find(param.tmp.manual_label_data.object_labels == i)];
end
%%
param.tmp.gating_update_image_list = [ s t ];
if h == param.hMain.pushtool_delete_objects || h == param.hMain.pushtool_recover_objects
    if h == param.hMain.pushtool_delete_objects
        [ param.tmp.manual_label_info ] = objects_delete(  param.tmp.manual_label_info , temp_list );
    elseif h == param.hMain.pushtool_recover_objects
        [ param.tmp.manual_label_info ] = objects_recover( param.tmp.manual_label_info , temp_list );
    end
elseif h == param.hMain.pushtool_merge_objects || h == param.hMain.pushtool_split_objects
    if h == param.hMain.pushtool_merge_objects
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_merge(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , temp_list );
    elseif h == param.hMain.pushtool_split_objects && param.set.manual_correction_split_size == 1
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_split(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , temp_list , true);
    elseif h == param.hMain.pushtool_split_objects && param.set.manual_correction_split_size == 2
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_split(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , temp_list , false);
    end
    imwrite(param.tmp.manual_label_image                       , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
    %imwrite(label2text(param.tmp.manual_label_image , 'black') , fullfile(directories_label_color{s_id}, filenames_label_color{s_id,t} ));
    savefile(param.tmp.manual_label_data        , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
end
savefile(param.tmp.manual_label_info        , 'label_info' , fullfile(directories_label_info{s_id} , filenames_label_info{ s_id,t} ));
param.tmp.manual_list_selected_objects = [];
param = Updatedisplay_Image_1(param);
guidata(h , param);
%%
%%
if     param.set.manual_correction_segmentation_update == 1
    update_feature  = false;
    update_tracking = false;
    update_lineage  = false;
elseif param.set.manual_correction_segmentation_update == 2
    update_feature  = true;
    update_tracking = false;
    update_lineage  = false;
elseif param.set.manual_correction_segmentation_update == 3
    update_feature  = true;
    update_tracking = true;
    update_lineage  = false;
elseif param.set.manual_correction_segmentation_update == 4
    update_feature  = true;
    update_tracking = true;
    update_lineage  = true;
end
%%
%%
if h == param.hMain.pushtool_split_objects || h == param.hMain.pushtool_merge_objects || h == param.hMain.pushtool_recover_objects
    if update_feature
        if h == param.hMain.pushtool_split_objects || h == param.hMain.pushtool_merge_objects
            if exist(directories_feature{s_id},'dir') == 7
                if exist(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}),'file') == 2
                    updatefeature(param.set , directory_nucleimarker , filenames_nucleimarker{s_id,t} , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_feature{s_id} , filenames_feature{s_id,t} );
                end
            end
        end
        if update_tracking
            path0 = fullfile(param.tmp.dir_lineage, filenames_track{s_id});
            if exist(path0,'file') == 2
                if t > 1
                    info0 = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id,t-1});
                    tempdata0 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t-1}));
                    coo0 = tempdata0.feature_coo_value;
                    tbd0 = tempdata0.feature_touch_border;
                end
                info1 = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id,t});
                tempdata1 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}));
                coo1 = tempdata1.feature_coo_value;
                tbd1 = tempdata1.feature_touch_border;
                if t < param.tmp.n_time
                    info2 = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id,t+1});
                    tempdata2 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t+1}));
                    coo2 = tempdata2.feature_coo_value;
                    tbd2 = tempdata2.feature_touch_border;
                end
                temp = load(path0);
                track = temp.track;
                if t > 1
                    [ track{t}   ] = track_frame_linking( t   , track ,  {info0,info1} , {coo0,coo1} , {tbd0,tbd1} , param.tra.max_frame_displacement , param.set.tracking_max_deviation);
                end
                if t < param.tmp.n_time
                    [ track{t+1} ] = track_frame_linking( t+1 , track ,  {info1,info2} , {coo1,coo2} , {tbd1,tbd2} , param.tra.max_frame_displacement , param.set.tracking_max_deviation);
                end
                savefile( track , 'track' , path0);
                if update_lineage
                    path1 = fullfile(param.tmp.dir_lineage, filenames_lineage{s_id});
                    if exist(path1,'file') == 2
                        temp1 = load(path1);
                        lineage = temp1.lineage;
                        lineage = lineage_reconfigure(lineage , t , track);
                        savefile( lineage , 'lineage' , path1  );
                    end
                end
            end
        end
    end
elseif h == param.hMain.pushtool_delete_objects
    if update_tracking
        path0 = fullfile(param.tmp.dir_lineage, filenames_track{s_id});
        if exist(path0,'file') == 2
            temp = load(path0);
            track = temp.track;
            if t > 1
                track{t  }(  temp_list  ) = 0;
            end
            if t < param.tmp.n_time
                track{t+1}(  ismember(track{t+1},temp_list)  ) = 0;
            end
            savefile( track , 'track' , path0);
            if update_lineage
                path1 = fullfile(param.tmp.dir_lineage, filenames_lineage{s_id});
                if exist(path1,'file') == 2
                    temp1 = load(path1);
                    lineage = temp1.lineage;
                    for i = temp_list
                        [ lineage ]  = lineage_edit( lineage , t   , i , 0 );
                    end
                    if t < param.tmp.n_time
                        for i = temp_list
                            tmp = lineage(lineage(:,t) == i & lineage(:,t+1) > 0,t+1)';
                            for j = tmp
                                [ lineage ]  = lineage_edit( lineage , t+1 , j , 0 );
                            end
                        end
                    end
                    savefile( lineage , 'lineage' , path1  );
                end
            end
        end
    end
end
%%
%%
%%
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            if h == param.hMain.pushtool_delete_objects || h == param.hMain.pushtool_recover_objects
                param = Updatedisplay_Segmentationgating_1(param , true, [s t]);
            else
                param = Updatedisplay_Segmentationgating_2(param , true, [s t]);
            end
        end
    end
end
if isfield(param,'hNucleiCellpairGating')
    if isfield(param.hNucleiCellpairGating,'fig')
        if isgraphics(param.hNucleiCellpairGating.fig)
            param = Updatedisplay_Cellpairgating_2(param , true, [ s t ; s t+1 ]);
        end
    end
end
if isfield(param,'hLineage')
    if isfield(param.hLineage,'fig')
        if isgraphics(param.hLineage.fig)
            param = Updatedisplay_Heatmap_3(param);
        end
    end
end
%%
if isfield(param,'hSynchrogram')
    if isfield(param.hSynchrogram,'fig')
        if isgraphics(param.hSynchrogram.fig)
            close(param.hSynchrogram.fig);
        end
    end
end
%%
InformAllInterfaces(param);
end