function updatefeature( param_set , directory_nucleimarker , filename_nucleimarker , directory_label_gray , filename_label_gray , directory_feature , filename_feature )
if exist(directory_feature,'dir') ~= 7
    mkdir( directory_feature );
end
I_temp = imread(fullfile(directory_nucleimarker , filename_nucleimarker));
[ label_gray_array ] = get_label_image(directory_label_gray , filename_label_gray );
filepathname = fullfile(directory_feature , filename_feature);
if param_set.calculate_coordinate
    [ feature_coo_value , feature_coo_name ] = calculate_feature_coordinate( label_gray_array );
    savefile(feature_coo_value,    'feature_coo_value'    ,filepathname);
    savefile(feature_coo_name,     'feature_coo_name'     ,filepathname);
end
if param_set.calculate_shape
    [ feature_sha_value , feature_sha_name ] = calculate_feature_shape(      label_gray_array , I_temp);
    savefile(feature_sha_value,    'feature_sha_value'    ,filepathname);
    savefile(feature_sha_name,     'feature_sha_name'     ,filepathname);
end
if param_set.calculate_intensity
    [ feature_int_value , feature_int_name ] = calculate_feature_intensity( label_gray_array, I_temp );
    savefile(feature_int_value,    'feature_int_value'    ,filepathname);
    savefile(feature_int_name,     'feature_int_name'     ,filepathname);
end
if param_set.calculate_haralick
    [ feature_har_value , feature_har_name ] = calculate_feature_haralick( label_gray_array , I_temp );
    savefile(feature_har_value,    'feature_har_value'    ,filepathname);
    savefile(feature_har_name,     'feature_har_name'     ,filepathname);
end
if param_set.calculate_zernike
    [ feature_zer_value , feature_zer_name ] = calculate_feature_zernike(    label_gray_array );
    savefile(feature_zer_value,    'feature_zer_value'    ,filepathname);
    savefile(feature_zer_name,     'feature_zer_name'     ,filepathname);
end
if param_set.calculate_additional
    [ feature_add_value , feature_add_name ] = calculate_feature_additional(    label_gray_array , I_temp );
    savefile(feature_add_value,    'feature_add_value'    ,filepathname);
    savefile(feature_add_name,     'feature_add_name'     ,filepathname);
end
[ feature_touch_border ] = calculate_feature_touch_border( label_gray_array );
savefile(feature_touch_border, 'feature_touch_border' ,filepathname);
end