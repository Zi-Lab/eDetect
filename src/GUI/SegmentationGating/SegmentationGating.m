function SegmentationGating(h,~)
param = guidata(h);
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
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
hNucleiSegmentationGating.fig = figure('name','Segmentation Gating','NumberTitle','off','Units','pixels','Position',[x_leftbottom y_leftbottom w_axes+w_ctrl h_p1+h_p2], 'MenuBar' , 'none' , 'ToolBar' , 'figure' ,'DockControls', 'off','SizeChangedFcn',@SizeChangedFcn_Segmentationgating);
%%
%temp1 = findall(gcf);
temp1 = findall(hNucleiSegmentationGating.fig);
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
%temp2 = findall(temp1,'ToolTipString','New Figure');
%{'New Figure','Open File','Save Figure','Print Figure','Edit Plot','Zoom In','Zoom Out','Pan','Rotate 3D','Data Cursor','Brush/Select Data','Link Plot','Insert Legend','Insert Colorbar','Hide Plot Tools','Show Plot Tools and Dock Figure'}
%%

%%
%hNucleiSegmentationGating.toolbar = uitoolbar(hNucleiSegmentationGating.fig);
img_display_deleted = imread('display_deleted.tif');
img_display_deleted = double(img_display_deleted(:,:,1:3)) / 255;
img_draw_polygon = imread('draw_polygon.tif');
img_draw_polygon = double(img_draw_polygon(:,:,1:3)) / 255;
img_delete_polygon = imread('delete_polygon.tif');
img_delete_polygon = double(img_delete_polygon(:,:,1:3)) / 255;
img_deselect_all = imread('deselect_all.tif');
img_deselect_all = double(img_deselect_all(:,:,1:3)) / 255;
img_delete_objects = imread('delete_objects.tif');
img_delete_objects = double(img_delete_objects(:,:,1:3)) / 255;
img_recover_objects = imread('recover_objects.tif');
img_recover_objects = double(img_recover_objects(:,:,1:3)) / 255;
img_split_objects = imread('split_objects.tif');
img_split_objects = double(img_split_objects(:,:,1:3)) / 255;
img_remove_objects = imread('remove_objects.tif');
img_remove_objects = double(img_remove_objects(:,:,1:3)) / 255;
%%
%temp2 = hNucleiSegmentationGating.toolbar;
temp2 = findall(hNucleiSegmentationGating.fig,'tag','FigureToolBar');
hNucleiSegmentationGating.toggletool_DisplayDeleted= uitoggletool(temp2,'CData',img_display_deleted ,'TooltipString','Display deleted'          , 'Separator' , 'off' ,'ClickedCallback',@refreshgating2);
hNucleiSegmentationGating.pushtool_DrawPoly        = uipushtool(  temp2,'CData',img_draw_polygon    ,'TooltipString','Draw a polygon'           , 'Separator' , 'off' ,'ClickedCallback',@drawpolygon);
hNucleiSegmentationGating.pushtool_DeletePoly      = uipushtool(  temp2,'CData',img_delete_polygon  ,'TooltipString','Delete polygons'          , 'Separator' , 'off' ,'ClickedCallback',@deletepolygons);
hNucleiSegmentationGating.pushtool_ClearSelected   = uipushtool(  temp2,'CData',img_deselect_all    ,'TooltipString','Clear selection'          , 'Separator' , 'off' ,'ClickedCallback',@clearselection);
hNucleiSegmentationGating.pushtool_objects_delete  = uipushtool(  temp2,'CData',img_delete_objects  ,'TooltipString','Delete objects selected'  , 'Separator' , 'off' ,'ClickedCallback',@EditSegmentationPolygonObjects);
hNucleiSegmentationGating.pushtool_objects_recover = uipushtool(  temp2,'CData',img_recover_objects ,'TooltipString','Recover objects selected' , 'Separator' , 'off' ,'ClickedCallback',@EditSegmentationPolygonObjects);
hNucleiSegmentationGating.pushtool_objects_split   = uipushtool(  temp2,'CData',img_split_objects   ,'TooltipString','Split objects selected'   , 'Separator' , 'off' ,'ClickedCallback',@EditSegmentationPolygonObjects);
hNucleiSegmentationGating.pushtool_objects_remove  = uipushtool(  temp2,'CData',img_remove_objects  ,'TooltipString','Remove objects selected'  , 'Separator' , 'off' ,'ClickedCallback',@EditSegmentationPolygonObjects);
%%
%%
%%
hNucleiSegmentationGating.panel_customize = uipanel(  'Parent',hNucleiSegmentationGating.fig,'Units','pixels','Position',[1 1 w_ctrl h_p1+h_p2]);
hNucleiSegmentationGating.Text_setting    = uicontrol('Parent',hNucleiSegmentationGating.panel_customize,'Style','Text'     , 'FontWeight', fw2, 'FontSize', fs2                     ,'Units','normalized','Position',[0.00 0.95 1.00 0.05], 'Visible','on' ,'String','Settings');
hNucleiSegmentationGating.bg_combinations = uibuttongroup('Parent',hNucleiSegmentationGating.panel_customize,'Visible','off'                                                         ,'Units','normalized','Position',[0.00 0.80 1.00 0.15]);
hNucleiSegmentationGating.Radio11 = uicontrol('Parent',hNucleiSegmentationGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.75 1.00 0.25 ],'String','Formula 1','HandleVisibility','off','Callback',@CallbackCustomize,'Value',1);
hNucleiSegmentationGating.Radio12 = uicontrol('Parent',hNucleiSegmentationGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.50 1.00 0.25 ],'String','Formula 2','HandleVisibility','off','Callback',@CallbackCustomize);
hNucleiSegmentationGating.Radio13 = uicontrol('Parent',hNucleiSegmentationGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.25 1.00 0.25 ],'String','Formula 3','HandleVisibility','off','Callback',@CallbackCustomize);
hNucleiSegmentationGating.Radio14 = uicontrol('Parent',hNucleiSegmentationGating.bg_combinations ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.00 1.00 0.25 ],'String','User defined','HandleVisibility','off','Callback',@CallbackCustomize);
hNucleiSegmentationGating.bg_combinations.Visible = 'on';
hNucleiSegmentationGating.Text_features   = uicontrol('Parent',hNucleiSegmentationGating.panel_customize,'Style','Text'     , 'FontWeight', fw2, 'FontSize', fs2                     ,'Units','normalized','Position',[0.00 0.75 1.00 0.05], 'Visible','on' ,'String','Features');
hNucleiSegmentationGating.List_features   = uicontrol('parent',hNucleiSegmentationGating.panel_customize,'Style','listbox'  , 'FontWeight', fw1, 'FontSize', fs1 ,'min',0,'max',300  ,'Units','normalized','Position',[0.00 0.35 1.00 0.40], 'Visible','on' ,'Value',[]);
hNucleiSegmentationGating.Butt_features   = uicontrol('Parent',hNucleiSegmentationGating.panel_customize,'Style','push'     , 'FontWeight', fw1, 'FontSize', fs1                     ,'Units','normalized','Position',[0.00 0.30 1.00 0.05], 'Visible','off','String','Generate formula','Callback', @CallbackListbox_segmentationgating);
hNucleiSegmentationGating.Text_formula    = uicontrol('Parent',hNucleiSegmentationGating.panel_customize,'Style','Text'     , 'FontWeight', fw2, 'FontSize', fs2                     ,'Units','normalized','Position',[0.00 0.25 1.00 0.05], 'Visible','on' ,'String','Formula');
hNucleiSegmentationGating.Edit_formula    = uicontrol('parent',hNucleiSegmentationGating.panel_customize,'Style','edit'     , 'FontWeight', fw1, 'FontSize', fs1 ,'min',0,'max',300  ,'Units','normalized','Position',[0.00 0.10 1.00 0.15], 'Visible','on' );
hNucleiSegmentationGating.Check_normalize = uicontrol('Parent',hNucleiSegmentationGating.panel_customize,'Style','Checkbox' , 'FontWeight', fw1, 'FontSize', fs1                     ,'Units','normalized','Position',[0.00 0.05 1.00 0.05], 'Visible','on' ,'String','Normalize','Value',1,'Callback', @showbutton);
hNucleiSegmentationGating.Butt_formula    = uicontrol('Parent',hNucleiSegmentationGating.panel_customize,'Style','push'     , 'FontWeight', fw1, 'FontSize', fs1                     ,'Units','normalized','Position',[0.00 0.00 1.00 0.05], 'Visible','off','String','Update','Callback', @refreshgating2);
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
set(hNucleiSegmentationGating.List_features,'String',str);
str_formula = param.tmp.str_formula_1;
set(hNucleiSegmentationGating.Edit_formula,'String',str_formula);
%%
hNucleiSegmentationGating.axes1 = axes('Parent',hNucleiSegmentationGating.fig, 'Units','pixels','Position',[w_ctrl+1 1 w_axes h_p1+h_p2], 'xtick',[], 'ytick',[] );
set(hNucleiSegmentationGating.axes1,'ButtonDownFcn',@CallbackMouseClickOnSegmentationGating,'HitTest','on');
if isfield(hNucleiSegmentationGating,'poly')
    delete(hNucleiSegmentationGating.poly);
    hNucleiSegmentationGating = rmfield(hNucleiSegmentationGating,'poly');
