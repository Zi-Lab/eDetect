function CallbackImageDisplayScene(h,~)
param = guidata(h);
param.tmp.manual_list_selected_objects = [];
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
%%
param = Updatedisplay_Image_1(param);
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            param = Updatedisplay_Segmentationgating_00(param);
        end
    end
end
guidata(h,param);
if isfield(param,'hLineage')
    if isfield(param.hLineage,'fig')
        if isgraphics(param.hLineage.fig)
            if param.tmp.n_scene ~= 1
                CurrentScene = round((get(param.hMain.SliderFrame1,'Value')));
                set(param.hLineage.SliderFrame1, 'value', CurrentScene);
            end
            param = Updatedisplay_Heatmap_3(param);
        end
    end
end
%%
InformAllInterfaces(param);
end