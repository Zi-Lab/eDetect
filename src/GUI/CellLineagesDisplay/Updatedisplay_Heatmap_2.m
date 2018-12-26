function param =  Updatedisplay_Heatmap_2(param)
feature_id = 1;
if isfield(param.tmp,'feature_names')
    for i = 1:length(param.tmp.feature_names)
        if strcmp(param.tmp.feature_names{i},param.tmp.current_feature_name)
            feature_id = i;
        end
    end
end
set(param.hLineage.Drop1,'Value',feature_id);
%%
h = [];
if isfield(param.tmp,'manual_lineage_tree')
    param.tmp.manual_lineage_data = zeros(size(param.tmp.manual_lineage_tree));
    for i = 1:size(param.tmp.manual_lineage_tree,1)
        for j = 1:param.tmp.n_time
            if param.tmp.manual_lineage_tree(i,j) == 0
                param.tmp.manual_lineage_data(i,j) = NaN;
            else
                if param.tmp.manual_lineage_tree(i,j) <= size(param.tmp.track_feature{j},1) && feature_id <= size(param.tmp.track_feature{j},2)
                    param.tmp.manual_lineage_data(i,j) = param.tmp.track_feature{j}(param.tmp.manual_lineage_tree(i,j),feature_id);
                else
                    param.tmp.manual_lineage_data(i,j) = NaN;
                    if isempty(h)
                        h = msgbox('Please re-run measurement after object splitting or merging.','Error','error');
                    end
                end
            end
        end
    end
end
param = Updatedisplay_Heatmap_1(param);
end
%%