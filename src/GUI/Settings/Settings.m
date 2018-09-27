function Settings( h,~ )
param = guidata(h);
%%
if isfield(param,'hSettings')
    if isfield(param.hSettings,'fig')
        if isgraphics(param.hSettings.fig)
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
tmp1 = 0.25;
tmp2 = 10/100;
tmp3 = 0.7;
%%
w_ctrl = param.tmp.w_ctrl_2;
h_p1 = param.tmp.h_p1;
h_p2 = param.tmp.h_p2;
w_axes = param.tmp.w_axes_2;
x_leftbottom = param.tmp.x_leftbottom_2;
y_leftbottom = param.tmp.y_leftbottom_2;
%%
hSettings.fig = figure('name','Settings','NumberTitle','off','Units','pixels','Position',[x_leftbottom y_leftbottom w_ctrl+w_axes h_p2+h_p2], 'MenuBar' , 'none' , 'ToolBar' , 'none','SizeChangedFcn',@SizeChangedFcn_Settings);
%% 1
hSettings.Text_scenes_process   = uicontrol('Parent',hSettings.fig,'Style', 'Text'     , 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[0*tmp1 1-1*tmp2 tmp1 tmp3*tmp2] , 'String', 'Scenes to be processed or visualized (all unless specified):');
hSettings.Edit_scenes_process   = uicontrol('Parent',hSettings.fig,'Style', 'Edit'     , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[1*tmp1 1-1*tmp2 tmp1 tmp2] , 'Callback',@CallbackSettings_Edit);%,'min',0,'max',300);
%% 2
hSettings.Text_parallel_setting = uicontrol('Parent',hSettings.fig,'Style', 'Text'     , 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[2*tmp1 1-1*tmp2 tmp1 tmp3*tmp2] , 'String', 'Number of processors to use:');
hSettings.Edit_parallel_setting = uicontrol('Parent',hSettings.fig,'Style', 'Edit'     , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[3*tmp1 1-1*tmp2 tmp1 tmp2] , 'Callback',@CallbackSettings_Edit);%,'min',0,'max',300);
%% 3
hSettings.Text_segmentation_max_depth   = uicontrol('Parent',hSettings.fig,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position', [0*tmp1 1-2*tmp2 tmp1 tmp3*tmp2] , 'String', 'Maximum number of objects to merge:' );
hSettings.Edit_segmentation_max_depth   = uicontrol('Parent',hSettings.fig,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position', [1*tmp1 1-2*tmp2 tmp1 tmp2] , 'Callback',@CallbackSettings_Edit);
%% 4
hSettings.Text_segmentation_max_runtime = uicontrol('Parent',hSettings.fig,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position', [2*tmp1 1-2*tmp2 tmp1 tmp3*tmp2] , 'String', 'Maximum time for a connected component:' );
hSettings.Edit_segmentation_max_runtime = uicontrol('Parent',hSettings.fig,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position', [3*tmp1 1-2*tmp2 tmp1 tmp2] , 'Callback',@CallbackSettings_Edit);
%% 5
hSettings.Text_tracking_max_deviation = uicontrol('Parent',hSettings.fig,'Style', 'Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position', [0*tmp1 1-3*tmp2 tmp1 tmp3*tmp2] , 'String', 'Maximum between-frame field shift:' );
hSettings.Edit_tracking_max_deviation = uicontrol('Parent',hSettings.fig,'Style', 'Edit', 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position', [1*tmp1 1-3*tmp2 tmp1 tmp2] , 'Callback',@CallbackSettings_Edit);
%% 6
hSettings.Text_segmentation_setting = uicontrol('Parent',hSettings.fig,'Style', 'Text'      , 'String', 'De-clumping and merging:'   , 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position', [0.00 1-4*tmp2 tmp1 tmp3*tmp2]);
hSettings.bg4 = uibuttongroup('Parent',hSettings.fig,'Visible','off','Units','normalized'                                                                                                      ,'Position', [tmp1 1-4*tmp2 1-tmp1 tmp2]);
hSettings.Radio41 = uicontrol(hSettings.bg4,'Style','radiobutton','String','Without de-clumping or merging'        , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.33 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio42 = uicontrol(hSettings.bg4,'Style','radiobutton','String','With de-clumping but without merging'  , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.33 0.00 0.33 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio43 = uicontrol(hSettings.bg4,'Style','radiobutton','String','With de-clumping and merging'          , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.66 0.00 0.33 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.bg4.Visible = 'on';
%% 7
hSettings.Text_feature_setting  = uicontrol('Parent',hSettings.fig,'Style', 'Text'     , 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[0.00      1-5*tmp2 tmp1 tmp3*tmp2] , 'String', 'Select features to calculate:');
hSettings.Check_feature_coo     = uicontrol('Parent',hSettings.fig,'Style', 'Checkbox' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[tmp1      1-5*tmp2 0.10 tmp2] , 'Visible','on', 'String', 'Coordinate'   ,'Callback',@CallbackSettings_Button);
hSettings.Check_feature_sha     = uicontrol('Parent',hSettings.fig,'Style', 'Checkbox' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[tmp1+0.10 1-5*tmp2 0.10 tmp2] , 'Visible','on', 'String', 'Shape'        ,'Callback',@CallbackSettings_Button);
hSettings.Check_feature_int     = uicontrol('Parent',hSettings.fig,'Style', 'Checkbox' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[tmp1+0.20 1-5*tmp2 0.10 tmp2] , 'Visible','on', 'String', 'Intensity'    ,'Callback',@CallbackSettings_Button);
hSettings.Check_feature_har     = uicontrol('Parent',hSettings.fig,'Style', 'Checkbox' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[tmp1+0.30 1-5*tmp2 0.10 tmp2] , 'Visible','on', 'String', 'Haralick'     ,'Callback',@CallbackSettings_Button);
hSettings.Check_feature_zer     = uicontrol('Parent',hSettings.fig,'Style', 'Checkbox' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[tmp1+0.40 1-5*tmp2 0.10 tmp2] , 'Visible','on', 'String', 'Zernike'      ,'Callback',@CallbackSettings_Button);
hSettings.Check_feature_add     = uicontrol('Parent',hSettings.fig,'Style', 'Checkbox' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[tmp1+0.50 1-5*tmp2 0.10 tmp2] , 'Visible','on', 'String', 'Additional'   ,'Callback',@CallbackSettings_Button);
%% 8
hSettings.Text_segmentation_gating = uicontrol('Parent',hSettings.fig,'Style', 'Text'      , 'String', 'Display of deleted objects in Segmentation Gating:'   , 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position', [0.00 1-6*tmp2 tmp1 tmp3*tmp2]);
hSettings.bg8 = uibuttongroup('Parent',hSettings.fig,'Visible','off','Units','normalized'                                                                                                      ,'Position', [tmp1 1-6*tmp2 1-tmp1 tmp2]);
hSettings.Radio81 = uicontrol(hSettings.bg8,'Style','radiobutton','String','Blue circles'  , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.33 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio82 = uicontrol(hSettings.bg8,'Style','radiobutton','String','Green dots'    , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.33 0.00 0.33 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio83 = uicontrol(hSettings.bg8,'Style','radiobutton','String','Hidden'        , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.66 0.00 0.33 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.bg8.Visible = 'on';
%% 9
hSettings.Text_update_options_1 = uicontrol(    'Parent',hSettings.fig,'Style','Text', 'FontWeight', fw2,  'Units','normalized', 'FontSize', fs1,'Position',[0.00 1-7*tmp2 tmp1 tmp3*tmp2],'String','After each manual correction of segmentation update:');
hSettings.bg5                   = uibuttongroup('Parent',hSettings.fig,'Visible','off'                  ,  'Units','normalized',                 'Position',[tmp1 1-7*tmp2 1-tmp1 tmp2]);
hSettings.Radio51 = uicontrol(hSettings.bg5,'Style','radiobutton','String','Only object labels'                           , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.50 0.50 0.50],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio52 = uicontrol(hSettings.bg5,'Style','radiobutton','String','Object labels and features'                   , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.50 0.50 0.50],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio53 = uicontrol(hSettings.bg5,'Style','radiobutton','String','Object labels, features and tracks'           , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.50 0.50],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio54 = uicontrol(hSettings.bg5,'Style','radiobutton','String','Object labels, features, tracks and lineages' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.50 0.50],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.bg5.Visible = 'on';
%% 10
hSettings.Text_update_options_2 = uicontrol('Parent',hSettings.fig,'Style','Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 1-8*tmp2 tmp1 tmp3*tmp2],'String','After each manual correction of tracking update:');
hSettings.bg6 = uibuttongroup('Parent',hSettings.fig,'Visible','off','Units','normalized'                                                  ,'Position',[tmp1 1-8*tmp2 1-tmp1 tmp2]);
hSettings.Radio61 = uicontrol(hSettings.bg6,'Style','radiobutton','String','Only tracks'         , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.50 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio62 = uicontrol(hSettings.bg6,'Style','radiobutton','String','Tracks and lineages' , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.50 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.bg6.Visible = 'on';
%% 11
hSettings.Text_split_options    = uicontrol('Parent',hSettings.fig,'Style','Text', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 1-9*tmp2 tmp1 tmp3*tmp2],'String','Object splitting option:');
hSettings.bg7 = uibuttongroup('Parent',hSettings.fig,'Visible','off','Units','normalized'                                                  ,'Position',[tmp1 1-9*tmp2 1-tmp1 tmp2]);
hSettings.Radio71 = uicontrol(hSettings.bg7,'Style','radiobutton','String','Large pieces'     , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 0.50 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.Radio72 = uicontrol(hSettings.bg7,'Style','radiobutton','String','Small pieces'     , 'FontWeight', fw1, 'Units','normalized', 'FontSize', fs1,'Position',[0.50 0.00 0.50 1.00],'HandleVisibility','off','Callback',@CallbackSettings_Button);
hSettings.bg7.Visible = 'on';
%%
hSettings.Butt_memory_2_harddisk = uicontrol('Parent',hSettings.fig,          'Style', 'push', 'FontWeight', fw2, 'Units','normalized', 'FontSize', fs1,'Position',[0.00 0.00 1.00 0.10]  , 'String', 'Save to project file'  , 'Callback', @save_settings);
%%
param.hSettings = hSettings;
InformAllInterfaces(param);
show_settings(param);
end
%%
