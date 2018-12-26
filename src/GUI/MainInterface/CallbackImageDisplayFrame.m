function CallbackImageDisplayFrame(h,~)
param = guidata(h);
param.tmp.manual_list_selected_objects = [];
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
%%
if h == param.hMain.Edit2
    Edit2 = get(param.hMain.Edit2, 'string');
    E2 = round(str2double(Edit2));
    if E2 >= 1 && E2 <= param.tmp.n_time
        set(param.hMain.SliderFrame2, 'value', E2);
    end
end
%%
param = Updatedisplay_Image_1(param);
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            param = Updatedisplay_Segmentationgating_00(param);
        end
    end
end
InformAllInterfaces(param);
end