function CallbackFilenameFormats(h,~)
param = guidata(h);
str1 = get(param.hNewProject.Edit_param_nuc_fil,'string');
str2 = get(param.hNewProject.Edit_param_int_fil1,'string');
str3 = get(param.hNewProject.Edit_param_int_fil2,'string');
str4 = get(param.hNewProject.Edit_param_int_fil3,'string');
str5 = get(param.hNewProject.Edit_param_int_fil4,'string');
%% number of "<"s and ">"s
if isempty(str1)
    flags1 = -1;
    flagt1 = -1;
else
    flags1 = length(strfind(str1,'<'));
    flagt1 = length(strfind(str1,'>'));
end
if isempty(str2)
    flags2 = -1;
    flagt2 = -1;
else
    flags2 = length(strfind(str2,'<'));
    flagt2 = length(strfind(str2,'>'));
end
if isempty(str3)
    flags3 = -1;
    flagt3 = -1;
else
    flags3 = length(strfind(str3,'<'));
    flagt3 = length(strfind(str3,'>'));
end
if isempty(str4)
    flags4 = -1;
    flagt4 = -1;
else
    flags4 = length(strfind(str4,'<'));
    flagt4 = length(strfind(str4,'>'));
end
if isempty(str5)
    flags5 = -1;
    flagt5 = -1;
else
    flags5 = length(strfind(str5,'<'));
    flagt5 = length(strfind(str5,'>'));
end
%% error 1: Channel 1 filename format is empty
if flags1 == -1
    msgbox('Channel 1 filename format needs to be specified.','Error');
    return;
end
%% error 2: Channel 1 and Channel 2/3/4/5 filename formats are not compatible
if flags2 ~= -1 && (flags2 ~= flags1 || flagt2 ~= flagt1)
    msgbox('Channel 1 and channel 2 filename formats needs to be compatible.','Error');
    return;
end
if flags3 ~= -1 && (flags3 ~= flags1 || flagt3 ~= flagt1)
    msgbox('Channel 1 and channel 3 filename formats needs to be compatible.','Error');
    return;
end
if flags4 ~= -1 && (flags4 ~= flags1 || flagt4 ~= flagt1)
    msgbox('Channel 1 and channel 4 filename formats needs to be compatible.','Error');
    return;
end
if flags5 ~= -1 && (flags5 ~= flags1 || flagt5 ~= flagt1)
    msgbox('Channel 1 and channel 5 filename formats needs to be compatible.','Error');
    return;
end
%% whether filename formats contain "<"s
if flags1 == 0
    set(param.hNewProject.Edit_param_sce_min,'enable','off');
    set(param.hNewProject.Edit_param_sce_max,'enable','off');
else
    set(param.hNewProject.Edit_param_sce_min,'enable','on');
    set(param.hNewProject.Edit_param_sce_max,'enable','on');
end
%% whether filename formats contain ">"s
if flagt1 == 0
    set(param.hNewProject.Edit_param_fra_min,'enable','off');
    set(param.hNewProject.Edit_param_fra_max,'enable','off');
else
    set(param.hNewProject.Edit_param_fra_min,'enable','on');
    set(param.hNewProject.Edit_param_fra_max,'enable','on');
end
%%
guidata(h,param);
end