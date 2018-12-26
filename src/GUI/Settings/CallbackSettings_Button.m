function CallbackSettings_Button( h , ~ )
param = guidata(h);
%
if     get(param.hSettings.Radio_importsegmentation1,'Value') == 1
    param.set.source_segmentation = 1;
elseif get(param.hSettings.Radio_importsegmentation2,'Value') == 1
    param.set.source_segmentation = 2;
else
    
end
%
if     get(param.hSettings.Radio_importtracking1,'Value') == 1
    param.set.source_tracking = 1;
elseif get(param.hSettings.Radio_importtracking2,'Value') == 1
    param.set.source_tracking = 2;
else
    
end
%
%{
if     get(param.hSettings.Radio81,'Value') == 1
    param.set.deleted_objects_display = 1;
elseif get(param.hSettings.Radio82,'Value') == 1
    param.set.deleted_objects_display = 2;
elseif get(param.hSettings.Radio83,'Value') == 1
    param.set.deleted_objects_display = 3;
else
    
end
%}
%
if     get(param.hSettings.Radio51,'Value') == 1
    param.set.manual_correction_segmentation_update = 1;
elseif get(param.hSettings.Radio52,'Value') == 1
    param.set.manual_correction_segmentation_update = 2;
elseif get(param.hSettings.Radio53,'Value') == 1
    param.set.manual_correction_segmentation_update = 3;
elseif get(param.hSettings.Radio54,'Value') == 1
    param.set.manual_correction_segmentation_update = 4;
else
    
end
%
if     get(param.hSettings.Radio61,'Value') == 1
    param.set.manual_correction_tracking_update = 1;
elseif get(param.hSettings.Radio62,'Value') == 1
    param.set.manual_correction_tracking_update = 2;
else
    
end
%
%{
if     get(param.hSettings.Radio71,'Value') == 1
    param.set.manual_correction_split_size = 1;
elseif get(param.hSettings.Radio72,'Value') == 1
    param.set.manual_correction_split_size = 2;
else
    
end
%}
%
if     get(param.hSettings.Radio41,'Value') == 1
    param.set.segmentation_declump_merge = 1;
elseif get(param.hSettings.Radio42,'Value') == 1
    param.set.segmentation_declump_merge = 2;
elseif get(param.hSettings.Radio43,'Value') == 1
    param.set.segmentation_declump_merge = 3;
else
    
end
%%
if get(param.hSettings.Radio_track_border_1,'Value') == 1
    param.set.border_objects_tracked = 1;
elseif get(param.hSettings.Radio_track_border_2,'Value') == 1
    param.set.border_objects_tracked = 2;
end
%%
%set(param.hSettings.Check_feature_coo, 'Value', 1);
%if get(param.hSettings.Check_feature_coo , 'value') == 1
%    param.set.calculate_coordinate = true;
%else
%    param.set.calculate_coordinate = false;
%end
set(param.hSettings.Check_feature_sha, 'Value', 1);
if get(param.hSettings.Check_feature_sha , 'value') == 1
    param.set.calculate_shape = true;
else
    param.set.calculate_shape = false;
end
if get(param.hSettings.Check_feature_int , 'value') == 1
    param.set.calculate_intensity = true;
else
    param.set.calculate_intensity = false;
end
if get(param.hSettings.Check_feature_har , 'value') == 1
    param.set.calculate_haralick = true;
else
    param.set.calculate_haralick = false;
end
if get(param.hSettings.Check_feature_zer , 'value') == 1
    param.set.calculate_zernike = true;
else
    param.set.calculate_zernike = false;
end
if get(param.hSettings.Check_feature_add , 'value') == 1
    param.set.calculate_additional = true;
else
    param.set.calculate_additional = false;
end
%%
param = CheckStatus( param );
%%
%MsgBoxH = findall(0,'Type','figure','Name','Information');
%close(MsgBoxH);
InformAllInterfaces(param);
%msgbox('Settings updated.','Information','help');
end

