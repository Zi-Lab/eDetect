function EditPredecessorGet(h,~)
param = guidata(h);
if ~isfield(param.tmp,'n_scene')
    return;
elseif isempty(param.tmp.n_scene)
    return;
end
%%
directory_lineage = param.tmp.dir_lineage;
filenames_track = param.tmp.filenames_track;
%%
if param.tmp.n_scene == 1
    s = param.tmp.min_scene;
else
    s = round((get(param.hMain.SliderFrame1,'Value')));
end
s_id = find(param.tmp.scenes_all == s);
%%
if param.tmp.n_time == 1
    CurrentFrame = param.tmp.min_time;
else
    CurrentFrame = round((get(param.hMain.SliderFrame2,'Value')));
end
if length(param.tmp.manual_list_selected_objects) ~= 1 || CurrentFrame == 1% || isempty(param.tmp.manual_track)
    if length(param.tmp.manual_list_selected_objects) ~= 1
        msgbox('Please select 1 object.','Error','error');
    else
        msgbox('This is the 1st frame.','Error','error');
    end
    param.tmp.manual_list_selected_objects = [];
    param = Updatedisplay_Image_0(param);
    guidata(h,param);
    return;
end
param.tmp.manual_list_selected_child = [CurrentFrame double(param.tmp.manual_list_selected_objects)];
set(param.hMain.SliderFrame2, 'value', CurrentFrame - 1);
%%
filename = fullfile(directory_lineage, filenames_track{s_id});
if exist(filename,'file') == 2
    temp = load(filename);
    if temp.track{CurrentFrame}(param.tmp.manual_list_selected_child(2)) > 0
        param.tmp.manual_track = temp.track;
        param.tmp.manual_list_selected_objects = temp.track{CurrentFrame}(param.tmp.manual_list_selected_child(2));
    else
        param.tmp.manual_track = temp.track;
        param.tmp.manual_list_selected_objects = [];
    end
else
    param.tmp.manual_list_selected_objects = [];
    msgbox('No cell tracking results.','Error','error');
end
%%
param = Updatedisplay_Image_1(param);
InformAllInterfaces(param);
end