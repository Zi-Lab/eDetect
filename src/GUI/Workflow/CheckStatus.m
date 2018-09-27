function [ param ] = CheckStatus( param )
if ~isvalid(param.hMain.fig)
    return;
end
set(param.hMain.pushtool_parameters                 , 'Enable', 'off');
set(param.hMain.pushtool_settings                   , 'Enable', 'off');
%
set(param.hMain.pushtool_cellsegmentation           , 'Enable', 'off');
set(param.hMain.pushtool_featureextraction          , 'Enable', 'off');
set(param.hMain.pushtool_celltracking               , 'Enable', 'off');
set(param.hMain.pushtool_celllineagereconstruction  , 'Enable', 'off');
set(param.hMain.pushtool_measurement                , 'Enable', 'off');
%
set(param.hMain.pushtool_segmentationgating         , 'Enable', 'off');
set(param.hMain.pushtool_cellpairgating             , 'Enable', 'off');
set(param.hMain.pushtool_celllineagesdisplay        , 'Enable', 'off');
%%
flag_label_nuclei = true;
flag_feature = true;
flag_track = true;
flag_lineage = true;
%flag_label_measure = true;
%%
flag_param_segmentation = check_parameters_seg(false , param.seg.min_object , param.seg.med_object , param.seg.max_object);
flag_param_tracking     = check_parameters_tra(false , param.tra.max_frame_displacement);
flag_param_measurement  = check_parameters_exp(false , param.dir.dir_proteinofinterest , param.exp.nuclei_radii , param.exp.cytoplasm_ring_inner_radii , param.exp.cytoplasm_ring_outer_radii );
if isempty(param.dir.dir_proteinofinterest) || isempty(param.met.filename_format_proteinofinterest)
    flag_param_measurement = false;
end
%%
%%
flag_nm = CheckInputImages(param.tmp.dir_nucleimarker      , param.tmp.filenames_nucleimarker     , param.tmp.scenes_all , param.set.processing_scenes , param.tmp.n_time , false);
flag_pi = CheckInputImages(param.tmp.dir_proteinofinterest , param.tmp.filenames_proteinofinterest, param.tmp.scenes_all , param.set.processing_scenes , param.tmp.n_time , false);
%%
scene_array = str2double(strsplit(param.set.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
%%
if flag_nm
    set(param.hMain.pushtool_parameters       , 'Enable', 'on');
    set(param.hMain.pushtool_settings         , 'Enable', 'on');
    if flag_param_segmentation
        set(param.hMain.pushtool_cellsegmentation , 'Enable', 'on');
    end
    %%
    for i = 1:length(scene_array)
        id = find(param.tmp.scenes_all == scene_array(i));
        if exist(param.tmp.dir_label_nuclei,'dir') == 7
            for j = 1:size(param.tmp.filenames_label_gray,2)
                if exist(fullfile(param.tmp.directories_label_gray{id},param.tmp.filenames_label_gray{id,j}),'file') ~= 2
                    flag_label_nuclei = false;
                end
                if exist(fullfile(param.tmp.directories_label_data{id},param.tmp.filenames_label_data{id,j}),'file') ~= 2
                    flag_label_nuclei = false;
                end
            end
        else
            flag_label_nuclei = false;
        end
        if exist(param.tmp.dir_feature,'dir') == 7
            for j = 1:size(param.tmp.filenames_feature,2)
                if exist(fullfile(param.tmp.directories_feature{id},param.tmp.filenames_feature{id,j}),'file') ~= 2
                    flag_feature = false;
                end
            end
        else
            flag_feature = false;
        end
        if exist(param.tmp.dir_lineage,'dir') == 7
            if exist(fullfile(param.tmp.dir_lineage,param.tmp.filenames_track{id}),'file') ~= 2
                flag_track = false;
            end
            if exist(fullfile(param.tmp.dir_lineage,param.tmp.filenames_lineage{id}),'file') ~= 2
                flag_lineage = false;
            end
        else
            flag_track = false;
            flag_lineage = false;
        end
    end
    %%
    if flag_label_nuclei
        set(param.hMain.pushtool_featureextraction      , 'Enable', 'on');
    end
    if flag_label_nuclei && flag_feature
        set(param.hMain.pushtool_segmentationgating         , 'Enable', 'on');
        if flag_param_tracking
            set(param.hMain.pushtool_celltracking               , 'Enable', 'on');
        end
    end
    if flag_label_nuclei && flag_feature && flag_track
        set(param.hMain.pushtool_cellpairgating             , 'Enable', 'on');
        set(param.hMain.pushtool_celllineagereconstruction  , 'Enable', 'on');
    end
    if flag_label_nuclei && flag_feature && flag_lineage
        set(param.hMain.pushtool_celllineagesdisplay        , 'Enable', 'on');
        if flag_pi && flag_param_measurement
            set(param.hMain.pushtool_measurement            , 'Enable', 'on');
        end
    end
end
%%
%% toolbar 2: manual correction and display control
if isempty(param.tmp.manual_label_image) || isempty(param.tmp.manual_label_data)
    set(param.hMain.pushtool_draw_polygon      , 'Enable', 'off');
    set(param.hMain.pushtool_deselect_all      , 'Enable', 'off');
    set(param.hMain.pushtool_delete_objects    , 'Enable', 'off');
    set(param.hMain.pushtool_recover_objects   , 'Enable', 'off');
    set(param.hMain.pushtool_split_objects     , 'Enable', 'off');
    set(param.hMain.pushtool_merge_objects     , 'Enable', 'off');
    set(param.hMain.pushtool_get_parent        , 'Enable', 'off');
    set(param.hMain.pushtool_set_parent        , 'Enable', 'off');
    set(param.hMain.toggletool_overlay         , 'Enable', 'off');
else
    set(param.hMain.pushtool_draw_polygon      , 'Enable', 'on');
    set(param.hMain.pushtool_deselect_all      , 'Enable', 'on');
    set(param.hMain.pushtool_delete_objects    , 'Enable', 'on');
    set(param.hMain.pushtool_recover_objects   , 'Enable', 'on');
    set(param.hMain.pushtool_split_objects     , 'Enable', 'on');
    set(param.hMain.pushtool_merge_objects     , 'Enable', 'on');
    set(param.hMain.pushtool_get_parent        , 'Enable', 'on');
    set(param.hMain.pushtool_set_parent        , 'Enable', 'on');
    set(param.hMain.toggletool_overlay         , 'Enable', 'on');
end
%%
if flag_pi
    set(param.hMain.toggletool_channel         , 'Enable', 'on');
else
    set(param.hMain.toggletool_channel         , 'Enable', 'off');
end
%%
if isfield(param.hMain,'Text5')
    if isempty(param.tmp.manual_label_image) || isempty(param.tmp.manual_label_data)
        set(param.hMain.Edit5,'Enable','off');
        set(param.hMain.SliderFrame5,'Enable','off');
    else
        set(param.hMain.Edit5,'Enable','on');
        set(param.hMain.SliderFrame5,'Enable','on');
    end
end
%%
end

