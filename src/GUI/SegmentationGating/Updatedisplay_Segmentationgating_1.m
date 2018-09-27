function param = Updatedisplay_Segmentationgating_1(param, flag , list)
directories_label_info  = param.tmp.directories_label_info;
filenames_label_info  = param.tmp.filenames_label_info;
%%
if param.set.processing_number_of_cores > 1
    p = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(p)
        hMsg = msgbox('Starting parallel pool...','Information','help');
        delete(findobj(hMsg,'string','OK'));
        try
            parpool('local',param.set.processing_number_of_cores);
        catch e
            msgbox([e.message],'Warning','warn');
        end
        if isvalid(hMsg)
            close(hMsg);
        end
    end
end
%%
if flag
    for k = 1:size(list,1)
        s = list(k,1);
        t = list(k,2);
        s_id = find(param.tmp.scenes_all == s);
        [ label_info ] = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t});
        param.tmp.deleted_cells{t,s} = label_info.erroneous;
    end
else
    deleted = cell([param.tmp.n_time , max(param.tmp.scenes_for_gating)]);
    for s = param.tmp.scenes_for_gating
        s_id = find(param.tmp.scenes_all == s);
        if param.set.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                [ label_info ] = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t});
                deleted{t,s} = label_info.erroneous;
            end
        else
            for t = 1:param.tmp.n_time
                [ label_info ] = get_label_info(directories_label_info{s_id} , filenames_label_info{s_id,t});
                deleted{t,s} = label_info.erroneous;
            end
        end
    end
    param.tmp.deleted_cells = deleted;
end
%%
nl1 = 0;
for i = 1:length(param.tmp.scenes_for_gating)
    for t = 1:param.tmp.n_time
        nl1 = nl1 + size(param.tmp.segmentation_gating_data_cell_array{t,i},1);
    end
end
param.tmp.gating_deleted = NaN([nl1,1]);
nl2 = 0;
for i = 1:length(param.tmp.scenes_for_gating)
    for t = 1:param.tmp.n_time
        nl3 = size(param.tmp.segmentation_gating_data_cell_array{t,i},1);
        param.tmp.gating_deleted(nl2+1:nl2+nl3,:) = ismember(param.tmp.segmentation_gating_labl_cell_array{t,i}(:,3) , param.tmp.deleted_cells{t,i});
        nl2 = nl2+ nl3;
    end
end
%%
param.tmp.segmentation_gating_selected = false([size(param.tmp.pc_segmentationgating,1),1]);
param = Updatedisplay_Segmentationgating_0(param);
end