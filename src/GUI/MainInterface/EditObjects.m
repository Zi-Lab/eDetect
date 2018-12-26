function EditObjects(h,~)
param = guidata(h);
h_merge = param.hMain.pushtool_merge_objects;
h_split = param.hMain.pushtool_split_objects;
h_create = param.hMain.pushtool_create_objects;
h_remove = param.hMain.pushtool_remove_objects;
h_divide = param.hMain.pushtool_divide_objects;
h_delete = param.hMain.pushtool_delete_objects;
h_recover = param.hMain.pushtool_recover_objects;
%%
if ~isfield(param.tmp,'n_scene')
    return;
elseif isempty(param.tmp.n_scene)
    return;
end
if h == h_create
    if ~isfield(param.hMain,'freehand') || isempty(param.hMain.freehand)
        msgbox('Please draw at least one closed curve before clicking this tool.','Error','error');
        return;
    end
elseif h == h_divide
    if ~isfield(param.hMain,'curve') || isempty(param.hMain.curve)
        msgbox('Please draw at least one open curve before clicking this tool.','Error','error');
        return;
    end
else
    if isempty(param.tmp.manual_list_selected_objects)
        msgbox('Please select at least one object before clicking this tool.','Error','error');
        return;
    end
end
if param.set.border_objects_tracked == 1
    include_border_object = false;
else
    include_border_object = true;
end
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
%profile on
if h == h_delete || h == h_recover
    if h == h_delete
        [ param.tmp.manual_label_info ] = objects_delete(  param.tmp.manual_label_info , temp_list );
    elseif h == h_recover
        [ param.tmp.manual_label_info ] = objects_recover( param.tmp.manual_label_info , temp_list );
    end
    L1 = param.tmp.manual_label_image;
    L2 = param.tmp.manual_label_image;
    if update_tracking
        [mapping  , unmapped_centroids] = mapping_labels( L1 , L2 );
        tmp = ismember( mapping(:,1) , temp_list );
        mapping = mapping(~tmp,:);
    end
elseif h == h_merge || h == h_split || h == h_create || h == h_remove || h == h_divide
    L1 = param.tmp.manual_label_image;
    if h == h_merge
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_merge(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , temp_list );
    elseif h == h_split
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_split(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , temp_list , true);
    elseif h == h_create
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_create(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , param.hMain.freehand);
        param.hMain.freehand = [];
    elseif h == h_remove
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_remove(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , temp_list );
    elseif h == h_divide
        [ param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info ] = objects_divide(   param.tmp.manual_label_image , param.tmp.manual_label_data , param.tmp.manual_label_info , param.hMain.curve);
        param.hMain.curve = [];
    end
    imwrite(param.tmp.manual_label_image                , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
    savefile(param.tmp.manual_label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
    L2 = param.tmp.manual_label_image;
    if update_tracking
        [mapping  , unmapped_centroids] = mapping_labels( L1 , L2 );
    end
end
savefile(param.tmp.manual_label_info        , 'label_info' , fullfile(directories_label_info{s_id} , filenames_label_info{ s_id,t} ));
param.tmp.manual_list_selected_objects = [];
param = Updatedisplay_Image_1(param);
InformAllInterfaces(param);
if isempty(unmapped_centroids)
    return;
end
%%
%%
%%
%%
if update_feature
    if h == h_split || h == h_merge || h == h_create || h == h_remove || h == h_divide
       if exist(directories_feature{s_id},'dir') == 7
            if exist(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}),'file') == 2
                updatefeature(param.set , directory_nucleimarker , filenames_nucleimarker{s_id,t} , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_feature{s_id} , filenames_feature{s_id,t} );
            end
        end 
    end
end
if update_tracking
    path0 = fullfile(param.tmp.dir_lineage, filenames_track{s_id});
    if exist(path0,'file') == 2
        temp = load(path0);
        track = temp.track;
        if h == h_split || h == h_merge || h == h_create || h == h_remove || h == h_divide || h == h_recover
            if t > 1
                info0 = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id,t-1});
                tmp0 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t-1}));
                coo0 = tmp0.feature_coo_value;
                tbd0 = tmp0.feature_touch_border;
            end
            info1 = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id,t});
            tmp1 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}));
            coo1 = tmp1.feature_coo_value;
            tbd1 = tmp1.feature_touch_border;
            if t < param.tmp.n_time
                info2 = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id,t+1});
                tmp2 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t+1}));
                coo2 = tmp2.feature_coo_value;
                tbd2 = tmp2.feature_touch_border;
            end
            %%
            %%
            if t > 1
                backup1 = track{t};
                track{t} = track_frame_linking( t   , track ,  {info0,info1} , {coo0,coo1} , {tbd0,tbd1} , param.tra.max_frame_displacement , param.set.tracking_max_deviation , include_border_object);
                track{t}(mapping(:,2),:) = backup1(mapping(:,1),:);
            else
                track{t  } = zeros([size(coo1,1),1]);
            end
            if t < param.tmp.n_time
                backup2 = track{t+1};
                track{t+1} = track_frame_linking( t+1 , track ,  {info1,info2} , {coo1,coo2} , {tbd1,tbd2} , param.tra.max_frame_displacement , param.set.tracking_max_deviation , include_border_object);
                tokeep = true([size(coo2,1),1]);
                for kk = 1:size(unmapped_centroids,1)
                    tokeep = tokeep  &  sum( (coo2 - unmapped_centroids(kk,:)).^2 ,2 ) > param.tra.max_frame_displacement^2;
                end
                mapping_aug = [0 0;mapping];
                kept = find(tokeep);
                [id1,id2] = find( mapping_aug(:,1) == backup2(tokeep,:)' );
                track{t+1}(kept(id2),:) = mapping_aug(id1,2);
            end
        elseif h == h_delete
            if t > 1
                track{t  }(  temp_list  ) = 0;
            end
            if t < param.tmp.n_time
                track{t+1}(  ismember(track{t+1},temp_list)  ) = 0;
            end
        end
        savefile( track , 'track' , path0);
    end
end
%%
if update_lineage
    path1 = fullfile(param.tmp.dir_lineage, filenames_lineage{s_id});
    if exist(path1,'file') == 2
        temp1 = load(path1);
        lineage = temp1.lineage;
        lineage = lineage_reconfigure(lineage , t , track);
        savefile( lineage , 'lineage' , path1  );
    end
end
%%
%%
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            if h == h_delete || h == h_recover
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
%profsave
InformAllInterfaces(param);
end