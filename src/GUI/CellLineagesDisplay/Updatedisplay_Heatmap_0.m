function param = Updatedisplay_Heatmap_0(param)
if strcmp( get(param.hLineage.toggletool_detectoutliers,'State') , 'on' )
    param.hLineage.Text_outlier.Visible = 'on';
    param.hLineage.Text_outlier_ignore.Visible = 'on';
    param.hLineage.Text_outlier_before.Visible = 'on';
    param.hLineage.Text_outlier_after.Visible = 'on';
    param.hLineage.Text_outlier_threshold.Visible = 'on';
    param.hLineage.Text_outlier_nosd.Visible = 'on';
    param.hLineage.Edit_outlier_before.Visible = 'on';
    param.hLineage.Edit_outlier_after.Visible = 'on';
    param.hLineage.Edit_outlier_nosd.Visible = 'on';
else
    param.hLineage.Text_outlier.Visible = 'off';
    param.hLineage.Text_outlier_ignore.Visible = 'off';
    param.hLineage.Text_outlier_before.Visible = 'off';
    param.hLineage.Text_outlier_after.Visible = 'off';
    param.hLineage.Text_outlier_threshold.Visible = 'off';
    param.hLineage.Text_outlier_nosd.Visible = 'off';
    param.hLineage.Edit_outlier_before.Visible = 'off';
    param.hLineage.Edit_outlier_after.Visible = 'off';
    param.hLineage.Edit_outlier_nosd.Visible = 'off';
end
%%
%cla(param.hLineage.axes1,'reset');
if isfield(param.hLineage,'im')
    delete(param.hLineage.im);
end
if isfield(param.hLineage,'hline1')
    for i = 1:length(param.hLineage.hline1)
        delete(param.hLineage.hline1(i));
    end
end
if isfield(param.hLineage,'hline2')
    for i = 1:length(param.hLineage.hline2)
        delete(param.hLineage.hline2(i));
    end
end
if isfield(param.hLineage,'hline3')
    for i = 1:length(param.hLineage.hline3)
        delete(param.hLineage.hline3(i));
    end
end
%%
colors_line = get(param.hLineage.Drop2,'String');
color_line = colors_line{get(param.hLineage.Drop2,'Value')};
colors_heatmap = get(param.hLineage.Drop3,'String');
color_heatmap = colors_heatmap{get(param.hLineage.Drop3,'Value')};
%% lineage heat map
param.hLineage.im = imagesc(param.tmp.filtered_lineage_data, 'CDataMapping', 'scaled','Parent', param.hLineage.axes1,'ButtonDownFcn',@CallbackMouseClickOnLineage,'HitTest','on','AlphaData',~isnan(param.tmp.filtered_lineage_data));
colormap(param.hLineage.axes1,color_heatmap);
cmin = str2double(get(param.hLineage.Edit_cmin,'String'));
cmax = str2double(get(param.hLineage.Edit_cmax,'String'));
if ~isnan(cmin) && ~isnan(cmax)
    caxis(param.hLineage.axes1,[cmin cmax]);
else
    cl = caxis(param.hLineage.axes1);
    set(param.hLineage.Edit_cmin,'String',num2str(cl(1)));
    set(param.hLineage.Edit_cmax,'String',num2str(cl(2)));
end
%% lineage tree
lines = lineagedisplay_search_lines(param.tmp.filtered_lineage_tree);
param.hLineage.hline1 = gobjects(size(lines,1),1);
for i = 1:size(lines,1)
    param.hLineage.hline1(i) = line( [lines(i,1) lines(i,2)] , [lines(i,3) lines(i,4)]   ,'Parent', param.hLineage.axes1,'LineWidth',0.1,'Color',color_line,'ButtonDownFcn',@CallbackMouseClickOnLineage,'HitTest','on');
end

%% find divisions
if param.tmp.n_scene == 1
    s = param.tmp.min_scene;
else
    s = round((get(param.hLineage.SliderFrame1,'Value')));
end
s_id = find(param.tmp.scenes_all == s);
dir_lineage = param.tmp.dir_lineage;
filenames_track = param.tmp.filenames_track;
temp = load(fullfile(dir_lineage, filenames_track{s_id}));
tracks = temp.track;
daughters = cell([length(tracks),1]);
for i = 2:length(tracks)
    list = tracks{i};
    list_u = unique(list);
    parents = list_u(hist(list,list_u)>1);
    parents = setdiff(parents,0);
    daughters{i} = [find(ismember(list,parents)) list(ismember(list,parents))];
end
%% mark unshown divisions
if param.tmp.lineage_diplay_divisions
    unshown_daughters = lineagedisplay_find_unshown_daughters(param.tmp.filtered_lineage_tree , daughters(param.tmp.frames_displayed));
    marks = lineagedisplay_search_marks(param.tmp.filtered_lineage_tree , unshown_daughters);
    param.hLineage.hline2 = gobjects(size(marks,1),1);
    for i = 1:size(marks,1)
        param.hLineage.hline2(i) = line( [marks(i,1) marks(i,2)] , [marks(i,3) marks(i,4)]   ,'Parent', param.hLineage.axes1,'LineWidth',0.1,'Color',color_line,'ButtonDownFcn',@CallbackMouseClickOnLineage,'HitTest','on');
    end
end
%% automatic error detection
flag_detectoutliers = strcmp( get(param.hLineage.toggletool_detectoutliers,'State') , 'on' );
if flag_detectoutliers
    diff_0 = lineagedisplay_difference(param.tmp.filtered_lineage_data);
    diff_1 = lineagedisplay_ignore_changes_near_divisions(diff_0 , param.tmp.filtered_lineage_tree , daughters(param.tmp.frames_displayed) , param.tmp.outlier_before , param.tmp.outlier_after);
    errors = lineagedisplay_search_errors(diff_1 , lines,param.tmp.outlier_nosd);
    param.hLineage.hline3 = gobjects(size(errors,1),1);
    for i = 1:size(errors,1)
        param.hLineage.hline3(i) = line( [errors(i,1) errors(i,2)] , [errors(i,3) errors(i,4)]   ,'Parent', param.hLineage.axes1,'LineWidth',3.0,'Color',[1.0 0.0 0.0],'ButtonDownFcn',@CallbackMouseClickOnLineage,'HitTest','on');
    end
end
end