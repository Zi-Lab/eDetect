function [ param ] = InitializeSettings
%param.set.manual_correction_split_size = 2;
param.set.manual_correction_segmentation_update = 4;
param.set.manual_correction_tracking_update = 2;
param.set.segmentation_declump_merge = 3;
param.set.deleted_objects_display = 1;
param.set.segmentation_max_depth = 3;
param.set.segmentation_max_runtime = 100;
param.set.calculate_coordinate = true;
param.set.calculate_shape = true;
param.set.calculate_intensity = false;
param.set.calculate_haralick = false;
param.set.calculate_zernike = false;
param.set.calculate_additional = true;
param.set.tracking_max_deviation = 0;
param.set.segmentation_medfilt2size = 5;
param.set.segmentation_gaufilt2size = 1;
param.set.segmentation_gaufilt2sigm = 1;
param.set.segmentation_sensitivity = 0.5;
param.set.border_objects_tracked = 1;
param.set.source_segmentation = 1;
param.set.source_tracking = 1;
%%

end
%%