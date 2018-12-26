function CallbackImageDisplay(h,~)
param = guidata(h);
%%
if h == param.hMain.Edit3
    Edit3 = get(param.hMain.Edit3, 'string');
    E3 = round(str2double(Edit3));
    if E3 >= param.tmp.val_min && E3 <= param.tmp.val_max
        set(param.hMain.SliderFrame3, 'value', E3);
    end
end
if h == param.hMain.Edit4
    Edit4 = get(param.hMain.Edit4, 'string');
    E4 = round(str2double(Edit4));
    if E4 >= param.tmp.val_min && E4 <= param.tmp.val_max
        set(param.hMain.SliderFrame4, 'value', E4);
    end
end
if h == param.hMain.Edit5
    Edit5 = get(param.hMain.Edit5, 'string');
    E5 = str2double(Edit5);
    if E5 >= 0 && E5 <= 1
        set(param.hMain.SliderFrame5, 'value', E5);
    end
end
%%
param = Updatedisplay_Image_0(param);
InformAllInterfaces(param);
end