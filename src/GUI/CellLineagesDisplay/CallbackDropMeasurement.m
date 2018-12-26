function CallbackDropMeasurement(h,~)
param = guidata(h);
current_feature_id = get(param.hLineage.Drop1,'Value');
param.tmp.current_feature_name = param.tmp.feature_names(current_feature_id);
if ~strcmp(param.tmp.previous_feature_name , param.tmp.current_feature_name)
    try
        set(param.hLineage.Edit_cmin,'String','');
        set(param.hLineage.Edit_cmax,'String','');
        param = Updatedisplay_Heatmap_2(param);
    catch
        msgbox('Please re-run measurement after object splitting or merging.','Error','error');
        return;
    end
    param.tmp.previous_feature_name = param.tmp.current_feature_name;
end
InformAllInterfaces(param);
end