end
param.hNucleiSegmentationGating = hNucleiSegmentationGating;
param = Updatedisplay_Segmentationgating_2(param,false,[]);
%%
InformAllInterfaces(param);
end
%%
function showbutton(h,~)
param = guidata(h);
param.hNucleiSegmentationGating.Butt_formula.Visible = 'on';
guidata(h,param);
end
function clearselection(h,~)
param = guidata(h);
if isfield(param.hNucleiSegmentationGating,'poly')
    delete(param.hNucleiSegmentationGating.poly);
    param.hNucleiSegmentationGating = rmfield(param.hNucleiSegmentationGating,'poly');
end
param.tmp.segmentation_gating_selected = false([size(param.tmp.pc_segmentationgating,1),1]);
param = Updatedisplay_Segmentationgating_0(param);
InformAllInterfaces(param);
end
%%
function drawpolygon(h,~)
param = guidata(h);
if ~isfield(param.hNucleiSegmentationGating,'poly')
    param.hNucleiSegmentationGating.poly = [];
end
hp = impoly(param.hNucleiSegmentationGating.axes1);
param.hNucleiSegmentationGating.poly = [param.hNucleiSegmentationGating.poly ; hp];
try
    id = addNewPositionCallback(hp,@refreshgating0);
catch
    msgbox('Please finish drawing polygon before other tasks.','Error','error');
    return;
