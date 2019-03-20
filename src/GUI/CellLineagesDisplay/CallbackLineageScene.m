function CallbackLineageScene(h,~)
param = guidata(h);
if param.tmp.n_scene ~= 1
    CurrentLineageScene = round((get(param.hLineage.SliderFrame1,'Value')));
    set(param.hMain.SliderFrame1, 'value', CurrentLineageScene);
end
param.tmp.manual_list_selected_objects = [];
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
param.hLineage.Edit_cmin.String = '';
param.hLineage.Edit_cmax.String = '';
param = Updatedisplay_Image_1(param);
param = Updatedisplay_Heatmap_3(param);
InformAllInterfaces(param);
end