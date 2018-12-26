function param = DisplayImage(param)
if isempty(param.tmp.dir_nucleimarker)
    return;
end
temp_file_path = fullfile(param.tmp.dir_nucleimarker , param.tmp.filenames_nucleimarker{1,1});
if exist(temp_file_path,'file') ~= 2
    return;
end
%%
example = imread(temp_file_path);
[param.tmp.h,param.tmp.w] = size(example);
param.tmp.val_min = intmin(class(example));
param.tmp.val_max = intmax(class(example));
param.tmp.val_range = double(param.tmp.val_max) - double(param.tmp.val_min) + 1;
%%
fs1 = 10;
fs2 = 12;
fw1 = 'normal';
fw2 = 'bold';
w_ed = 0.30;
w_sl = 0.70;
w_ctrl = param.tmp.w_ctrl_1;
h_p4 = param.tmp.h_p4;
h_p3 = param.tmp.h_p3;
w_axes = param.tmp.w_axes_1;
w_f  = param.hMain.fig.Position(3);
h_f = param.hMain.fig.Position(4);
%%
%%
hMain = param.hMain;
if isfield(hMain,'panel_navigation')
    delete(hMain.panel_navigation);
end
if isfield(hMain,'panel_display')
    delete(hMain.panel_display);
end
hMain.panel_navigation = uipanel('Parent',hMain.fig,'Units','pixels','Position',[1 h_f-h_p4 w_ctrl h_p4]);
hMain.panel_display    = uipanel('Parent',hMain.fig,'Units','pixels','Position',[1 h_f-h_p4-h_p3 w_ctrl h_p3]);
%% display control
n_comp_2 = 12;
h_comp_2 = 1/n_comp_2;
hMain.Text_panel_display = uicontrol('Parent',hMain.panel_display,'Style','Text'  , 'FontWeight', fw2, 'FontSize', fs2,'Units','normalized','Position',[0.00 1-2*h_comp_2 1.00 2*h_comp_2],'String','Display control');
%% transparency
hMain.Text5        = uicontrol('Parent',hMain.panel_display,'Style','Text'      , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-3*h_comp_2 1.00 h_comp_2],'String','Label transparency');
hMain.Edit5        = uicontrol('Parent',hMain.panel_display,'Style','Edit'      , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-4*h_comp_2 w_ed h_comp_2],'String','0','Callback',@CallbackImageDisplay);
hMain.SliderFrame5 = uicontrol('Parent',hMain.panel_display,'Style','slider'    , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[w_ed 1-4*h_comp_2 w_sl h_comp_2],'Min',0,'Max',1,'Value',0,'SliderStep',[1/1000 2/1000],'Callback',@CallbackImageDisplay);
%% display curve
hMain.Text_bg1     = uicontrol('Parent',hMain.panel_display,'Style','Text'      , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-5*h_comp_2 1.00 h_comp_2],'String','Adjust curves');
hMain.bg1          = uibuttongroup('Parent',hMain.panel_display,'Visible','off'                                     ,'Units','normalized','Position',[0.00 1-8*h_comp_2 1.00 3*h_comp_2]);
hMain.Radio11 = uicontrol('Parent',hMain.bg1              ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.00 1.00 0.33 ],'String','User defined','HandleVisibility','off','Callback',@CallbackImageDisplay);
hMain.Radio12 = uicontrol('Parent',hMain.bg1              ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.33 1.00 0.33 ],'String','Min Max'     ,'HandleVisibility','off','Callback',@CallbackImageDisplay,'Value',1);
hMain.Radio13 = uicontrol('Parent',hMain.bg1              ,'Style','radiobutton', 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 0.66 1.00 0.33 ],'String','Best fit'    ,'HandleVisibility','off','Callback',@CallbackImageDisplay);
hMain.bg1.Visible = 'on';
hMain.Text3        = uicontrol('Parent',hMain.panel_display,'Style','Text'      , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1- 9*h_comp_2 1.00 h_comp_2],'String','Min');
hMain.Edit3        = uicontrol('Parent',hMain.panel_display,'Style','Edit'      , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-10*h_comp_2 w_ed h_comp_2],'String',num2str(param.tmp.val_min),'Callback',@CallbackImageDisplay);
hMain.SliderFrame3 = uicontrol('Parent',hMain.panel_display,'Style','slider'    , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[w_ed 1-10*h_comp_2 w_sl h_comp_2],'Min',param.tmp.val_min,'Max',param.tmp.val_max,'Value',param.tmp.val_min,'SliderStep',[1/param.tmp.val_range 2/param.tmp.val_range],'Callback',@CallbackImageDisplay);
hMain.Text4        = uicontrol('Parent',hMain.panel_display,'Style','Text'      , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-11*h_comp_2 1.00 h_comp_2],'String','Max');
hMain.Edit4        = uicontrol('Parent',hMain.panel_display,'Style','Edit'      , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-12*h_comp_2 w_ed h_comp_2],'String',num2str(param.tmp.val_max),'Callback',@CallbackImageDisplay);
hMain.SliderFrame4 = uicontrol('Parent',hMain.panel_display,'Style','slider'    , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[w_ed 1-12*h_comp_2 w_sl h_comp_2],'Min',param.tmp.val_min,'Max',param.tmp.val_max,'Value',param.tmp.val_max,'SliderStep',[1/param.tmp.val_range 2/param.tmp.val_range],'Callback',@CallbackImageDisplay);
hMain.Text3.Visible = 'off';
hMain.Edit3.Visible = 'off';
hMain.SliderFrame3.Visible = 'off';
hMain.Text4.Visible = 'off';
hMain.Edit4.Visible = 'off';
hMain.SliderFrame4.Visible = 'off';
%% navigator
n_comp_1 = 8;
h_comp_1 = 1/n_comp_1;
hMain.Text_panel_navigation = uicontrol('Parent',hMain.panel_navigation,'Style','Text'  , 'FontWeight', fw2, 'FontSize', fs2,'Units','normalized','Position',[0.00 1-2*h_comp_1 1.00 2*h_comp_1],'String','Navigation');
hMain.Text_channel          = uicontrol('Parent',hMain.panel_navigation,'Style','Text'  , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-3*h_comp_1 1.00 h_comp_1],'String','Channel');
hMain.Drop_channel          = uicontrol('Parent',hMain.panel_navigation,'Style','popup' , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-4*h_comp_1 1.00 h_comp_1], 'Callback',@CallbackDropChannel);
hMain.Text1                 = uicontrol('Parent',hMain.panel_navigation,'Style','Text'  , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-5*h_comp_1 1.00 h_comp_1],'String','Scene');
hMain.Edit1                 = uicontrol('Parent',hMain.panel_navigation,'Style','Edit'  , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-6*h_comp_1 w_ed h_comp_1],'String','1','enable', 'off');
hMain.SliderFrame1          = uicontrol('Parent',hMain.panel_navigation,'Style','slider'                                    ,'Units','normalized','Position',[w_ed 1-6*h_comp_1 w_sl h_comp_1],'enable','off','Callback',@CallbackImageDisplayScene);
if param.tmp.n_scene > 1
    step1 = [1/(param.tmp.n_scene-1) 2/(param.tmp.n_scene-1)];
    set(hMain.SliderFrame1,'Min',param.tmp.min_scene,'Max',param.tmp.max_scene,'Value',param.tmp.min_scene,'SliderStep',step1,'enable','on');