end
param = updatepolygonselection(param);
param = Updatedisplay_Segmentationgating_0(param);
InformAllInterfaces(param);
end
%%
function deletepolygons(h,~)
param = guidata(h);
if isfield(param.hNucleiSegmentationGating,'poly')
    delete(param.hNucleiSegmentationGating.poly);
    param.hNucleiSegmentationGating = rmfield(param.hNucleiSegmentationGating,'poly');
end
param = Updatedisplay_Segmentationgating_0(param);
InformAllInterfaces(param);
end
%%
function refreshgating2(h,~)
param = guidata(h);
param = Updatedisplay_Segmentationgating_2(param , false ,[]);
InformAllInterfaces(param);
end
%%
function refreshgating0(~,~)
h = gcf;
param = guidata(h);
param = updatepolygonselection(param);
param = Updatedisplay_Segmentationgating_0(param);
InformAllInterfaces(param);
end
%%
function param = updatepolygonselection(param)
if isfield(param.hNucleiSegmentationGating,'poly')
    l = length(param.hNucleiSegmentationGating.poly);
    pos = cell([l,1]);
    for j = 1:l
        if isvalid(param.hNucleiSegmentationGating.poly(j))
            pos{j} = getPosition(param.hNucleiSegmentationGating.poly(j));
            in = inpolygon(param.tmp.pc_segmentationgating(:,1),param.tmp.pc_segmentationgating(:,2),pos{j}(:,1),pos{j}(:,2));
            param.tmp.segmentation_gating_selected = param.tmp.segmentation_gating_selected | in;
        end
    end
end
end
%%
function CallbackCustomize(h,~)
param = guidata(h);
%%
if param.hNucleiSegmentationGating.Radio14.Value == 1
    param.hNucleiSegmentationGating.Butt_features.Visible = 'on';
    param.hNucleiSegmentationGating.Butt_formula.Visible = 'on';
else
    if param.hNucleiSegmentationGating.Radio11.Value == 1
        str_formula = param.tmp.str_formula_1;
    elseif param.hNucleiSegmentationGating.Radio12.Value == 1
        str_formula = param.tmp.str_formula_2;
    elseif param.hNucleiSegmentationGating.Radio13.Value == 1
        str_formula = param.tmp.str_formula_3;
    end
    set(param.hNucleiSegmentationGating.Edit_formula,'String',str_formula);
    set(param.hNucleiSegmentationGating.Check_normalize,'Value',1);
    param.hNucleiSegmentationGating.Butt_features.Visible = 'off';
    param.hNucleiSegmentationGating.Butt_formula.Visible = 'off';
end
param = Updatedisplay_Segmentationgating_2(param,false,[]);
%%
InformAllInterfaces(param);
end