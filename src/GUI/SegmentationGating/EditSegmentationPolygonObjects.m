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
new_labels = param.tmp.label_segmentation_gating(param.tmp.segmentation_gating_selected,:);
if isempty(new_labels)
    return;
end
temp_cell_array = cell([max(new_labels(:,2)),max(new_labels(:,1))]);
for i = 1:size(new_labels,1)
    temp_cell_array{new_labels(i,2),new_labels(i,1)} = [temp_cell_array{new_labels(i,2),new_labels(i,1)} , new_labels(i,3)];
end
param.tmp.gating_update_image_list = zeros([0,2]);
for i = unique(new_labels(:,1))'
    s = i;
    s_id = find(param.tmp.scenes_all == s);
    for j = unique(new_labels(new_labels(:,1) == s,2))'
        t = j;
        if ~isempty(temp_cell_array{t,s})
            param.tmp.gating_update_image_list = [param.tmp.gating_update_image_list; s t];
            if h == param.hNucleiSegmentationGating.pushtool_objects_delete || h == param.hNucleiSegmentationGating.pushtool_objects_recover
                [label_info] = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t});
                if h == param.hNucleiSegmentationGating.pushtool_objects_delete
                    [ new_label_info ] = objects_delete(  label_info , temp_cell_array{t,s} );
                elseif h == param.hNucleiSegmentationGating.pushtool_objects_recover
                    [ new_label_info ] = objects_recover( label_info , temp_cell_array{t,s} );
                end
                savefile(new_label_info        , 'label_info' , fullfile(directories_label_info{s_id} , filenames_label_info{ s_id,t} ));
            elseif h == param.hNucleiSegmentationGating.pushtool_objects_split
                [label_image] = get_label_image(directories_label_gray{s_id} , filenames_label_gray{s_id , t});
                [label_data]  = get_label_data( directories_label_data{s_id} , filenames_label_data{s_id , t});
                [label_info]  = get_label_info( directories_label_info{s_id} , filenames_label_info{s_id , t});
                if     param.set.manual_correction_split_size == 1
                    [ new_label_image , new_label_data , new_label_info] = objects_split( label_image , label_data , label_info , temp_cell_array{t,s} , true);
                elseif param.set.manual_correction_split_size == 2
                    [ new_label_image , new_label_data , new_label_info] = objects_split( label_image , label_data , label_info , temp_cell_array{t,s} , false);
                end
                imwrite(new_label_image                       , fullfile(directories_label_gray{s_id} , filenames_label_gray{ s_id,t} ));
                %imwrite(label2text(new_label_image , 'black') , fullfile(directories_label_color{s_id}, filenames_label_color{s_id,t} ));
                savefile(new_label_data        , 'label_data' , fullfile(directories_label_data{s_id} , filenames_label_data{ s_id,t} ));
                savefile(new_label_info        , 'label_info' , fullfile(directories_label_info{s_id} , filenames_label_info{ s_id,t} ));
            else

            end
            
        end
    end
end
if isfield(param.hNucleiSegmentationGating,'poly')
    delete(param.hNucleiSegmentationGating.poly);
    param.hNucleiSegmentationGating = rmfield(param.hNucleiSegmentationGating,'poly');
end
param.tmp.segmentation_gating_selected = false([size(param.tmp.pc_segmentationgating,1),1]);
l = length(param.hNucleiSegmentationGating.axes1.Children);
for i = l:(-1):1
    if isa(param.hNucleiSegmentationGating.axes1.Children(i),'matlab.graphics.primitive.Group')
        delete(param.hNucleiSegmentationGating.axes1.Children(i));
    end
end
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
if h == param.hNucleiSegmentationGating.pushtool_objects_split || h == param.hNucleiSegmentationGating.pushtool_objects_recover
    if update_feature
        if h == param.hNucleiSegmentationGating.pushtool_objects_split
            for i = unique(new_labels(:,1))'
                for j = unique(new_labels(new_labels(:,1) == i,2))'
                    if ~isempty(temp_cell_array{j,i})
                        s = i;
                        t = j;
                        s_id = find(param.tmp.scenes_all == s);
                        if exist(directories_feature{s_id},'dir') == 7
                            if exist(fullfile(directories_feature{s_id} , filenames_feature{s_id,t}),'file') == 2
                                updatefeature(param.set , directory_nucleimarker , filenames_nucleimarker{s_id,t} , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_feature{s_id} , filenames_feature{s_id,t} );
                            end
                        end
                    end
                end
            end
        end
        if update_tracking
            for i = unique(new_labels(:,1))'
                for j = unique(new_labels(new_labels(:,1) == i,2))'
                    if ~isempty(temp_cell_array{j,i})
                        s = i;
                        t = j;
                        s_id = find(param.tmp.scenes_all == s);
                        path0 = fullfile(directory_lineage, filenames_track{s_id});
                        if exist(path0,'file') == 2
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
                            if t < param.tmp.n_time
                                info2 = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t+1});
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
                                path1 = fullfile(directory_lineage, filenames_lineage{s_id});
                                if exist(path1,'file') == 2
                                    temp1 = load(path1);
                                    lineage = temp1.lineage;
                                    lineage = lineage_reconfigure(lineage,t,track);
                                    savefile( lineage , 'lineage' , path1  );
                                end
                            end
                        end
                    end
                end
            end
        end
    end
elseif h == param.hNucleiSegmentationGating.pushtool_objects_delete
    if update_tracking
        for i = unique(new_labels(:,1))'
            for j = unique(new_labels(new_labels(:,1) == i,2))'
                if ~isempty(temp_cell_array{j,i})
                    s = i;
                    t = j;
                    s_id = find(param.tmp.scenes_all == s);
                    path0 = fullfile(directory_lineage, filenames_track{s_id});
                    if exist(path0,'file') == 2
                        temp = load(path0);
                        track = temp.track;
                        if t > 1
                            track{t  }(  temp_cell_array{t,s}  ) = 0;
                        end
                        if t < param.tmp.n_time
                            track{t+1}(  ismember(track{t+1} , temp_cell_array{t,s})  ) = 0;
                        end
                        savefile( track , 'track' , path0);
                        if update_lineage
                            path1 = fullfile(directory_lineage, filenames_lineage{s_id});
                            if exist(path1,'file') == 2
                                temp1 = load(path1);
                                lineage = temp1.lineage;
                                for ii = temp_cell_array{t,s}
                                    [ lineage ]  = lineage_edit( lineage , t   , ii , 0 );
                                end
                                if t < param.tmp.n_time
                                    for ii = temp_cell_array{t,s}
                                        tmp = lineage(lineage(:,t) == ii & lineage(:,t+1) > 0,t+1)';
                                        for jj = tmp
                                            [ lineage ]  = lineage_edit( lineage , t+1 , jj , 0 );
                                        end
                                    end
                                end
                                savefile( lineage , 'lineage' , path1  );
                            end
                        end
                    end
                end
            end
        end
    end
end
%%
if update_feature
    if h == param.hNucleiSegmentationGating.pushtool_objects_delete || h == param.hNucleiSegmentationGating.pushtool_objects_recover
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