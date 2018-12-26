function CallbackMouseClickOnSynchrogram( h , ~ )
param = guidata(h);
coordinates = get(param.hSynchrogram.axes_montage,'CurrentPoint'); 
x = round(coordinates(1,1)+0.0);
%y = round(coordinates(1,2)+0.0);
i = param.tmp.row_for_synchrogram;
r = param.tmp.r_synchrogram_crop;
d = param.tmp.d_synchrogram_crop;
j = ceil(x / (r+d));
nonzeros = find(param.tmp.filtered_lineage_tree(i,:)>0);
param.tmp.manual_list_selected_objects = param.tmp.filtered_lineage_tree(i,nonzeros(j));
if param.tmp.n_scene ~= 1
    set(param.hMain.SliderFrame1, 'value', CurrentScene);
end
set(param.hMain.SliderFrame2, 'value', param.tmp.frames_displayed(nonzeros(j)));
%%
param = Updatedisplay_Image_1(param);
InformAllInterfaces(param);
end

