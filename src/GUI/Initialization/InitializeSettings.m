function [ param ] = InitializeSettings
param.set.manual_correction_segmentation_update = 4;
param.set.manual_correction_tracking_update = 2;
param.set.manual_correction_split_size = 2;
param.set.processing_number_of_cores = 1;
param.set.segmentation_declump_merge = 3;
param.set.deleted_objects_display = 1;
param.set.processing_scenes = '';
param.set.segmentation_max_depth = 3;
param.set.segmentation_max_runtime = 100;
param.set.calculate_coordinate = true;
param.set.calculate_shape = true;
param.set.calculate_intensity = false;
param.set.calculate_haralick = false;
param.set.calculate_zernike = false;
param.set.calculate_additional = true;
param.set.tracking_max_deviation = 0;
%%
%n_processors = str2double(getenv('NUMBER_OF_PROCESSORS'));
core_info = evalc('feature(''numcores'')');
temp0 = strsplit(core_info,' logical cores by the OS.');
temp1 = strsplit(temp0{1},'MATLAB was assigned: ');
n_processors = str2double(temp1{2});
if n_processors > 2
    param.set.processing_number_of_cores = n_processors - 1;
else
    param.set.processing_number_of_cores = 1;
end
try
   tmp = ver('distcomp');
catch
   %fprintf('Not installed');
   param.set.processing_number_of_cores = 1;
end
end
%%