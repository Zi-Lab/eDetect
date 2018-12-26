function CallbackMouseClickOnLineage(h,~)
param = guidata(h);
if param.tmp.n_scene == 1
    CurrentScene = param.tmp.min_scene;
else
    CurrentScene = round((get(param.hLineage.SliderFrame1,'Value')));
end
coordinates = get(param.hLineage.axes1,'CurrentPoint'); 
x = round(coordinates(1,1)+0.0);
y = round(coordinates(1,2)+0.0);
m_type = get(param.hLineage.fig, 'selectionType');
if strcmp(m_type, 'normal')
    if param.tmp.filtered_lineage_tree(y,x) ~= 0
        param.tmp.manual_list_selected_objects = param.tmp.filtered_lineage_tree(y,x);
    else
        param.tmp.manual_list_selected_objects = [];
    end
    if param.tmp.n_scene ~= 1
        set(param.hMain.SliderFrame1, 'value', CurrentScene);
    end
    set(param.hMain.SliderFrame2, 'value', param.tmp.frames_displayed(x));
    param = Updatedisplay_Image_1(param);
elseif strcmp(m_type, 'alt')
    param.tmp.row_for_synchrogram = y;
    param.tmp.col_for_synchrogram = x;
    
    param = Synchrogram(param);
elseif strcmp(m_type, 'open')

end
%%
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
param.tmp.manual_list_selected_scene_frame(1) = CurrentScene;
param.tmp.manual_list_selected_scene_frame(2) = param.tmp.frames_displayed(x);
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            param = Updatedisplay_Segmentationgating_00(param);
        end
    end
end
InformAllInterfaces(param);
end