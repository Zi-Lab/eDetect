function EditCellpairPolygonObjects(h,~)
param = guidata(h);
%%
directory_lineage = param.tmp.dir_lineage;
filenames_track = param.tmp.filenames_track;
filenames_lineage = param.tmp.filenames_lineage;
%%
new_labels = param.tmp.label_cellpair_gating(param.tmp.cellpair_gating_selected,:);
if isempty(new_labels)
    return;
end
temp_cell_array = cell([max(new_labels(:,2)),max(new_labels(:,1))]);
for i = 1:size(new_labels,1)
    temp_cell_array{new_labels(i,2),new_labels(i,1)} = [temp_cell_array{new_labels(i,2),new_labels(i,1)} ; new_labels(i,4) , new_labels(i,5)];
end
param.tmp.gating_update_image_list = zeros([0,2]);
%%
for i = unique( new_labels(:,1) )'
    s_id = find(param.tmp.scenes_all == i);
    file_path = fullfile(directory_lineage, filenames_track{s_id});
    temp = load(file_path);
    track = temp.track;
    for j = unique(  new_labels(new_labels(:,1) == i,2)  )'
        if ~isempty(temp_cell_array{j,i})
            param.tmp.gating_update_image_list = [param.tmp.gating_update_image_list; i j];
            if h == param.hNucleiCellpairGating.pushtool_DetachTwoChild
                for n = 1:size(temp_cell_array{j,i},1)
                    track{j}(temp_cell_array{j,i}(n,1)) = 0;
                    track{j}(temp_cell_array{j,i}(n,2)) = 0;
                end                
            else
                
            end
        end
    end
    savefile(track , 'track' , file_path);
end
%%
if param.set.manual_correction_tracking_update == 2
    for i = unique( new_labels(:,1) )'
        s_id = find(param.tmp.scenes_all == i);
        file_path = fullfile(directory_lineage, filenames_lineage{s_id});
        if exist(file_path,'file') == 2
            temp = load(file_path);
            lineage = temp.lineage;
            for j = unique(  new_labels(new_labels(:,1) == i,2)  )'
                if ~isempty(temp_cell_array{j,i})
                    if h == param.hNucleiCellpairGating.pushtool_DetachTwoChild
                        for n = 1:size(temp_cell_array{j,i},1)
                            lineage = lineage_edit( lineage , j , temp_cell_array{j,i}(n,1) , 0);
                            lineage = lineage_edit( lineage , j , temp_cell_array{j,i}(n,2) , 0);
                        end                
                    else
                        
                    end
                end
            end
            savefile(lineage , 'lineage' , file_path);
        end
    end
end
%%
if isfield(param.hNucleiCellpairGating,'poly')
    delete(param.hNucleiCellpairGating.poly);
    param.hNucleiCellpairGating = rmfield(param.hNucleiCellpairGating,'poly');
end
param.tmp.cellpair_gating_selected = false([size(param.tmp.pc_cellpairgating,1),1]);
%{
l = length(param.hNucleiCellpairGating.axes1.Children);
for i = l:(-1):1
    if isa(param.hNucleiCellpairGating.axes1.Children(i),'matlab.graphics.primitive.Group')
        delete(param.hNucleiCellpairGating.axes1.Children(i));
    end
end
%}
%%
if isfield(param,'hLineage')
    if isfield(param.hLineage,'fig')
        if isgraphics(param.hLineage.fig)
            param = Updatedisplay_Heatmap_3(param);
        end
    end
end
%%
if isfield(param,'hSynchrogram')
    if isfield(param.hSynchrogram,'fig')
        if isgraphics(param.hSynchrogram.fig)
            close(param.hSynchrogram.fig);
        end
    end
end
%%
%new_labels
param = Updatedisplay_Cellpairgating_2(param , true, new_labels);
InformAllInterfaces(param);
end
