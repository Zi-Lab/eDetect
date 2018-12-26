function EditPredecessorSet(h,~)
param = guidata(h);
%%
if ~isfield(param.tmp,'n_scene')
    return;
elseif isempty(param.tmp.n_scene)
    return;
end
%%
if length(param.tmp.manual_list_selected_objects) > 1 || isempty(param.tmp.manual_track) || isempty(param.tmp.manual_list_selected_child)%CurrentFrame + 1 ~= param.tmp.manual_list_selected_child(1) 
    if isempty(param.tmp.manual_list_selected_child)
        msgbox('Please click "Get predecessor" first.','Error','error');
    elseif isempty(param.tmp.manual_track)
        msgbox('Tracking data not available.','Error','error');
    elseif length(param.tmp.manual_list_selected_objects) > 1
        msgbox('Please select at most 1 object.','Error','error');
    end
    param.tmp.manual_list_selected_objects = [];
    param.tmp.manual_list_selected_child = [];
    param.tmp.manual_list_selected_parent = [];
    param = Updatedisplay_Image_0(param);
    guidata(h,param);
    return;
end
%%
directory_lineage = param.tmp.dir_lineage;
filenames_track = param.tmp.filenames_track;
filenames_lineage = param.tmp.filenames_lineage;
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
if ~isempty(param.tmp.manual_list_selected_objects)
    param.tmp.manual_list_selected_parent = [CurrentFrame param.tmp.manual_list_selected_objects];
else
    param.tmp.manual_list_selected_parent = [CurrentFrame 0];
end
param.tmp.manual_track{param.tmp.manual_list_selected_child(1)}(param.tmp.manual_list_selected_child(2)) = param.tmp.manual_list_selected_parent(2);
savefile( param.tmp.manual_track , 'track' , fullfile(directory_lineage, filenames_track{s_id}) );
%%
if param.set.manual_correction_tracking_update == 2
    file = fullfile(directory_lineage, filenames_lineage{s_id});
    if exist(file,'file') == 2
        temp = load( file );
        param.tmp.manual_lineage_tree = lineage_edit(temp.lineage, param.tmp.manual_list_selected_child(1) , param.tmp.manual_list_selected_child(2) , param.tmp.manual_list_selected_parent(2));
        savefile( param.tmp.manual_lineage_tree , 'lineage' , file  );
    end
end
%%
param.tmp.manual_list_selected_objects = [];
param.tmp.manual_list_selected_child = [];
param.tmp.manual_list_selected_parent = [];
param = Updatedisplay_Image_1(param);
%%
if isfield(param,'hNucleiCellpairGating')
    if isfield(param.hNucleiCellpairGating,'fig')
        if isgraphics(param.hNucleiCellpairGating.fig)
            param = Updatedisplay_Cellpairgating_2(param,true,[s CurrentFrame+1]);
        end
    end
end
if isfield(param,'hLineage')
    if isfield(param.hLineage,'fig')
        if isgraphics(param.hLineage.fig)
            param = Updatedisplay_Heatmap_3(param);
        end
    end
end
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            param = Updatedisplay_Segmentationgating_00(param);
        end
    end
end
if isfield(param,'hSynchrogram')
    if isfield(param.hSynchrogram,'fig')
        if isgraphics(param.hSynchrogram.fig)
            close(param.hSynchrogram.fig);
        end
    end
end
InformAllInterfaces(param);
end