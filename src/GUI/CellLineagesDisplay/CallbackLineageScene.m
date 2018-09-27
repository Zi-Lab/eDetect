function CallbackLineageScene(h,~)
param = guidata(h);
if param.tmp.n_scene ~= 1
    CurrentLineageScene = round((get(param.hLineage.SliderFrame1,'Value')));
    set(param.hMain.SliderFrame1, 'value', CurrentLineageScene);
end
param = Updatedisplay_Image_1(param);
param = Updatedisplay_Heatmap_3(param);
InformAllInterfaces(param);
end