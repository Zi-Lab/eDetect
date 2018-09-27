function CallbackLineageFilter(h,~)
param = guidata(h);
%%
if h == param.hLineage.Edit_filt_min
    Edit_filt_min = get(param.hLineage.Edit_filt_min, 'string');
    if isempty(Edit_filt_min)
        param.tmp.frames_filter_min = [];
        param.hLineage.Edit_filt_min.String = num2str(param.tmp.frames_filter_min);
    else
        filt_min = round(str2double(Edit_filt_min));
        if filt_min >= 1 && filt_min<= param.tmp.n_time
            param.tmp.frames_filter_min = filt_min;
            param.hLineage.Edit_filt_min.String = num2str(filt_min);
            param.tmp.frames_display_min = filt_min;
            param.hLineage.Edit_disp_min.String = num2str(filt_min);
        else
            param.hLineage.Edit_filt_min.String = num2str(param.tmp.frames_filter_min);
        end
    end
end
if h == param.hLineage.Edit_filt_max
    Edit_filt_max = get(param.hLineage.Edit_filt_max, 'string');
    if isempty(Edit_filt_max)
        param.tmp.frames_filter_max = [];
        param.hLineage.Edit_filt_max.String = num2str(param.tmp.frames_filter_max);
    else
        filt_max = round(str2double(Edit_filt_max));
        if filt_max >= 1 && filt_max<= param.tmp.n_time
            param.tmp.frames_filter_max = filt_max;
            param.hLineage.Edit_filt_max.String = num2str(filt_max);
            param.tmp.frames_display_max = filt_max;
            param.hLineage.Edit_disp_max.String = num2str(filt_max);
        else
            param.hLineage.Edit_filt_max.String = num2str(param.tmp.frames_filter_max);
        end
    end
end
if h == param.hLineage.Edit_filt_len
    Edit_filt_len = get(param.hLineage.Edit_filt_len, 'string');
    filt_len = round(str2double(Edit_filt_len));
    if filt_len >= 1 && filt_len<= param.tmp.n_time
        param.tmp.frames_filter_len = filt_len;
        param.hLineage.Edit_filt_len.String = filt_len;
    else
        param.hLineage.Edit_filt_len.String = num2str(param.tmp.frames_filter_len);
    end
end
%%
if h == param.hLineage.Edit_disp_min
    Edit_disp_min = get(param.hLineage.Edit_disp_min, 'string');
    disp_min = round(str2double(Edit_disp_min));
    if disp_min >= 1 && disp_min<= param.tmp.n_time
        param.tmp.frames_display_min = disp_min;
    else
        param.hLineage.Edit_disp_min.String = num2str(param.tmp.frames_display_min);
    end
end
if h == param.hLineage.Edit_disp_max
    Edit_disp_max = get(param.hLineage.Edit_disp_max, 'string');
    disp_max = round(str2double(Edit_disp_max));
    if disp_max >= 1 && disp_max<= param.tmp.n_time
        param.tmp.frames_display_max = disp_max;
    else
        param.hLineage.Edit_disp_max.String = num2str(param.tmp.frames_display_max);
    end
end
%%
param = Updatedisplay_Heatmap_1(param);
InformAllInterfaces(param);
end