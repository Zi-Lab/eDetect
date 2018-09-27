function [ param ] = InitializeVariables
%%
param.tmp.path_projectfile      = '';
param.tmp.dir_nucleimarker      = '';
param.tmp.dir_proteinofinterest = '';
param.tmp.dir_label_nuclei      = '';
param.tmp.dir_feature           = '';
param.tmp.dir_lineage           = '';
param.tmp.dir_label_measurement = '';
param.tmp.dir_measurement       = '';
%
param.tmp.filename_format_nucleimarker = [];
param.tmp.filename_format_proteinofinterest = [];
param.tmp.digits_scene = [];
param.tmp.digits_time = [];
param.tmp.filenames_nucleimarker = [];
param.tmp.filenames_proteinofinterest = [];
param.tmp.min_scene = [];
param.tmp.max_scene = [];
param.tmp.min_time = [];
param.tmp.max_time = [];
param.tmp.n_scene = [];
param.tmp.n_time = [];
param.tmp.times_all = [];
param.tmp.scenes_all = [];
param.tmp.scenes_for_gating = [];
%
param.tmp.I = [];
param.tmp.h = [];
param.tmp.w = [];
param.tmp.val_min = [];
param.tmp.val_max = [];
param.tmp.val_range = [];
%
param.tmp.manual_list_selected_objects = [];
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
param.tmp.manual_label_image = [];
param.tmp.manual_label_data  = [];
param.tmp.manual_label_info  = [];
%
param.tmp.track_feature = [];
param.tmp.feature_names = [];
param.tmp.previous_feature_name = [];
param.tmp.current_feature_name = [];
param.tmp.manual_track = [];
%
param.tmp.manual_lineage_tree = [];
param.tmp.manual_lineage_data = [];
param.tmp.lineage_filter = [];
param.tmp.filtered_lineage_tree = [];
param.tmp.filtered_lineage_data = [];
param.tmp.frames_displayed = [];
param.tmp.frames_display_min = [];
param.tmp.frames_display_max = [];
param.tmp.zoomin_vertical = [];
param.tmp.zoomin_horizontal = [];
param.tmp.lineage_diplay_divisions = [];
param.tmp.frames_filter_min = [];
param.tmp.frames_filter_max = [];
param.tmp.frames_filter_len = [];
%
param.tmp.segmentation_gating_selected = [];
param.tmp.pair_gating_selected = [];
param.tmp.pair_gating_data_cell_array = [];
param.tmp.label_segmentation_gating = [];
param.tmp.label_pair_gating = [];
param.tmp.pc_segmentationgating = [];
param.tmp.pc_cellpairgating = [];
param.tmp.gating_deleted = [];
param.tmp.pair_gating_markedmitotic = [];
param.tmp.deleted_cells = [];
param.tmp.marked_mitosis = [];
param.tmp.pair_intersections = [];
param.tmp.gating_update_image_list = [];
%
param.tmp.manual_list_selected_scene_frame = [];
%param.tmp.selected_feature_ids_segmentationgating = [];
%param.tmp.selected_feature_ids_cellpairgating = [];
%%
screensize = get( 0 , 'Screensize' );
param.tmp.w_sc = screensize(3);
param.tmp.h_sc = screensize(4);
param.tmp.w_ctrl_1 = 125;
param.tmp.w_ctrl_2 = 155;
param.tmp.h_p1 = 150;
param.tmp.h_p2 = 300;
param.tmp.h_p3 = 240;
param.tmp.h_p4 = 120;
param.tmp.h_p5 = 200;
param.tmp.w_axes_1 = min(1000 - param.tmp.w_ctrl_1 , param.tmp.w_sc - param.tmp.w_ctrl_1);
param.tmp.x_leftbottom_1 = round((param.tmp.w_sc - param.tmp.w_ctrl_1 - param.tmp.w_axes_1 )/ 2) + 1;
param.tmp.y_leftbottom_1 = round((param.tmp.h_sc - param.tmp.h_p1    - param.tmp.h_p2)/ 2) + 1;
param.tmp.w_axes_2 = min(1000 - param.tmp.w_ctrl_2 , param.tmp.w_sc - param.tmp.w_ctrl_2);
param.tmp.x_leftbottom_2 = round((param.tmp.w_sc - param.tmp.w_ctrl_2 - param.tmp.w_axes_2 )/ 2) + 1;
param.tmp.y_leftbottom_2 = round((param.tmp.h_sc - param.tmp.h_p1    - param.tmp.h_p2)/ 2) + 1;
%%
param.tmp.outlier_before = 6;
param.tmp.outlier_after = 6;
param.tmp.outlier_nosd = 15;
param.tmp.h_synchrogram_slider = 20;
param.tmp.r_synchrogram_crop = [];
param.tmp.h_synchrogram_crop = [];
param.tmp.d_synchrogram_crop = 2;
param.tmp.n_synchrogram_crop = [];
param.tmp.I_synchrogram_stack = [];
param.tmp.row_for_synchrogram = [];
param.tmp.col_for_synchrogram = [];
%%
end
%%