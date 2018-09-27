function Parameters(h,~)
param = guidata(h);
%%
if isfield(param,'hSetParameter')
    if isfield(param.hSetParameter,'fig')
        if isgraphics(param.hSetParameter.fig)
            return;
        end
    end
end
%%
fs1 = 10;
fs2 = 12;
fw1 = 'normal';
fw2 = 'bold';
%%
w_ctrl = param.tmp.w_ctrl_2;
h_p1 = param.tmp.h_p1;
h_p2 = param.tmp.h_p2;
w_axes = param.tmp.w_axes_2;
x_leftbottom = param.tmp.x_leftbottom_2;
y_leftbottom = param.tmp.y_leftbottom_2;
%%
hSetParameter.fig = figure('name','Directories, Filenames and Parameters','NumberTitle','off','Units','pixels','Position',[x_leftbottom y_leftbottom w_ctrl+w_axes h_p2+h_p2], 'MenuBar' , 'none' , 'ToolBar' , 'none','SizeChangedFcn',@SizeChangedFcn_Parameters);
%%
hSetParameter.panel_directories  = uipanel('Position',[0.00 0.68 1.00 0.32]);
hSetParameter.panel_filenames    = uipanel('Position',[0.00 0.36 1.00 0.32]);
hSetParameter.panel_lengths      = uipanel('Position',[0.00 0.04 1.00 0.32]);
%% directories
hSetParameter.Text_panel_directories = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs2,'Position',[0.00 0.80 1.00 0.20], 'Visible','on', 'String', 'Directories');
hSetParameter.Help_set_dir_1         = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.50 0.05 0.30], 'Visible','on', 'String', '?'                          ,'Callback',@help_directories1);
hSetParameter.Text_set_project       = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.70 0.30 0.10], 'Visible','on', 'String', 'Project file');
hSetParameter.Edit_set_project       = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.70 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
hSetParameter.Text_set_dir_nuc_raw   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.60 0.30 0.10], 'Visible','on', 'String', 'Channel 1');
hSetParameter.Edit_set_dir_nuc_raw   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.60 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
hSetParameter.Text_set_dir_int_raw   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.50 0.30 0.10], 'Visible','on', 'String', 'Channel 2');
hSetParameter.Edit_set_dir_int_raw   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.50 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
%
hSetParameter.Help_set_dir_2         = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.00 0.05 0.50], 'Visible','on', 'String', '?'                          ,'Callback',@help_directories2);
hSetParameter.Text_set_dir_nuc_lab   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.40 0.30 0.10], 'Visible','on', 'String', 'Labels of objects');
hSetParameter.Edit_set_dir_nuc_lab   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.40 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
hSetParameter.Butt_set_dir_nuc_lab   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.40 0.10 0.10], 'Visible','on', 'String', 'Browse'                     ,'Callback',@setdirectorylabelnuclei);
hSetParameter.Text_set_dir_cyt_lab   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.30 0.30 0.10], 'Visible','on', 'String', 'Labels for measurement');
hSetParameter.Edit_set_dir_cyt_lab   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.30 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
hSetParameter.Butt_set_dir_cyt_lab   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.30 0.10 0.10], 'Visible','on', 'String', 'Browse'                     ,'Callback',@setdirectorylabelmeasurement);
hSetParameter.Text_set_dir_nuc_fea   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.20 0.30 0.10], 'Visible','on', 'String', 'Features');
hSetParameter.Edit_set_dir_nuc_fea   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.20 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
hSetParameter.Butt_set_dir_nuc_fea   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.20 0.10 0.10], 'Visible','on', 'String', 'Browse'                     ,'Callback',@setdirectoryfeature);
hSetParameter.Text_set_dir_lineage   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.10 0.30 0.10], 'Visible','on', 'String', 'Lineages');
hSetParameter.Edit_set_dir_lineage   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.10 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
hSetParameter.Butt_set_dir_lineage   = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.10 0.10 0.10], 'Visible','on', 'String', 'Browse'                     ,'Callback',@setdirectorylineage);
hSetParameter.Text_set_dir_measurement = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.30 0.10], 'Visible','on', 'String', 'Measurements');
hSetParameter.Edit_set_dir_measurement = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.50 0.10], 'Visible','on', 'String', '', 'enable', 'off');
hSetParameter.Butt_set_dir_measurement = uicontrol('Parent',hSetParameter.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.00 0.10 0.10], 'Visible','on', 'String', 'Browse'                   ,'Callback',@setdirectorymeasurement);
%% filenames
hSetParameter.Text_panel_filenames   = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs2,'Position',[0.00 0.80 1.00 0.20]  , 'Visible','on', 'String', 'Filenames');
hSetParameter.Butt_param_nuc_fil     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.00 0.05 0.60]  , 'Visible','on', 'String', '?','Callback',@help_filenames);
hSetParameter.Text_param_nuc_fil     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.45 0.40 0.15]  , 'String', 'Channel 1');
hSetParameter.Edit_param_nuc_fil     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.45 0.50 0.15]  , 'Enable', 'off','String', '');
hSetParameter.Text_param_int_fil     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.30 0.40 0.15]  , 'String', 'Channel 2');
hSetParameter.Edit_param_int_fil     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.30 0.50 0.15]  , 'Enable', 'off','String', '');
hSetParameter.Text_param_sce_ran     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.15 0.40 0.15]  , 'String', 'Range of scene indices');
hSetParameter.Text_param_sce_min     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.15 0.10 0.15]  , 'String', 'Minimum');
hSetParameter.Text_param_sce_max     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.70 0.15 0.10 0.15]  , 'String', 'Maximum');
hSetParameter.Edit_param_sce_min     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 0.15 0.10 0.15]  , 'Enable', 'off', 'String', '');
hSetParameter.Edit_param_sce_max     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 0.15 0.10 0.15]  , 'Enable', 'off', 'String', '');
hSetParameter.Text_param_fra_ran     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.40 0.15]  , 'String', 'Range of time indices');
hSetParameter.Text_param_fra_min     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.10 0.15]  , 'String', 'Minimum');
hSetParameter.Text_param_fra_max     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.70 0.00 0.10 0.15]  , 'String', 'Maximum');
hSetParameter.Edit_param_fra_min     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 0.00 0.10 0.15]  , 'Enable', 'off', 'String', '');
hSetParameter.Edit_param_fra_max     = uicontrol('Parent',hSetParameter.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 0.00 0.10 0.15]  , 'Enable', 'off', 'String', '');
%% parameters
hSetParameter.Text_panel_lengths     = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs2,'Position',[0.00 0.80 1.00 0.20]  , 'Visible','on', 'String', 'Parameters');
hSetParameter.Help_panel_lengths     = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.40 0.05 0.20]  , 'Visible','on', 'String', '?','Callback',@help_distances1);
hSetParameter.Text_param_obj_rad     = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.40 0.45 0.20]  , 'Visible','on', 'String', 'Object diameter');
hSetParameter.Text_param_min_obj_rad = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.40 0.10 0.20]  , 'Visible','on', 'String', 'Minimum');
hSetParameter.Text_param_med_obj_rad = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.65 0.40 0.10 0.20]  , 'Visible','on', 'String', 'Median');
hSetParameter.Text_param_max_obj_rad = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 0.40 0.10 0.20]  , 'Visible','on', 'String', 'Maximum');
hSetParameter.Edit_param_min_obj_rad = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 0.40 0.05 0.20]  , 'Visible','on', 'String', '');
hSetParameter.Edit_param_med_obj_rad = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.75 0.40 0.05 0.20]  , 'Visible','on', 'String', '');
hSetParameter.Edit_param_max_obj_rad = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.90 0.40 0.05 0.20]  , 'Visible','on', 'String', '');
hSetParameter.Help_panel_lengths     = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.20 0.05 0.20]  , 'Visible','on', 'String', '?','Callback',@help_distances2);
hSetParameter.Text_param_fra_dsp     = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.20 0.45 0.20]  , 'Visible','on', 'String', 'Object displacement');
hSetParameter.Text_param_max_fra_dsp = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.20 0.10 0.20]  , 'Visible','on', 'String', 'Maximum');
hSetParameter.Edit_param_max_fra_dsp = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 0.20 0.05 0.20]  , 'Visible','on', 'String', '');
hSetParameter.Help_panel_lengths     = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.00 0.05 0.20]  , 'Visible','on', 'String', '?','Callback',@help_distances3);
hSetParameter.Text_exp_rad           = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.45 0.20]  , 'Visible','on', 'String', 'Object shrinkage and expansion');
hSetParameter.Text_radii_n_1         = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.10 0.20]  , 'Visible','on', 'String', 'Distance 1 (shrink)');
hSetParameter.Text_radii_c_1         = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.65 0.00 0.10 0.20]  , 'Visible','on', 'String', 'Distance 2 (expand)');
hSetParameter.Text_radii_c_2         = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 0.00 0.10 0.20]  , 'Visible','on', 'String', 'Distance 3 (expand)');
hSetParameter.Edit_radii_n_1         = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 0.00 0.05 0.20]  , 'Visible','on', 'String', '');
hSetParameter.Edit_radii_c_1         = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.75 0.00 0.05 0.20]  , 'Visible','on', 'String', '');
hSetParameter.Edit_radii_c_2         = uicontrol('Parent',hSetParameter.panel_lengths,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.90 0.00 0.05 0.20]  , 'Visible','on', 'String', '');
%%
hSetParameter.Butt_memory_2_harddisk = uicontrol('Parent',hSetParameter.fig,          'Style', 'push', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 1.00 0.04]  , 'String', 'Save to project file'  , 'Callback', @save_parameters);
%%
param.hSetParameter = hSetParameter;
InformAllInterfaces(param);
show_parameters(param);
end
%%
%%
%%
function help_directories1(h,~)
msgbox('Display only. If you want to modify these settings, please create a new project.'...
    ,'Directories','help');
