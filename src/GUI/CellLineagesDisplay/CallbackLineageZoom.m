function CallbackLineageZoom(h,~)
param = guidata(h);
%%
if h == param.hLineage.Edit_disp_zoom_vertical
    Edit_disp_zoom_vertical = get(param.hLineage.Edit_disp_zoom_vertical, 'string');
    zoom_vertical = str2double(Edit_disp_zoom_vertical);
    if zoom_vertical >= 1
        param.tmp.zoomin_vertical = zoom_vertical;
    else
        param.hLineage.Edit_disp_zoom_vertical.String = num2str(param.tmp.zoomin_vertical);
    end
end
if h == param.hLineage.Edit_disp_zoom_horizontal
    Edit_disp_zoom_horizontal = get(param.hLineage.Edit_disp_zoom_horizontal, 'string');
    zoom_horizontal = str2double(Edit_disp_zoom_horizontal);
    if zoom_horizontal >= 1
        param.tmp.zoomin_horizontal = zoom_horizontal;
    else
        param.hLineage.Edit_disp_zoom_horizontal.String = num2str(param.tmp.zoomin_horizontal);
    end
end
%%
if param.tmp.zoomin_vertical > 1
    LineageDisplayShift_vertical = round(1000*(get(param.hLineage.Slider_disp_shi_vertical,'Value')))/1000;
    set(param.hLineage.Slider_disp_shi_vertical,'enable','on');
else
    LineageDisplayShift_vertical = 0;
    set(param.hLineage.Slider_disp_shi_vertical,'enable','off');
end
if param.tmp.zoomin_horizontal > 1
    LineageDisplayShift_horizontal = round(1000*(get(param.hLineage.Slider_disp_shi_horizontal,'Value')))/1000;
    set(param.hLineage.Slider_disp_shi_horizontal,'enable','on');
else
    LineageDisplayShift_horizontal = 0;
    set(param.hLineage.Slider_disp_shi_horizontal,'enable','off');
end
%%
set(param.hLineage.axes1,'Position',[-LineageDisplayShift_horizontal*(param.tmp.zoomin_horizontal-1) , -LineageDisplayShift_vertical*(param.tmp.zoomin_vertical-1) , param.tmp.zoomin_horizontal , param.tmp.zoomin_vertical]);
guidata(h,param);
end