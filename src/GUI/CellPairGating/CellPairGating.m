function CellPairGating(h,~)
param = guidata(h);
if isfield(param,'hNucleiCellpairGating')
    if isfield(param.hNucleiCellpairGating,'fig')
        if isgraphics(param.hNucleiCellpairGating.fig)
            return;
        end
    end
end
%%
scene_array = str2double(strsplit(param.tmp.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
param.tmp.scenes_for_gating = scene_array;
%%
fs1 = 10;
fs2 = 12;
fw1 = 'normal';
fw2 = 'bold';
%%
w_ctrl = param.tmp.w_ctrl_1;
h_p1 = param.tmp.h_p1;
h_p2 = param.tmp.h_p2;
w_axes = param.tmp.w_axes_1;
x_leftbottom = param.tmp.x_leftbottom_1;
y_leftbottom = param.tmp.y_leftbottom_1;
%%
hNucleiCellpairGating.fig = figure('name','Cell Pair Gating','NumberTitle','off','Units','pixels','Position',[x_leftbottom y_leftbottom w_axes+w_ctrl h_p1+h_p2], 'MenuBar' , 'none' , 'ToolBar' , 'figure' ,'DockControls', 'off','SizeChangedFcn',@SizeChangedFcn_Cellpairgating);
%%
%temp1 = findall(gcf);
temp1 = findall(hNucleiCellpairGating.fig);
set(findall(temp1,'tag','Standard.NewFigure')         ,'Visible','Off');
set(findall(temp1,'tag','Standard.FileOpen')          ,'Visible','Off');
set(findall(temp1,'tag','Standard.PrintFigure')       ,'Visible','Off');
set(findall(temp1,'tag','Standard.EditPlot')          ,'Visible','Off');
set(findall(temp1,'tag','Exploration.Rotate')         ,'Visible','Off');
set(findall(temp1,'tag','Exploration.DataCursor')     ,'Visible','Off');
set(findall(temp1,'tag','Exploration.Brushing')       ,'Visible','Off');
set(findall(temp1,'tag','DataManager.Linking')        ,'Visible','Off');
set(findall(temp1,'tag','Annotation.InsertLegend')    ,'Visible','Off');
set(findall(temp1,'tag','Annotation.InsertColorbar')  ,'Visible','Off');
set(findall(temp1,'tag','Plottools.PlottoolsOff')     ,'Visible','Off');
set(findall(temp1,'tag','Plottools.PlottoolsOn')      ,'Visible','Off');
%%
%%
%%
%hNucleiCellpairGating.toolbar = uitoolbar(hNucleiCellpairGating.fig);
img_draw_polygon = imread('draw_polygon.tif');
img_draw_polygon = double(img_draw_polygon(:,:,1:3)) / 255;
img_delete_polygon = imread('delete_polygon.tif');
img_delete_polygon = double(img_delete_polygon(:,:,1:3)) / 255;
img_deselect_all = imread('deselect_all.tif');
img_deselect_all = double(img_deselect_all(:,:,1:3)) / 255;
img_detach = imread('detach.tif');
img_detach = double(img_detach(:,:,1:3)) / 255;
%%
%temp2 = hNucleiCellpairGating.toolbar;
temp2 = findall(hNucleiCellpairGating.fig,'tag','FigureToolBar');
hNucleiCellpairGating.pushtool_DrawPoly       = uipushtool(  temp2,'CData',img_draw_polygon   ,'TooltipString','Draw polygon'                    , 'Separator' , 'off' ,'ClickedCallback',@drawpolygon);
hNucleiCellpairGating.pushtool_DeletePoly     = uipushtool(  temp2,'CData',img_delete_polygon ,'TooltipString','Delete polygons'                 , 'Separator' , 'off' ,'ClickedCallback',@deletepolygon);
hNucleiCellpairGating.pushtool_ClearSelected  = uipushtool(  temp2,'CData',img_deselect_all   ,'TooltipString','Clear selected'                  , 'Separator' , 'off' ,'ClickedCallback',@clearselected);
hNucleiCellpairGating.pushtool_DetachTwoChild = uipushtool(  temp2,'CData',img_detach         ,'TooltipString','Detach two children from parent' , 'Separator' , 'off' ,'ClickedCallback',@EditCellpairPolygonObjects);
%%
%%
%%
hNucleiCellpairGating.panel_customize = uipanel(  'Parent',hNucleiCellpairGating.fig,'Units','pixels','Position',[1 1 w_ctrl h_p1+h_p2]);
hNucleiCellpairGating.Text_features   = uicontrol('Parent',hNucleiCellpairGating.panel_customize,'Style','Text'     , 'FontWeight', fw2, 'FontSize', fs2                     ,'Units','normalized','Position',[0.00 0.95 1.00 0.05], 'Visible','on' ,'String','Settings');
hNucleiCellpairGating.bg_combinations = uibuttongroup('Parent',hNucleiCellpairGating.panel_customize,'Visible','off'                                                         ,'Units','normalized','Position',[0.00 0.80 1.00 0.15]);
hNucleiCellpairGating.Radio11 = uicontrol('Parent',hNucleiCellpairGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.75 1.00 0.25 ],'String','Formula 1','HandleVisibility','off','Callback',@CallbackCustomize);
hNucleiCellpairGating.Radio12 = uicontrol('Parent',hNucleiCellpairGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.50 1.00 0.25 ],'String','Formula 2','HandleVisibility','off','Callback',@CallbackCustomize,'Value',1);
hNucleiCellpairGating.Radio13 = uicontrol('Parent',hNucleiCellpairGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.25 1.00 0.25 ],'String','Formula 3','HandleVisibility','off','Callback',@CallbackCustomize);
hNucleiCellpairGating.Radio14 = uicontrol('Parent',hNucleiCellpairGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.00 1.00 0.25 ],'String','User defined','HandleVisibility','off','Callback',@CallbackCustomize);
hNucleiCellpairGating.bg_combinations.Visible = 'on';
hNucleiCellpairGating.Text_features   = uicontrol('Parent',hNucleiCellpairGating.panel_customize,'Style','Text'     , 'FontWeight', fw2, 'FontSize', fs2                     ,'Units','normalized','Position',[0.00 0.75 1.00 0.05], 'Visible','on' ,'String','Features');
hNucleiCellpairGating.List_features   = uicontrol('parent',hNucleiCellpairGating.panel_customize,'Style','listbox'  , 'FontWeight', fw1, 'FontSize', fs1 ,'min',0,'max',300  ,'Units','normalized','Position',[0.00 0.35 1.00 0.40], 'Visible','on' ,'Value',[]);
hNucleiCellpairGating.Butt_features   = uicontrol('Parent',hNucleiCellpairGating.panel_customize,'Style','push'     , 'FontWeight', fw1, 'FontSize', fs1                     ,'Units','normalized','Position',[0.00 0.30 1.00 0.05], 'Visible','off','String','Generate formula','Callback', @CallbackListbox_cellpairgating);
hNucleiCellpairGating.Text_formula    = uicontrol('Parent',hNucleiCellpairGating.panel_customize,'Style','Text'     , 'FontWeight', fw2, 'FontSize', fs2                     ,'Units','normalized','Position',[0.00 0.25 1.00 0.05], 'Visible','on' ,'String','Formula');
hNucleiCellpairGating.Edit_formula    = uicontrol('parent',hNucleiCellpairGating.panel_customize,'Style','edit'     , 'FontWeight', fw1, 'FontSize', fs1 ,'min',0,'max',300  ,'Units','normalized','Position',[0.00 0.10 1.00 0.15], 'Visible','on' );
hNucleiCellpairGating.Check_normalize = uicontrol('Parent',hNucleiCellpairGating.panel_customize,'Style','Checkbox' , 'FontWeight', fw1, 'FontSize', fs1                     ,'Units','normalized','Position',[0.00 0.05 1.00 0.05], 'Visible','on' ,'String','Normalize','Value',0,'Callback',@showbutton);
hNucleiCellpairGating.Butt_formula    = uicontrol('Parent',hNucleiCellpairGating.panel_customize,'Style','push'     , 'FontWeight', fw1, 'FontSize', fs1                     ,'Units','normalized','Position',[0.00 0.00 1.00 0.05], 'Visible','off','String','Update','Callback', @refreshcellpairgating2);
%%
%%
param.tmp.feature_names = [];
temp0 = dir(fullfile(param.tmp.dir_feature, ['s' num2strdigits(param.tmp.scenes_for_gating(1),param.tmp.digits_scene(1))]));
if ~isempty(temp0)
    temp0(1:2) = [];
    samplefile = load(fullfile(temp0(1).folder , temp0(1).name));
    if isfield(samplefile,'feature_sha_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_sha_name];
    end
    %if isfield(samplefile,'feature_coo_name')
    %    param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_coo_name];
    %end
    if isfield(samplefile,'feature_int_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_int_name];
    end
    if isfield(samplefile,'feature_zer_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_zer_name];
    end
    if isfield(samplefile,'feature_har_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_har_name];
    end
    if isfield(samplefile,'feature_add_name')
        param.tmp.feature_names = [param.tmp.feature_names samplefile.feature_add_name];
    end
end
str = param.tmp.feature_names;
for i = 1:length(str)
    str{i} = ['v{' num2str(i) '}  ' str{i}];
end
set(hNucleiCellpairGating.List_features,'String',str);
str_formula = param.tmp.str_formula_2;
set(hNucleiCellpairGating.Edit_formula,'String',str_formula);
%%
hNucleiCellpairGating.axes1 = axes('Parent',hNucleiCellpairGating.fig, 'Units','pixels','Position',[w_ctrl+1 1 w_axes h_p1+h_p2], 'xtick',[], 'ytick',[] );
set(hNucleiCellpairGating.axes1,'ButtonDownFcn',@CallbackMouseClickOnCellpairGating,'HitTest','on');
if isfield(hNucleiCellpairGating,'poly')
    delete(hNucleiCellpairGating.poly);
    hNucleiCellpairGating = rmfield(hNucleiCellpairGating,'poly');
end
param.hNucleiCellpairGating = hNucleiCellpairGating;
param = Updatedisplay_Cellpairgating_2(param , false, []);
%%
InformAllInterfaces(param);
end
%%
function showbutton(h,~)
param = guidata(h);
param.hNucleiCellpairGating.Butt_formula.Visible = 'on';
guidata(h,param);
end
function clearselected(h,~)
param = guidata(h);
if isfield(param.hNucleiCellpairGating,'poly')
    delete(param.hNucleiCellpairGating.poly);
    param.hNucleiCellpairGating = rmfield(param.hNucleiCellpairGating,'poly');
end
param.tmp.cellpair_gating_selected = false([size(param.tmp.pc_cellpairgating,1),1]);
Updatedisplay_Cellpairgating_0(param);
guidata(h , param);
end
%%
function drawpolygon(h,~)
param = guidata(h);
if ~isfield(param.hNucleiCellpairGating,'poly')
    param.hNucleiCellpairGating.poly = [];
end
hp = impoly(param.hNucleiCellpairGating.axes1);
param.hNucleiCellpairGating.poly = [param.hNucleiCellpairGating.poly ; hp];
try
    id = addNewPositionCallback(hp,@refreshcellpairgating0);
catch
    msgbox('Please finish drawing polygon before other tasks.','Error','error');
    return;
end
param = updatepolygonselection(param);
param = Updatedisplay_Cellpairgating_0(param);
InformAllInterfaces(param);
end
%%
function deletepolygon(h,~)
param = guidata(h);
if isfield(param.hNucleiCellpairGating,'poly')
    delete(param.hNucleiCellpairGating.poly);
    param.hNucleiCellpairGating = rmfield(param.hNucleiCellpairGating,'poly');
end
param = Updatedisplay_Cellpairgating_0(param);
InformAllInterfaces(param);
end
%%
function refreshcellpairgating2(h,~)
param = guidata(h);
param = Updatedisplay_Cellpairgating_2(param , false, []);
InformAllInterfaces(param);
end
%%
function refreshcellpairgating0(~,~)
h = gcf;
param = guidata(h);
param = updatepolygonselection(param);
param = Updatedisplay_Cellpairgating_0(param);
InformAllInterfaces(param);
end
%%
function param = updatepolygonselection(param)
if isfield(param.hNucleiCellpairGating,'poly')
    l = length(param.hNucleiCellpairGating.poly);
    pos = cell([l,1]);
    for j = 1:l
        if isvalid(param.hNucleiCellpairGating.poly(j))
            pos{j} = getPosition(param.hNucleiCellpairGating.poly(j));
            in = inpolygon(param.tmp.pc_cellpairgating(:,1),param.tmp.pc_cellpairgating(:,2),pos{j}(:,1),pos{j}(:,2));
            param.tmp.cellpair_gating_selected = param.tmp.cellpair_gating_selected | in;
        end
    end
end
end
%%
function CallbackCustomize(h,~)
param = guidata(h);
%%
if param.hNucleiCellpairGating.Radio14.Value == 1
    param.hNucleiCellpairGating.Butt_features.Visible = 'on';
    param.hNucleiCellpairGating.Butt_formula.Visible = 'on';
else
    if param.hNucleiCellpairGating.Radio11.Value == 1
        str_formula = param.tmp.str_formula_1;
    elseif param.hNucleiCellpairGating.Radio12.Value == 1
        str_formula = param.tmp.str_formula_2;
    elseif param.hNucleiCellpairGating.Radio13.Value == 1
        str_formula = param.tmp.str_formula_3;
    elseif param.hNucleiCellpairGating.Radio14.Value == 1
        str_formula = param.tmp.str_formula_4;
    end
    set(param.hNucleiCellpairGating.Edit_formula,'String',str_formula);
    set(param.hNucleiCellpairGating.Check_normalize,'Value',0);
    param.hNucleiCellpairGating.Butt_features.Visible = 'off';
    param.hNucleiCellpairGating.Butt_formula.Visible = 'off';
end
param = Updatedisplay_Cellpairgating_2(param , false, []);
%%
guidata(h,param);
end
%%