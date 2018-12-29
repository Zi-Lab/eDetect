function EditSegmentationPolygonObjects(h,~)
param = guidata(h);
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
directory_lineage = param.tmp.dir_lineage;
%%
h_split = param.hNucleiSegmentationGating.pushtool_objects_split;
h_remove = param.hNucleiSegmentationGating.pushtool_objects_remove;
h_delete = param.hNucleiSegmentationGating.pushtool_objects_delete;
h_recover = param.hNucleiSegmentationGating.pushtool_objects_recover;
scenes_all = param.tmp.scenes_all;
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
if param.set.border_objects_tracked == 1
    include_border_object = false;
else
    include_border_object = true;
end
%%
new_labels = param.tmp.label_segmentation_gating(param.tmp.segmentation_gating_selected,:);
if isempty(new_labels)
    return;
end
[C,~,IC] = unique(new_labels(:,[1 2]),'rows','sorted');
np = size(C,1);
temp_cell_array = cell([np,1]);
for i = 1:np
    temp_cell_array{i,1} = new_labels(IC == i,3);
end
%mapping = cell([np,1]);
%unmapped_centroids = cell([np,1]);
param.tmp.gating_update_image_list = C;
param_set = param.set;
param_tra = param.tra;
n_time = param.tmp.n_time;
parfor l = 1:np
    s = C(l,1);
    t = C(l,2);
    s_id = find(scenes_all == s);
    if h == h_delete || h == h_recover
        [label_info]  = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id , t});
        if h == h_delete
            [ new_label_info ] = objects_delete(  label_info , temp_cell_array{l} );
        elseif h == h_recover
            [ new_label_info ] = objects_recover( label_info , temp_cell_array{l} );
        end
        savefile(new_label_info , 'label_info' , fullfile(directories_label_info{s_id} , filenames_label_info{ s_id,t} ));
    elseif h == h_split || h == h_remove
        [label_image] = get_label_image(directories_label_gray{s_id} , filenames_label_gray{s_id , t});
        [label_data]  = get_label_data( directories_label_data{s_id} , filenames_label_data{s_id , t});
        [label_info]  = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id , t});
        if h == h_split
            [ new_label_image , new_label_data , new_label_info] = objects_split( label_image , label_data , label_info , temp_cell_array{l} , true);
        elseif h == h_remove
            [ new_label_image , new_label_data , new_label_info ] = objects_remove(   label_image , label_data , label_info , temp_cell_array{l} );
        end
        imwrite(new_label_image                , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id , t} ));
        savefile(new_label_data , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id , t} ));
        savefile(new_label_info , 'label_info' , fullfile(directories_label_info{s_id} , filenames_label_info{ s_id , t} ));
    end
end
if isfield(param.hNucleiSegmentationGating,'poly')
    for i = 1:length(param.hNucleiSegmentationGating.poly)
        delete(param.hNucleiSegmentationGating.poly(i));
    end
    param.hNucleiSegmentationGating = rmfield(param.hNucleiSegmentationGating,'poly');
end
param.tmp.segmentation_gating_selected = false([size(param.tmp.pc_segmentationgating,1),1]);
ll = length(param.hNucleiSegmentationGating.axes1.Children);
for i = ll:(-1):1
    if isa(param.hNucleiSegmentationGating.axes1.Children(i),'matlab.graphics.primitive.Group')
        delete(param.hNucleiSegmentationGating.axes1.Children(i));
    end
end
%%
%%
%%
for l = 1:np
    s = C(l,1);
    t = C(l,2);
    s_id = find(scenes_all == s);
    if update_feature
        if h == h_split || h == h_remove
            s_id = find(scenes_all == s);
            if exist(directories_feature{s_id},'dir') == 7
                if exist(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}),'file') == 2
                    updatefeature(param_set , directory_nucleimarker , filenames_nucleimarker{s_id,t} , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_feature{s_id} , filenames_feature{s_id,t} );
                end
            end
        end
    end
    if update_tracking
        path0 = fullfile(directory_lineage, filenames_track{s_id});
        if exist(path0,'file') == 2
            temp = load(path0);
            track = temp.track;
            if h == h_split || h == h_recover || h == h_remove
                if t > 1
                    info0 = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t-1});
                    tempdata0 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t-1}));
                    coo0 = tempdata0.feature_coo_value;
                    tbd0 = tempdata0.feature_touch_border;
                end
                info1 = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t});
                tempdata1 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}));
                coo1 = tempdata1.feature_coo_value;
                tbd1 = tempdata1.feature_touch_border;
                if t < n_time
                    info2 = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t+1});
                    tempdata2 = load(fullfile(directories_feature{s_id} , filenames_feature{s_id,t+1}));
                    coo2 = tempdata2.feature_coo_value;
                    tbd2 = tempdata2.feature_touch_border;
                end
                if t > 1
                    [ track{t}   ] = track_frame_linking( t   , track ,  {info0,info1} , {coo0,coo1} , {tbd0,tbd1} , param_tra.max_frame_displacement , param_set.tracking_max_deviation , include_border_object);
                else
                    [ track{t}   ] = zeros([size(coo1,1),1]);
                end
                if t < n_time
                    [ track{t+1} ] = track_frame_linking( t+1 , track ,  {info1,info2} , {coo1,coo2} , {tbd1,tbd2} , param_tra.max_frame_displacement , param_set.tracking_max_deviation , include_border_object);
                end
            elseif h == h_delete
                if t > 1
                    track{t  }(  temp_cell_array{l}  ) = 0;
                end
                if t < n_time
                    track{t+1}(  ismember(track{t+1} , temp_cell_array{l})  ) = 0;
                end
            end
            savefile( track , 'track' , path0);
        end
    end
    if update_lineage
        path1 = fullfile(directory_lineage, filenames_lineage{s_id});
        if exist(path1,'file') == 2
            temp1 = load(path1);
            lineage = temp1.lineage;
            lineage = lineage_reconfigure(lineage , t , track);
            savefile( lineage , 'lineage' , path1  );
        end
    end
end
%%
%%
%%
%%
if update_feature
    if h == h_delete || h == h_recover
        param = Updatedisplay_Segmentationgating_1(param , true , new_labels(:,1:2));
    else
        param = Updatedisplay_Segmentationgating_2(param , true , new_labels(:,1:2));
    end
end
if isfield(param,'hNucleiCellpairGating')
    if isfield(param.hNucleiCellpairGating,'fig')
        if isgraphics(param.hNucleiCellpairGating.fig)
            param = Updatedisplay_Cellpairgating_2(param , true , [new_labels(:,1:2); [new_labels(:,1) new_labels(:,2)+1]]);
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
if isfield(param,'hSynchrogram')
    if isfield(param.hSynchrogram,'fig')
        if isgraphics(param.hSynchrogram.fig)
            close(param.hSynchrogram.fig);
        end
    end
end
%%
param.tmp.manual_list_selected_objects = [];
param = Updatedisplay_Image_1(param);
InformAllInterfaces(param);
end