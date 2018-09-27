function CallbackMouseClickOnSegmentationGating(h,~)
param = guidata(h);
%%
param.tmp.manual_list_selected_scene_frame = [];
param.tmp.manual_list_selected_objects = [];
%%
coordinates  = get(param.hNucleiSegmentationGating.axes1,'CurrentPoint'); 
x = coordinates(1,1);
y = coordinates(1,2);
dist = sum((param.tmp.pc_segmentationgating(:,1:2) - [x y]).^2,2);
[~,id] = min(dist);
m_type = get(param.hNucleiSegmentationGating.fig, 'selectionType');
if strcmp(m_type, 'normal')
    param.tmp.segmentation_gating_selected(id) = true;
elseif strcmp(m_type, 'alt')
    param.tmp.segmentation_gating_selected(id) = false;
elseif strcmp(m_type, 'open')

end
CurrentScene = param.tmp.label_segmentation_gating(id,1);
CurrentFrame = param.tmp.label_segmentation_gating(id,2);
clickedObject = param.tmp.label_segmentation_gating(id,3);
param.tmp.manual_list_selected_objects = clickedObject;
set(param.hMain.Edit1,'String',num2str(CurrentScene));
set(param.hMain.Edit2,'String',num2str(CurrentFrame));
if param.tmp.n_scene ~= 1
    set(param.hMain.SliderFrame1, 'value', CurrentScene);
end
set(param.hMain.SliderFrame2, 'value', CurrentFrame);
%%
%%
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
param = Updatedisplay_Image_1(param);
param = Updatedisplay_Segmentationgating_0(param);
InformAllInterfaces(param);
end