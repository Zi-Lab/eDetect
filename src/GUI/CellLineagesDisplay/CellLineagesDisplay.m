function CellLineagesDisplay(h,~)
param = guidata(h);
if isfield(param,'hLineage')
    if isfield(param.hLineage,'fig')
        if isgraphics(param.hLineage.fig)
            return;
        end
    end
end
%%
if isempty(param.tmp.n_time) || isempty(param.tmp.n_scene)
    return;
end
if param.tmp.n_scene ~= 1
    CurrentScene = round((get(param.hMain.SliderFrame1,'Value')));
end
%%
fs0 = 8;
fs1 = 10;
fs2 = 12;
fw1 = 'normal';
fw2 = 'bold';
%%
w_e1 = 0.40;
w_s1 = 0.60;
w_e2 = 0.40;
w_s2 = 0.60;
%%
w_ctrl = param.tmp.w_ctrl_2;
h_p1 = param.tmp.h_p1;
h_p2 = param.tmp.h_p2;
h_p3 = param.tmp.h_p3;
h_p5 = param.tmp.h_p5;
h_p = h_p1+h_p1+h_p5;
w_axes = param.tmp.w_axes_2;
x_leftbottom = param.tmp.x_leftbottom_2;
y_leftbottom = param.tmp.y_leftbottom_2;
%%
hLineage.fig = figure('name','Cell Lineages Display','NumberTitle','off','Units','pixels','Position',[x_leftbottom y_leftbottom w_axes+w_ctrl h_p], 'MenuBar' , 'none' , 'ToolBar' , 'figure','DockControls', 'off','SizeChangedFcn',@SizeChangedFcn_CellLineagesDisplay);
%%
%temp1 = findall(gcf);
temp1 = findall(hLineage.fig);
set(findall(temp1,'tag','Standard.NewFigure'),'Visible','Off');
set(findall(temp1,'tag','Standard.FileOpen'),'Visible','Off');
set(findall(temp1,'tag','Standard.PrintFigure'),'Visible','Off', 'Separator' , 'off');
set(findall(temp1,'tag','Standard.EditPlot'),'Visible','Off', 'Separator' , 'off');
set(findall(temp1,'tag','Exploration.Rotate'),'Visible','Off');
set(findall(temp1,'tag','Exploration.DataCursor'),'Visible','Off');
set(findall(temp1,'tag','Exploration.Brushing'),'Visible','Off', 'Separator' , 'off');
set(findall(temp1,'tag','DataManager.Linking'),'Visible','Off', 'Separator' , 'off');
set(findall(temp1,'tag','Annotation.InsertLegend')  ,'Visible','Off');
set(findall(temp1,'tag','Plottools.PlottoolsOff'),'Visible','Off');
set(findall(temp1,'tag','Plottools.PlottoolsOn'),'Visible','Off');
%%
hz = zoom;
set(hz,'ActionPreCallback',@zoomStarted);
set(hz,'ActionPostCallback',@zoomEnded);
%%
temp2 = findall(hLineage.fig,'tag','FigureToolBar');
%%
img_detect_outliers = imread('detect_outliers.tif');
img_detect_outliers = double(img_detect_outliers(:,:,1:3)) / 255;
hLineage.toggletool_detectoutliers = uitoggletool(temp2,'CData',img_detect_outliers ,'TooltipString','Detect outliers' , 'Separator' , 'off','ClickedCallback',@refresh);
img_export_table = imread('export_table.tif');
img_export_table = double(img_export_table(:,:,1:3)) / 255;
hLineage.pushtool_exporttable      = uipushtool(  temp2,'CData',img_export_table    ,'TooltipString','Export table'    , 'Separator' , 'off','ClickedCallback',@export_lineage_table);
%%
hLineage.panel_lineage = uipanel('Parent',hLineage.fig,'Units','pixels','Position',[w_ctrl+1 1 w_axes h_p] );
hLineage.panel1 = uipanel('Parent',hLineage.panel_lineage,'Units','normalized','Position',[0.05 0.05 0.95 0.95] );
hLineage.panel_display    = uipanel('Parent',hLineage.fig,'Units','pixels','Position',[1 h_p1+h_p1 w_ctrl h_p5]);
hLineage.panel_filters    = uipanel('Parent',hLineage.fig,'Units','pixels','Position',[1 h_p1      w_ctrl h_p1]);
hLineage.panel_outlier    = uipanel('Parent',hLineage.fig,'Units','pixels','Position',[1 1         w_ctrl h_p1]);
%% Cell lineage display settings
n_comp_1 = 12;
h_comp_1 = 1/n_comp_1;
hLineage.Text_controls = uicontrol('Parent',hLineage.panel_display,'Style','Text',   'Units','normalized', 'FontWeight', fw2, 'FontSize', fs2,'Position',[0.00 1-2*h_comp_1 1.00 2*h_comp_1], 'String','Display control');
hLineage.Text1         = uicontrol('Parent',hLineage.panel_display,'Style','Text',   'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-3*h_comp_1 1.00 h_comp_1], 'String','Scene');
hLineage.Edit1         = uicontrol('Parent',hLineage.panel_display,'Style','Edit',   'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-4*h_comp_1 w_e1 h_comp_1], 'String','1','enable', 'off');
hLineage.SliderFrame1  = uicontrol('Parent',hLineage.panel_display,'Style','slider', 'Units','normalized'                                    ,'Position',[w_e1 1-4*h_comp_1 w_s1 h_comp_1], 'enable','off','Callback',@CallbackLineageScene);
if param.tmp.n_scene > 1
    step3 = [1/(param.tmp.n_scene-1) 2/(param.tmp.n_scene-1)];
    set(hLineage.SliderFrame1, 'Min',param.tmp.min_scene,'Max',param.tmp.max_scene,'Value',CurrentScene,'SliderStep',step3,'enable','on');
end
hLineage.Text_disp_zoom_vertical    = uicontrol('Parent',hLineage.panel_display,'Style','Text',     'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-5*h_comp_1 w_s1 h_comp_1], 'String','Zoom in: V','HorizontalAlignment','Left');
hLineage.Edit_disp_zoom_vertical    = uicontrol('Parent',hLineage.panel_display,'Style','Edit',     'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1 1-5*h_comp_1 w_e1 h_comp_1], 'String',num2str(1),'Callback',@CallbackLineageZoom);
hLineage.Text_disp_zoom_horizontal  = uicontrol('Parent',hLineage.panel_display,'Style','Text',     'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-6*h_comp_1 w_s1 h_comp_1], 'String','Zoom in: H','HorizontalAlignment','Left');
hLineage.Edit_disp_zoom_horizontal  = uicontrol('Parent',hLineage.panel_display,'Style','Edit',     'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1 1-6*h_comp_1 w_e1 h_comp_1], 'String',num2str(1),'Callback',@CallbackLineageZoom);
hLineage.Slider_disp_shi_vertical   = uicontrol('Parent',hLineage.panel_lineage,'Style','Slider',   'Units','normalized', 'enable','off'                    ,'Position',[0.00 0.05 0.05 0.95], 'Min',0,'Max',1,'Value',1,'SliderStep',[1/1000 2/1000],'Callback',@CallbackLineageZoom);
hLineage.Slider_disp_shi_horizontal = uicontrol('Parent',hLineage.panel_lineage,'Style','Slider',   'Units','normalized', 'enable','off'                    ,'Position',[0.05 0.00 0.95 0.05], 'Min',0,'Max',1,'Value',1,'SliderStep',[1/1000 2/1000],'Callback',@CallbackLineageZoom);
%
param.tmp.frames_display_min = 1;
param.tmp.frames_display_max = param.tmp.n_time;
hLineage.Text_disp_min = uicontrol('Parent',hLineage.panel_display ,'Style','Text',      'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-7*h_comp_1 w_s1 h_comp_1], 'String','Frame: Start','HorizontalAlignment','Left');
hLineage.Edit_disp_min = uicontrol('Parent',hLineage.panel_display ,'Style','Edit',      'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1 1-7*h_comp_1 w_e1 h_comp_1], 'String',num2str(param.tmp.frames_display_min),'Callback',@CallbackLineageFilter);
hLineage.Text_disp_max = uicontrol('Parent',hLineage.panel_display ,'Style','Text',      'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-8*h_comp_1 w_s1 h_comp_1], 'String','Frame: End','HorizontalAlignment','Left');
hLineage.Edit_disp_max = uicontrol('Parent',hLineage.panel_display ,'Style','Edit',      'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1 1-8*h_comp_1 w_e1 h_comp_1], 'String',num2str(param.tmp.frames_display_max),'Callback',@CallbackLineageFilter);
%
hLineage.Text_Drop1    = uicontrol('Parent',hLineage.panel_display,'Style','Text',       'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-9*h_comp_1 w_s1 h_comp_1], 'String','Measurement','HorizontalAlignment','Left');
hLineage.Drop1         = uicontrol('Parent',hLineage.panel_display,'Style','popupmenu',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs0,'Position',[w_s1 1-9*h_comp_1 w_e1 h_comp_1], 'Callback',@CallbackDropMeasurement);
%
hLineage.Text_Drop2    = uicontrol('Parent',hLineage.panel_display,'Style','Text',       'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-10*h_comp_1 w_s1 h_comp_1], 'String','Line color','HorizontalAlignment','Left');
hLineage.Drop2         = uicontrol('Parent',hLineage.panel_display,'Style','popupmenu',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs0,'Position',[w_s1 1-10*h_comp_1 w_e1 h_comp_1], 'Callback',@CallbackDropColor);
hLineage.Text_Drop3    = uicontrol('Parent',hLineage.panel_display,'Style','Text',       'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-11*h_comp_1 w_s1 h_comp_1], 'String','Heatmap color','HorizontalAlignment','Left');
hLineage.Drop3         = uicontrol('Parent',hLineage.panel_display,'Style','popupmenu',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs0,'Position',[w_s1 1-11*h_comp_1 w_e1 h_comp_1], 'Callback',@CallbackDropColor);
%
hLineage.Text_caxis    = uicontrol('Parent',hLineage.panel_display ,'Style','Text',      'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00        1-12*h_comp_1 w_s1   h_comp_1], 'String','Color limits','HorizontalAlignment','Left');
hLineage.Edit_cmin     = uicontrol('Parent',hLineage.panel_display ,'Style','Edit',      'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1        1-12*h_comp_1 w_e1/2 h_comp_1], 'String','','Callback',@CallbackDropColor);
hLineage.Edit_cmax     = uicontrol('Parent',hLineage.panel_display ,'Style','Edit',      'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1+w_e1/2 1-12*h_comp_1 w_e1/2 h_comp_1], 'String','','Callback',@CallbackDropColor);
%% Cell lineage filters
n_comp_2 = 7;
h_comp_2 = 1/n_comp_2;
param.tmp.frames_filter_min = [];
param.tmp.frames_filter_max = [];
param.tmp.frames_filter_len = 2;
hLineage.Text_filter    = uicontrol('Parent',hLineage.panel_filters,'Style','Text',  'Units','normalized', 'FontWeight', fw2, 'FontSize', fs2,'Position',[0.00 1-2*h_comp_2 1.00 2*h_comp_2], 'String','Lineage filters');
hLineage.Check_filt_len = uicontrol('Parent',hLineage.panel_filters,'Style','Check', 'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-3*h_comp_2 1.00 1*h_comp_2] ,'String','Length of lineages','Value',1,'Callback',@CallbackLineageCheckbox);
hLineage.Text_filt_len  = uicontrol('Parent',hLineage.panel_filters,'Style','Text',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-4*h_comp_2 w_s1 h_comp_2], 'String','Min');
hLineage.Edit_filt_len  = uicontrol('Parent',hLineage.panel_filters,'Style','Edit',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1 1-4*h_comp_2 w_e1 h_comp_2], 'String',num2str(param.tmp.frames_filter_len),'Callback',@CallbackLineageFilter);
hLineage.Check_filt_foi = uicontrol('Parent',hLineage.panel_filters,'Style','Check', 'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-5*h_comp_2 1.00 h_comp_2], 'String','Required frames','Callback',@CallbackLineageCheckbox);
hLineage.Text_filt_min  = uicontrol('Parent',hLineage.panel_filters,'Style','Text',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-6*h_comp_2 w_s1 h_comp_2], 'String','From');
hLineage.Edit_filt_min  = uicontrol('Parent',hLineage.panel_filters,'Style','Edit',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1 1-6*h_comp_2 w_e1 h_comp_2], 'String',num2str(param.tmp.frames_filter_min),'Callback',@CallbackLineageFilter);
hLineage.Text_filt_max  = uicontrol('Parent',hLineage.panel_filters,'Style','Text',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-7*h_comp_2 w_s1 h_comp_2], 'String','To');
hLineage.Edit_filt_max  = uicontrol('Parent',hLineage.panel_filters,'Style','Edit',  'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s1 1-7*h_comp_2 w_e1 h_comp_2], 'String',num2str(param.tmp.frames_filter_max),'Callback',@CallbackLineageFilter);
hLineage.Text_filt_len.Enable = 'on';
hLineage.Edit_filt_len.Enable = 'on';
hLineage.Text_filt_min.Enable = 'off';
hLineage.Edit_filt_min.Enable = 'off';
hLineage.Text_filt_max.Enable = 'off';
hLineage.Edit_filt_max.Enable = 'off';
%% Outlier detection
n_comp_3 = 6;
h_comp_3 = 1/n_comp_3;
hLineage.Text_outlier           = uicontrol('Parent',hLineage.panel_outlier,'Style','Text',        'Units','normalized', 'FontWeight', fw2, 'FontSize', fs2,'Position',[0.00 1-2*h_comp_3 1.00 2*h_comp_3], 'String','Outlier detection');
hLineage.Text_outlier_nosd      = uicontrol('Parent',hLineage.panel_outlier,'Style','Text',        'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-3*h_comp_3 w_s2 h_comp_3], 'String','Threshold','HorizontalAlignment','Left');
hLineage.Edit_outlier_nosd      = uicontrol('Parent',hLineage.panel_outlier,'Style','Edit',        'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s2 1-3*h_comp_3 w_e2 h_comp_3], 'String',num2str(param.tmp.outlier_nosd),'Callback',@refresh);
hLineage.Text_outlier_ignore    = uicontrol('Parent',hLineage.panel_outlier,'Style','Text',        'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-4*h_comp_3 1.00 h_comp_3], 'String','Neglected frames');
hLineage.Text_outlier_before    = uicontrol('Parent',hLineage.panel_outlier,'Style','Text',        'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-5*h_comp_3 w_s2 h_comp_3], 'String','Before division','HorizontalAlignment','Left');
hLineage.Edit_outlier_before    = uicontrol('Parent',hLineage.panel_outlier,'Style','Edit',        'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s2 1-5*h_comp_3 w_e2 h_comp_3], 'String',num2str(param.tmp.outlier_before),'Callback',@refresh);
hLineage.Text_outlier_after     = uicontrol('Parent',hLineage.panel_outlier,'Style','Text',        'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[0.00 1-6*h_comp_3 w_s2 h_comp_3], 'String','After division','HorizontalAlignment','Left');
hLineage.Edit_outlier_after     = uicontrol('Parent',hLineage.panel_outlier,'Style','Edit',        'Units','normalized', 'FontWeight', fw1, 'FontSize', fs1,'Position',[w_s2 1-6*h_comp_3 w_e2 h_comp_3], 'String',num2str(param.tmp.outlier_after) ,'Callback',@refresh);
hLineage.Text_outlier.Visible = 'off';
hLineage.Text_outlier_ignore.Visible = 'off';
hLineage.Text_outlier_before.Visible = 'off';
hLineage.Text_outlier_after.Visible = 'off';
hLineage.Text_outlier_nosd.Visible = 'off';
hLineage.Edit_outlier_before.Visible = 'off';
hLineage.Edit_outlier_after.Visible = 'off';
hLineage.Edit_outlier_nosd.Visible = 'off';
%%
colors_line = {'yellow','magenta','cyan','red','green','blue','white','black'};
set(hLineage.Drop2,'String', colors_line);
set(hLineage.Drop2,'Value',6);
colors_heatmap = {'parula','jet','hsv','hot','cool','spring','summer','autumn','winter','gray','bone','copper','pink'};
set(hLineage.Drop3,'String', colors_heatmap);
set(hLineage.Drop3,'Value',10);
%%
param.tmp.zoomin_vertical = 1;
param.tmp.zoomin_horizontal = 1;
LineageDisplayShift_vertical = round(1000*(get(hLineage.Slider_disp_shi_vertical,'Value')))/1000;
LineageDisplayShift_horizontal = round(1000*(get(hLineage.Slider_disp_shi_horizontal,'Value')))/1000;
hLineage.axes1  = axes('Parent',hLineage.panel1,'Units','normalized','Position',[-LineageDisplayShift_horizontal*(param.tmp.zoomin_horizontal-1) , -LineageDisplayShift_vertical*(param.tmp.zoomin_vertical-1) , param.tmp.zoomin_horizontal , param.tmp.zoomin_vertical],'xtick',[],'ytick',[]);
%%
param.hLineage = hLineage;
param = Updatedisplay_Image_1(param);
param = Updatedisplay_Heatmap_3(param);
%%
InformAllInterfaces(param);
end
%%
%%
%%
function zoomStarted(h,~)
end
function zoomEnded(h,~)
param = guidata(h);
param.tmp.zoomin_vertical = 1;
param.tmp.zoomin_horizontal = 1;
set(param.hLineage.Edit_disp_zoom_vertical, 'string', num2str(1));
set(param.hLineage.Edit_disp_zoom_horizontal, 'string', num2str(1));
set(param.hLineage.Slider_disp_shi_vertical,'enable','off');
set(param.hLineage.Slider_disp_shi_horizontal,'enable','off');
LineageDisplayShift_vertical = round(1000*(get(param.hLineage.Slider_disp_shi_vertical,'Value')))/1000;
LineageDisplayShift_horizontal = round(1000*(get(param.hLineage.Slider_disp_shi_horizontal,'Value')))/1000;
set(param.hLineage.axes1,'Position',[-LineageDisplayShift_horizontal*(param.tmp.zoomin_horizontal-1) , -LineageDisplayShift_vertical*(param.tmp.zoomin_vertical-1) , param.tmp.zoomin_horizontal , param.tmp.zoomin_vertical]);
guidata(h,param);
end
%%
function refresh(h,~)
param = guidata(h);
if h == param.hLineage.Edit_outlier_before
    Edit_outlier_before = get(param.hLineage.Edit_outlier_before, 'string');
    outlier_before = round(str2double(Edit_outlier_before));
    if outlier_before >= 0
        param.tmp.outlier_before = outlier_before;
    else
        param.hLineage.Edit_outlier_before.String = num2str(param.tmp.outlier_before);
    end
end
if h == param.hLineage.Edit_outlier_after
    Edit_outlier_after  = get(param.hLineage.Edit_outlier_after , 'string');
    outlier_after = round(str2double(Edit_outlier_after));
    if outlier_after >= 0
        param.tmp.outlier_after = outlier_after;
    else
        param.hLineage.Edit_outlier_after.String = num2str(param.tmp.outlier_after);
    end
end
if h == param.hLineage.Edit_outlier_nosd
    Edit_outlier_nosd = get(param.hLineage.Edit_outlier_nosd, 'string');
    outlier_nosd = str2double(Edit_outlier_nosd);
    if outlier_nosd >= 0
        param.tmp.outlier_nosd = outlier_nosd;
    else
        param.hLineage.Edit_outlier_nosd.String = num2str(param.tmp.outlier_nosd);
    end
end
%%
param = Updatedisplay_Heatmap_0(param);
guidata(h,param);
guidata(param.hMain.fig,param);
end
