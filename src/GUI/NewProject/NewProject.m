function NewProject(h,~)
param = guidata(h);
%%
if isfield(param,'hNewProject')
    if isfield(param.hNewProject,'fig')
        if isgraphics(param.hNewProject.fig)
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
w_ctrl_1 = param.tmp.w_ctrl_1;
h_p1 = param.tmp.h_p1;
h_p2 = param.tmp.h_p2;
w_axes_1 = param.tmp.w_axes_1;
x_leftbottom_1 = param.tmp.x_leftbottom_1;
y_leftbottom_2 = param.tmp.y_leftbottom_1;
%%
hNewProject.fig = figure('name','New Project','NumberTitle','off','Units','pixels','Position',[x_leftbottom_1 y_leftbottom_2 w_ctrl_1+w_axes_1 h_p1+h_p2], 'MenuBar' , 'none' , 'ToolBar' , 'none','SizeChangedFcn',@SizeChangedFcn_NewProject);
%%
hNewProject.panel_directories  = uipanel('Position',[0.00 0.55 1.00 0.45]);
hNewProject.panel_filenames    = uipanel('Position',[0.00 0.10 1.00 0.45]);
%%
hNewProject.Text_panel_directories = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs2,'Position',[0.00 0.80 1.00 0.20], 'Visible','on',                  'String', 'Directories');
hNewProject.Help_set_dir_nuc_raw   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.00 0.05 0.60], 'Visible','on',                  'String', '?'                          ,'Callback',@help_directories);
hNewProject.Text_set_project       = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.40 0.35 0.20], 'Visible','on',                  'String', 'Project file');
hNewProject.Edit_set_project       = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.40 0.50 0.20], 'Visible','on', 'enable', 'off', 'String', '' );
hNewProject.Butt_set_project       = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.40 0.10 0.20], 'Visible','on', 'enable', 'on' , 'String', 'Set save path'              ,'Callback',@setpathproject);
hNewProject.Text_set_dir_nuc_raw   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.20 0.35 0.20], 'Visible','on',                  'String', 'Channel 1');
hNewProject.Edit_set_dir_nuc_raw   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.20 0.50 0.20], 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Butt_set_dir_nuc_raw   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.20 0.10 0.20], 'Visible','on', 'enable', 'off', 'String', 'Browse'                     ,'Callback',@setdirectorynucleimarker);
hNewProject.Text_set_dir_int_raw   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.35 0.20], 'Visible','on',                  'String', 'Channel 2');
hNewProject.Edit_set_dir_int_raw   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.50 0.20], 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Butt_set_dir_int_raw   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 0.00 0.10 0.20], 'Visible','on', 'enable', 'off', 'String', 'Browse'                     ,'Callback',@setdirectoryproteinofinterest);
%
hNewProject.Text_panel_filenames   = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs2,'Position',[0.00 0.80 1.00 0.20]  , 'Visible','on',                  'String', 'Filenames');
hNewProject.Butt_param_nuc_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.00 0.05 0.60]  , 'Visible','on',                  'String', '?'                          ,'Callback',@help_filenames);
hNewProject.Text_param_nuc_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.45 0.40 0.15]  , 'Visible','on',                  'String', 'Channel 1');
hNewProject.Edit_param_nuc_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.45 0.50 0.15]  , 'Visible','on', 'enable', 'off', 'String', ''                           ,'Callback',@CallbackFilenameFormats);
hNewProject.Text_param_int_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.30 0.40 0.15]  , 'Visible','on',                  'String', 'Channel 2');
hNewProject.Edit_param_int_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.30 0.50 0.15]  , 'Visible','on', 'enable', 'off', 'String', ''                           ,'Callback',@CallbackFilenameFormats);
hNewProject.Text_param_sce_ran     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.15 0.40 0.15]  , 'Visible','on',                  'String', 'Range of scene indices');
hNewProject.Text_param_sce_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.15 0.10 0.15]  , 'Visible','on',                  'String', 'Minimum');
hNewProject.Text_param_sce_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.70 0.15 0.10 0.15]  , 'Visible','on',                  'String', 'Maximum');
hNewProject.Edit_param_sce_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 0.15 0.10 0.15]  , 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Edit_param_sce_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 0.15 0.10 0.15]  , 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Text_param_fra_ran     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.40 0.15]  , 'Visible','on',                  'String', 'Range of time indices');
hNewProject.Text_param_fra_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.10 0.15]  , 'Visible','on',                  'String', 'Minimum');
hNewProject.Text_param_fra_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.70 0.00 0.10 0.15]  , 'Visible','on',                  'String', 'Maximum');
hNewProject.Edit_param_fra_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 0.00 0.10 0.15]  , 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Edit_param_fra_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 0.00 0.10 0.15]  , 'Visible','on', 'enable', 'off', 'String', '');
%
hNewProject.Butt_memory_2_harddisk = uicontrol('Parent',hNewProject.fig,            'Style', 'push', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 1.00 0.10]  , 'Visible','on', 'enable', 'on' , 'String', 'Save to project file'       ,'Callback',@save_project);
%%
param.hNewProject = hNewProject;
InformAllInterfaces(param);
end
%%
%%
%%
function help_directories(h,~)
msgbox('Project file: file for storing project information (directories and filenames) and parameters; Channel 1: nuclei marker, necessary; Channel 2: protein of interest, necessary for protein intensity quantification.'...
    ,'Directories','help');
end
function help_filenames(h,~)
msgbox('Filenames format: use < as placeholders for scene indices digits, > as placeholders for frame indices digits, and | for the separation of experiments (if there are multiple experiments with the same scenes, in this case also use | to separate frame ranges of different experiments). Range: minimum and maximum indices for scenes and frames.'...
    ,'Filenames','help');
end
%%
%%
function setpathproject(h,~)
param = guidata(h);
[FileName,PathName] = uiputfile('*.eDetectProject','Save Project As');
if ischar(FileName) && ischar(PathName)
    set(param.hNewProject.Edit_set_project,'String',fullfile(PathName,FileName));
    param.hNewProject.Butt_set_dir_nuc_raw.Enable = 'on';
    param.hNewProject.Butt_set_dir_int_raw.Enable = 'on';
    guidata(h,param);
end
end
%%
function setdirectorynucleimarker(h,~)
param = guidata(h);
actpath = get(param.hNewProject.Edit_set_project,'String');
if isempty(actpath)
    msgbox('Project file needs to be specified first.','Error','error');
    return;
end
new_dir = uigetdir;
if new_dir == 0
    return;
else
    set(param.hNewProject.Edit_set_dir_nuc_raw,'String',relativepath(new_dir,actpath));
    param.hNewProject.Edit_param_nuc_fil.Enable = 'on';
end
guidata(h,param);
end
%%
function setdirectoryproteinofinterest(h,~)
param = guidata(h);
actpath = get(param.hNewProject.Edit_set_project,'String');
if isempty(actpath)
    msgbox('Project file needs to be specified first.','Error','error');
    return;
end
new_dir = uigetdir;
if new_dir == 0
    return;
else
    set(param.hNewProject.Edit_set_dir_int_raw,'String',relativepath(new_dir,actpath));
    param.hNewProject.Edit_param_int_fil.Enable = 'on';
end
guidata(h,param);
end