function show_settings( param )
%%
%%
if     param.set.manual_correction_segmentation_update == 1
    set(param.hSettings.Radio51, 'Value', 1);
elseif param.set.manual_correction_segmentation_update == 2
    set(param.hSettings.Radio52, 'Value', 1);
elseif param.set.manual_correction_segmentation_update == 3
    set(param.hSettings.Radio53, 'Value', 1);
elseif param.set.manual_correction_segmentation_update == 4
    set(param.hSettings.Radio54, 'Value', 1);
end
%%
if     param.set.manual_correction_tracking_update == 1
    set(param.hSettings.Radio61, 'Value', 1);
elseif param.set.manual_correction_tracking_update == 2
    set(param.hSettings.Radio62, 'Value', 1);
end
%%
if     param.set.manual_correction_split_size == 1
    set(param.hSettings.Radio71, 'Value', 1);
elseif param.set.manual_correction_split_size == 2
    set(param.hSettings.Radio72, 'Value', 1);
end
%%
if     param.set.segmentation_declump_merge == 1
    set(param.hSettings.Radio41, 'Value', 1);
elseif param.set.segmentation_declump_merge == 2
    set(param.hSettings.Radio42, 'Value', 1);
elseif param.set.segmentation_declump_merge == 3
    set(param.hSettings.Radio43, 'Value', 1);
end
%%
if     param.set.deleted_objects_display == 1
    set(param.hSettings.Radio81, 'Value', 1);
elseif param.set.deleted_objects_display == 2
    set(param.hSettings.Radio82, 'Value', 1);
elseif param.set.deleted_objects_display == 3
    set(param.hSettings.Radio83, 'Value', 1);
end
%%
set(param.hSettings.Edit_scenes_process,'String',param.set.processing_scenes);
%%
set(param.hSettings.Edit_parallel_setting,'String',param.set.processing_number_of_cores);
%%
set(param.hSettings.Edit_segmentation_max_depth,'String',param.set.segmentation_max_depth);
%%
set(param.hSettings.Edit_segmentation_max_runtime,'String',param.set.segmentation_max_runtime);
%%
set(param.hSettings.Edit_tracking_max_deviation,'String',param.set.tracking_max_deviation);
%%
%%
if param.set.calculate_coordinate
    set(param.hSettings.Check_feature_coo, 'Value', 1);
else
    set(param.hSettings.Check_feature_coo, 'Value', 0);
end
if param.set.calculate_shape
    set(param.hSettings.Check_feature_sha, 'Value', 1);
else
    set(param.hSettings.Check_feature_sha, 'Value', 0);
end
if param.set.calculate_intensity
    set(param.hSettings.Check_feature_int, 'Value', 1);
else
    set(param.hSettings.Check_feature_int, 'Value', 0);
end
if param.set.calculate_haralick
    set(param.hSettings.Check_feature_har, 'Value', 1);
else
    set(param.hSettings.Check_feature_har, 'Value', 0);
end
if param.set.calculate_zernike
    set(param.hSettings.Check_feature_zer, 'Value', 1);
else
    set(param.hSettings.Check_feature_zer, 'Value', 0);
end
if param.set.calculate_additional
    set(param.hSettings.Check_feature_add, 'Value', 1);
else
    set(param.hSettings.Check_feature_add, 'Value', 0);
end
%%
end