end
function help_directories2(h,~)
msgbox('These paths are automatically generated using Channel 1 directory. They are used for storing the results of the automatic data analysis modules.'...
    ,'Directories','help');
end
function help_filenames(h,~)
msgbox('Display only. If you want to modify these settings, please create a new project.'...
    ,'Filenames','help');
end
function help_distances1(h,~)
msgbox('These parameters are measured in pixels using the tool "Measure distance" in the toolbar on Main Interface. Object diameter: diameter of a circle whose area is equal to the area of the object.'...
    ,'Object radius','help');
end
function help_distances2(h,~)
msgbox('This parameter is measured in pixels using the tool "Measure distance" in the toolbar on Main Interface. Object displacement: distance an object moves between 2 consecutive frames.'...
    ,'Object displacement','help');
end
function help_distances3(h,~)
param = guidata(h);
fs1 = 10;
fs2 = 12;
fw1 = 'normal';
fw2 = 'bold';
w_ctrl = param.tmp.w_ctrl_1;
h_p1 = param.tmp.h_p1;
h_p2 = param.tmp.h_p2;
w_axes = param.tmp.w_axes_1;
x_leftbottom = param.tmp.x_leftbottom_1;
y_leftbottom = param.tmp.y_leftbottom_1;
I_temp = imread('expand_shrink.png');
h1.fig = figure('name','Object shrinkage and expansion','NumberTitle','off' , 'MenuBar' , 'none' , 'ToolBar' , 'none' ,'DockControls', 'off','Units','pixels','Position',[x_leftbottom y_leftbottom w_ctrl+w_axes h_p2+h_p2]);
h1.ax = axes('Parent',h1.fig,'Units','normalized','Position',[0.00 0.10 1.00 0.90]);
h1.im = imshow(I_temp,'Parent',h1.ax);
str = 'These parameters are measured in pixels using the tool "Measure distance" in the toolbar on Main Interface. Object shrinkage and expansion: these distances are used for shrinking or expanding the segmented object labels to generate regions for measuring nuclei and cytoplasm intensities. Please refer to the figure to see the meanings of the distances.';
h1.text = uicontrol('Parent',h1.fig,'Style', 'Text','Units','normalized','Position',[0.00 0.00 1.00 0.10] , 'FontWeight', fw1, 'FontSize', fs1,'String', str);
end
%%
%%
%%
%%
%%
function setdirectorylabelnuclei(h,~)
param = guidata(h);
actpath = get(param.hSetParameter.Edit_set_project,'String');
if isempty(actpath)
    msgbox('Project file needs to be specified first.','Error');
    return;
