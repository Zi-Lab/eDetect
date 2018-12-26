function EditDeselect(h,~)
param = guidata(h);
param.tmp.manual_list_selected_objects = [];
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
param = Updatedisplay_Image_0(param);
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            param = Updatedisplay_Segmentationgating_0(param);
        end
    end
end
InformAllInterfaces(param);
end