end
hMain.Text2                 = uicontrol('Parent',hMain.panel_navigation,'Style','Text'  , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-7*h_comp_1 1.00 h_comp_1],'String','Frame');
hMain.Edit2                 = uicontrol('Parent',hMain.panel_navigation,'Style','Edit'  , 'FontWeight', fw1, 'FontSize', fs1,'Units','normalized','Position',[0.00 1-8*h_comp_1 w_ed h_comp_1],'String','1','Callback',@CallbackImageDisplayFrame);
hMain.SliderFrame2          = uicontrol('Parent',hMain.panel_navigation,'Style','slider'                                    ,'Units','normalized','Position',[w_ed 1-8*h_comp_1 w_sl h_comp_1],'enable','off','Callback',@CallbackImageDisplayFrame);
if param.tmp.n_time > 1
    step2 = [1/(param.tmp.n_time-1) 2/(param.tmp.n_time-1)];
    set(hMain.SliderFrame2,'Min',1,'Max',param.tmp.n_time,'Value',1,'SliderStep',step2,'enable','on');
end
%% tools
param.hMain = hMain;
set(param.hMain.pushtool_measure_distance  , 'Enable', 'on');
set(param.hMain.Drop_channel,'String',{'Channel 1','Channel 2','Channel 3','Channel 4','Channel 5'});
%%
param.tmp.manual_list_selected_objects = zeros([1,0]);
param = Updatedisplay_Image_1(param);
%CloseAllInterfacesButMain(param);
end