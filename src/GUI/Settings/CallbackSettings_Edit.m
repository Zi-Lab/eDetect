function CallbackSettings_Edit( h , ~ )
param = guidata(h);
%%
if h == param.hSettings.Edit_scenes_process
    if isempty(param.tmp.scenes_all)
        msgbox('Please load a project or start a new project first.','Error','error');
        return;
    else
        temp1 = param.hSettings.Edit_scenes_process.String;
        if ~isempty(temp1)
            temp2 = str2double(strsplit(temp1,' '));
            for i = 1:length(temp2)
                if isnan(temp2(i))
                    param.hSettings.Edit_scenes_process.String = param.set.processing_scenes;
                    msgbox('Please input a list of numbers separated by blanks.','Error','error');
                    return;
                end
            end
            for i = 1:length(temp2)
                if ~ismember(temp2(i),param.tmp.scenes_all)
                    param.hSettings.Edit_scenes_process.String = param.set.processing_scenes;
                    msgbox('One of the scene indices is not included in the dataset.','Error','error');
                    return;
                end
            end
        end
        param.set.processing_scenes = get(param.hSettings.Edit_scenes_process, 'String');
    end
end
%%
if h == param.hSettings.Edit_parallel_setting
    try 
        tmp = ver('distcomp');
        core_info = evalc('feature(''numcores'')');
        temp0 = strsplit(core_info,' logical cores by the OS.');
        temp1 = strsplit(temp0{1},'MATLAB was assigned: ');
        max = str2double(temp1{2});
    catch
       %fprintf('Not installed');
        max = 0;
    end
    temp = round(str2double(get(param.hSettings.Edit_parallel_setting, 'String')));
    if ~isnan(temp) && temp > 0 && temp <= max
        param.set.processing_number_of_cores = temp;
        param.hSettings.Edit_parallel_setting.String = num2str(temp);
    else
        if max == 0
            msgbox('Parallel Computing Toolbox is not installed.','Error','error');
        elseif temp > max
            msgbox(['This machine has ' num2str(max) ' cores.'],'Error','error');
        else
            msgbox('This parameter is a positive integer.','Error','error');
        end
        param.hSettings.Edit_parallel_setting.String = num2str(param.set.processing_number_of_cores);
        return;
    end
end
%%
if h == param.hSettings.Edit_segmentation_max_depth
    temp = round(str2double(get(param.hSettings.Edit_segmentation_max_depth, 'String')));
    if temp > 0
        param.set.segmentation_max_depth = temp;
        param.hSettings.Edit_segmentation_max_depth.String = num2str(temp);
    else
        param.hSettings.Edit_segmentation_max_depth.String = num2str(param.set.segmentation_max_depth);
        msgbox('This parameter is a positive integer.','Error','error');
        return;
    end
end
%%
if h == param.hSettings.Edit_segmentation_max_runtime
    temp = round(str2double(get(param.hSettings.Edit_segmentation_max_runtime, 'String')));
    if temp > 0
        param.set.segmentation_max_runtime = temp;
        param.hSettings.Edit_segmentation_max_runtime.String = num2str(temp);
    else
        param.hSettings.Edit_segmentation_max_runtime.String = num2str(param.set.segmentation_max_runtime);
        msgbox('This parameter is a positive integer.','Error','error');
        return;
    end
end
%%
if h == param.hSettings.Edit_tracking_max_deviation
    temp = round(str2double(get(param.hSettings.Edit_tracking_max_deviation, 'String')));
    if temp < 0
        param.hSettings.Edit_tracking_max_deviation.String = num2str(param.set.tracking_max_deviation);
        msgbox('This parameter is a nonnegative integer.','Error','error');
        return;
    else
        if temp > 0
            try
               tmp = ver('optim');
            catch
               msgbox('Optimization Toolbox is not installed. This value cannot be positive.','Error','error');
               return;
            end
        end
        param.set.tracking_max_deviation = temp;
        param.hSettings.Edit_tracking_max_deviation.String = num2str(temp);
    end
end
%%
%%
param = CheckStatus( param );
%%
%MsgBoxH = findall(0,'Type','figure','Name','Information');
%close(MsgBoxH);
InformAllInterfaces(param);
%hMsg = msgbox('Settings updated.','Information','help');
end

