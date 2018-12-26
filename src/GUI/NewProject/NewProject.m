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
tmp1 = 0.12;
hNewProject.Text_panel_directories = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs2,'Position',[0.00 0.90 1.00 0.10], 'Visible','on',                  'String', 'Directories');
hNewProject.Help_set_dir_nuc   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.00 0.05 tmp1*6], 'Visible','on',                  'String', '?'                          ,'Callback',@help_directories);
hNewProject.Text_set_project   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp1*5 0.35 tmp1], 'Visible','on',                  'String', 'Project file');
hNewProject.Edit_set_project   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp1*5 0.50 tmp1], 'Visible','on', 'enable', 'off', 'String', '' );
hNewProject.Butt_set_project   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 tmp1*5 0.10 tmp1], 'Visible','on', 'enable', 'on' , 'String', 'Set save path'              ,'Callback',@setpathproject);
hNewProject.Text_set_dir_nuc   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp1*4 0.35 tmp1], 'Visible','on',                  'String', 'Channel 1');
hNewProject.Edit_set_dir_nuc   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp1*4 0.50 tmp1], 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Butt_set_dir_nuc   = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 tmp1*4 0.10 tmp1], 'Visible','on', 'enable', 'off', 'String', 'Browse'                     ,'Callback',@setdirectorynucleimarker);
hNewProject.Text_set_dir_int1  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp1*3 0.35 tmp1], 'Visible','on',                  'String', 'Channel 2');
hNewProject.Edit_set_dir_int1  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp1*3 0.50 tmp1], 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Butt_set_dir_int1  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 tmp1*3 0.10 tmp1], 'Visible','on', 'enable', 'off', 'String', 'Browse'                     ,'Callback',@setdirectoryproteinofinterest1);
hNewProject.Text_set_dir_int2  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp1*2 0.35 tmp1], 'Visible','on',                  'String', 'Channel 3');
hNewProject.Edit_set_dir_int2  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp1*2 0.50 tmp1], 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Butt_set_dir_int2  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 tmp1*2 0.10 tmp1], 'Visible','on', 'enable', 'off', 'String', 'Browse'                     ,'Callback',@setdirectoryproteinofinterest2);
hNewProject.Text_set_dir_int3  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp1*1 0.35 tmp1], 'Visible','on',                  'String', 'Channel 4');
hNewProject.Edit_set_dir_int3  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp1*1 0.50 tmp1], 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Butt_set_dir_int3  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 tmp1*1 0.10 tmp1], 'Visible','on', 'enable', 'off', 'String', 'Browse'                     ,'Callback',@setdirectoryproteinofinterest3);
hNewProject.Text_set_dir_int4  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp1*0 0.35 tmp1], 'Visible','on',                  'String', 'Channel 5');
hNewProject.Edit_set_dir_int4  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp1*0 0.50 tmp1], 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Butt_set_dir_int4  = uicontrol('Parent',hNewProject.panel_directories,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.35 tmp1*0 0.10 tmp1], 'Visible','on', 'enable', 'off', 'String', 'Browse'                     ,'Callback',@setdirectoryproteinofinterest4);
%
tmp2 = 0.11;
hNewProject.Text_panel_filenames   = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs2,'Position',[0.00 0.90 1.00 0.10]  , 'Visible','on',                  'String', 'Filenames');
hNewProject.Butt_param_nuc_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'push', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.45 0.00 0.05 tmp2*7]  , 'Visible','on',                  'String', '?'                          ,'Callback',@help_filenames);
hNewProject.Text_param_nuc_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp2*6 0.40 tmp2]  , 'Visible','on',                  'String', 'Channel 1');
hNewProject.Edit_param_nuc_fil     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp2*6 0.50 tmp2]  , 'Visible','on', 'enable', 'off', 'String', ''                           ,'Callback',@CallbackFilenameFormats);
hNewProject.Text_param_int_fil1    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp2*5 0.40 tmp2]  , 'Visible','on',                  'String', 'Channel 2');
hNewProject.Edit_param_int_fil1    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp2*5 0.50 tmp2]  , 'Visible','on', 'enable', 'off', 'String', ''                           ,'Callback',@CallbackFilenameFormats);
hNewProject.Text_param_int_fil2    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp2*4 0.40 tmp2]  , 'Visible','on',                  'String', 'Channel 3');
hNewProject.Edit_param_int_fil2    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp2*4 0.50 tmp2]  , 'Visible','on', 'enable', 'off', 'String', ''                           ,'Callback',@CallbackFilenameFormats);
hNewProject.Text_param_int_fil3    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp2*3 0.40 tmp2]  , 'Visible','on',                  'String', 'Channel 4');
hNewProject.Edit_param_int_fil3    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp2*3 0.50 tmp2]  , 'Visible','on', 'enable', 'off', 'String', ''                           ,'Callback',@CallbackFilenameFormats);
hNewProject.Text_param_int_fil4    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp2*2 0.40 tmp2]  , 'Visible','on',                  'String', 'Channel 5');
hNewProject.Edit_param_int_fil4    = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp2*2 0.50 tmp2]  , 'Visible','on', 'enable', 'off', 'String', ''                           ,'Callback',@CallbackFilenameFormats);
hNewProject.Text_param_sce_ran     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp2*1 0.40 tmp2]  , 'Visible','on',                  'String', 'Range of scene indices');
hNewProject.Text_param_sce_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp2*1 0.10 tmp2]  , 'Visible','on',                  'String', 'Minimum');
hNewProject.Text_param_sce_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.70 tmp2*1 0.10 tmp2]  , 'Visible','on',                  'String', 'Maximum');
hNewProject.Edit_param_sce_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 tmp2*1 0.10 tmp2]  , 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Edit_param_sce_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 tmp2*1 0.10 tmp2]  , 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Text_param_fra_ran     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 tmp2*0 0.40 tmp2]  , 'Visible','on',                  'String', 'Range of time indices');
hNewProject.Text_param_fra_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 tmp2*0 0.10 tmp2]  , 'Visible','on',                  'String', 'Minimum');
hNewProject.Text_param_fra_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Text', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.70 tmp2*0 0.10 tmp2]  , 'Visible','on',                  'String', 'Maximum');
hNewProject.Edit_param_fra_min     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.60 tmp2*0 0.10 tmp2]  , 'Visible','on', 'enable', 'off', 'String', '');
hNewProject.Edit_param_fra_max     = uicontrol('Parent',hNewProject.panel_filenames,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.80 tmp2*0 0.10 tmp2]  , 'Visible','on', 'enable', 'off', 'String', '');
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
msgbox('Project file: file for storing project information (directories and filenames) and parameters; Channel 1: nuclei marker, necessary; Channel 2-4: protein of interest, necessary for protein intensity quantification.'...
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
    param.hNewProject.Butt_set_dir_nuc.Enable = 'on';
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
    set(param.hNewProject.Edit_set_dir_nuc,'String',relativepath(new_dir,actpath));
    param.hNewProject.Edit_param_nuc_fil.Enable = 'on';
    param.hNewProject.Butt_set_dir_int1.Enable = 'on';
end
guidata(h,param);
end
%%
function setdirectoryproteinofinterest1(h,~)
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
    set(param.hNewProject.Edit_set_dir_int1,'String',relativepath(new_dir,actpath));
    param.hNewProject.Edit_param_int_fil1.Enable = 'on';
    param.hNewProject.Butt_set_dir_int2.Enable = 'on';
end
guidata(h,param);
end
function setdirectoryproteinofinterest2(h,~)
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
    set(param.hNewProject.Edit_set_dir_int2,'String',relativepath(new_dir,actpath));
    param.hNewProject.Edit_param_int_fil2.Enable = 'on';
    param.hNewProject.Butt_set_dir_int3.Enable = 'on';
end
guidata(h,param);
end
function setdirectoryproteinofinterest3(h,~)
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
    set(param.hNewProject.Edit_set_dir_int3,'String',relativepath(new_dir,actpath));
    param.hNewProject.Edit_param_int_fil3.Enable = 'on';
end
guidata(h,param);
end
function setdirectoryproteinofinterest4(h,~)
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
    set(param.hNewProject.Edit_set_dir_int4,'String',relativepath(new_dir,actpath));
    param.hNewProject.Edit_param_int_fil4.Enable = 'on';
end
guidata(h,param);
end