end
new_dir = uigetdir;
if new_dir == 0
    return;
else
    set(param.hSetParameter.Edit_set_dir_nuc_lab,'String',relativepath(new_dir,actpath));
end
guidata(h,param);
guidata(param.hMain.fig,param);
end
%%
function setdirectoryfeature(h,~)
param = guidata(h);
actpath = get(param.hSetParameter.Edit_set_project,'String');
if isempty(actpath)
    msgbox('Project file needs to be specified first.','Error');
    return;
end
new_dir = uigetdir;
if new_dir == 0
    return;
else
    set(param.hSetParameter.Edit_set_dir_nuc_fea,'String',relativepath(new_dir,actpath));
end
guidata(h,param);
guidata(param.hMain.fig,param);
end
%%
function setdirectorylineage(h,~)
param = guidata(h);
actpath = get(param.hSetParameter.Edit_set_project,'String');
if isempty(actpath)
    msgbox('Project file needs to be specified first.','Error');
    return;
end
new_dir = uigetdir;
if new_dir == 0
    return;
else
    set(param.hSetParameter.Edit_set_dir_lineage,'String',relativepath(new_dir,actpath));
end
guidata(h,param);
guidata(param.hMain.fig,param);
end
%%
function setdirectorylabelmeasurement(h,~)
param = guidata(h);
actpath = get(param.hSetParameter.Edit_set_project,'String');
if isempty(actpath)
    msgbox('Project file needs to be specified first.','Error');
    return;
end
new_dir = uigetdir;
if new_dir == 0
    return;
else
    set(param.hSetParameter.Edit_set_dir_cyt_lab,'String',relativepath(new_dir,actpath));
end
guidata(h,param);
guidata(param.hMain.fig,param);
end
%%
function setdirectorymeasurement(h,~)
param = guidata(h);
actpath = get(param.hSetParameter.Edit_set_project,'String');
if isempty(actpath)
    msgbox('Project file needs to be specified first.','Error');
    return;
end
new_dir = uigetdir;
if new_dir == 0
    return;
else
    set(param.hSetParameter.Edit_set_dir_measurement,'String',relativepath(new_dir,actpath));
end
guidata(h,param);
guidata(param.hMain.fig,param);
end
%%
%%
%%
%%