function CallbackMouseClickOnCellpairGating(h,~)
param = guidata(h);
if isempty(param.tmp.pc_cellpairgating)
    return;
end
coordinates  = get(param.hNucleiCellpairGating.axes1,'CurrentPoint'); 
x = coordinates(1,1);
y = coordinates(1,2);
dist = sum((param.tmp.pc_cellpairgating(:,1:2) - [x y]).^2,2);
[~,id] = min(dist);
m_type = get(param.hNucleiCellpairGating.fig, 'selectionType');
if strcmp(m_type, 'normal')
    param.tmp.cellpair_gating_selected(id) = true;
elseif strcmp(m_type, 'alt')
    param.tmp.cellpair_gating_selected(id) = false;
elseif strcmp(m_type, 'open')

end
CurrentScene = param.tmp.label_cellpair_gating(id,1);
CurrentFrame = param.tmp.label_cellpair_gating(id,2);
clickedObject1 = param.tmp.label_cellpair_gating(id,4);
clickedObject2 = param.tmp.label_cellpair_gating(id,5);
param.tmp.manual_list_selected_objects = [clickedObject1 clickedObject2];
set(param.hMain.Edit1,'String',num2str(CurrentScene));
set(param.hMain.Edit2,'String',num2str(CurrentFrame));
if param.tmp.n_scene ~= 1
    set(param.hMain.SliderFrame1, 'value', CurrentScene);
end
set(param.hMain.SliderFrame2, 'value', CurrentFrame);
param = Updatedisplay_Image_1(param);
param = Updatedisplay_Cellpairgating_0(param);
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
param.tmp.manual_list_selected_scene_frame(1) = CurrentScene;
param.tmp.manual_list_selected_scene_frame(2) = CurrentFrame;
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            param = Updatedisplay_Segmentationgating_00(param);
        end
    end
end
InformAllInterfaces(param);
end