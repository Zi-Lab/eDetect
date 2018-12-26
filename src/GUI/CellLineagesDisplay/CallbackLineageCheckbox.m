function CallbackLineageCheckbox( h , ~ )
param = guidata(h);
%%
if h == param.hLineage.Check_filt_len
    if get(param.hLineage.Check_filt_len,'Value')==1
        param.hLineage.Text_filt_len.Enable = 'on';
        param.hLineage.Edit_filt_len.Enable = 'on';
        param.tmp.frames_filter_len = 2;
        param.hLineage.Edit_filt_len.String = num2str(param.tmp.frames_filter_len);
    else
        param.hLineage.Text_filt_len.Enable = 'off';
        param.hLineage.Edit_filt_len.Enable = 'off';
        param.tmp.frames_filter_len = [];
        param.hLineage.Edit_filt_len.String = num2str(param.tmp.frames_filter_len);
    end
end
if h == param.hLineage.Check_filt_foi
    if get(param.hLineage.Check_filt_foi,'Value')==1
        param.hLineage.Text_filt_min.Enable = 'on';
        param.hLineage.Edit_filt_min.Enable = 'on';
        param.hLineage.Text_filt_max.Enable = 'on';
        param.hLineage.Edit_filt_max.Enable = 'on';
        param.tmp.frames_filter_min = 1;
        param.tmp.frames_filter_max = param.tmp.n_time;
        param.tmp.frames_display_min = 1;
        param.tmp.frames_display_max = param.tmp.n_time;
        param.tmp.frames_filter_min = param.tmp.frames_filter_min;
        param.tmp.frames_filter_max = param.tmp.frames_filter_max;
        param.tmp.frames_display_min = param.tmp.frames_filter_min;
        param.tmp.frames_display_max = param.tmp.frames_filter_max;
        param.hLineage.Edit_disp_min.String = num2str(param.tmp.frames_filter_min);
        param.hLineage.Edit_disp_max.String = num2str(param.tmp.frames_filter_max);
        param.hLineage.Edit_filt_min.String = num2str(param.tmp.frames_filter_min);
        param.hLineage.Edit_filt_max.String = num2str(param.tmp.frames_filter_max);
    else
        param.hLineage.Text_filt_min.Enable = 'off';
        param.hLineage.Edit_filt_min.Enable = 'off';
        param.hLineage.Text_filt_max.Enable = 'off';
        param.hLineage.Edit_filt_max.Enable = 'off';
        param.tmp.frames_filter_min = [];
        param.tmp.frames_filter_max = [];
        param.hLineage.Edit_filt_min.String = num2str(param.tmp.frames_filter_min);
        param.hLineage.Edit_filt_max.String = num2str(param.tmp.frames_filter_max);
    end
end
%%
param = Updatedisplay_Heatmap_1(param);
InformAllInterfaces(param);
end

