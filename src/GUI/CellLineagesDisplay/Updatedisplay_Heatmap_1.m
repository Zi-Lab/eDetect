function param = Updatedisplay_Heatmap_1(param)
if param.tmp.n_scene ~= 1
    CurrentLineageScene = round((get(param.hLineage.SliderFrame1,'Value')));
    set(param.hLineage.Edit1,'String',num2str(CurrentLineageScene));
    set(param.hMain.SliderFrame1, 'value', CurrentLineageScene);
end
if ~isfield(param.tmp,'feature_names') || ~isfield(param.tmp,'manual_lineage_tree') || ~isfield(param.tmp,'manual_lineage_data')
    imshow([],'Parent', param.hLineage.axes1);
    return;
elseif isempty(param.tmp.feature_names) || isempty(param.tmp.manual_lineage_tree) || isempty(param.tmp.manual_lineage_data)
    imshow([],'Parent', param.hLineage.axes1);
    return;
end
%% display filters
param.tmp.frames_displayed = param.tmp.frames_display_min:param.tmp.frames_display_max;
if isempty(param.tmp.frames_filter_min) || isempty(param.tmp.frames_filter_max)
    LineageFilterFramesOfInterest = [];
else
    LineageFilterFramesOfInterest = param.tmp.frames_filter_min:param.tmp.frames_filter_max;
end
if isempty(param.tmp.frames_filter_len)
    LineageFilterLength = 0;
else
    LineageFilterLength = param.tmp.frames_filter_len;
end
%
filter1 = all(param.tmp.manual_lineage_tree( : , LineageFilterFramesOfInterest ) > 0 , 2);
filter2 = sum(param.tmp.manual_lineage_tree > 0,2) >= LineageFilterLength;
param.tmp.lineage_filter = filter1 & filter2;
%
param.tmp.filtered_lineage_tree = param.tmp.manual_lineage_tree(param.tmp.lineage_filter , param.tmp.frames_displayed);
param.tmp.filtered_lineage_data = param.tmp.manual_lineage_data(param.tmp.lineage_filter , param.tmp.frames_displayed);
%%
if ~isempty(LineageFilterFramesOfInterest) || LineageFilterLength > 2
    param.tmp.lineage_diplay_divisions = true;
else
    param.tmp.lineage_diplay_divisions = false;
end
param = Updatedisplay_Heatmap_0(param);
end