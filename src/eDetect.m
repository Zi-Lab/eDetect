function eDetect
addpath(genpath('Functions'));
addpath(genpath('GUI'));
addpath(genpath('Resources'));
warning('off','all');
%%
try
   tmp = ver('images');
catch
   msgbox('Image Processing Toolbox is not installed. eDetect cannot run.','Error','error');
   return;
end
%%
param1 = InitializeProject;
param2 = InitializeSettings;
param3 = InitializeVariables;
param = param1;
param.set = param2.set;
param.tmp = param3.tmp;
w_ctrl = param.tmp.w_ctrl_1;
h_p4 = param.tmp.h_p4;
h_p3 = param.tmp.h_p3;
w_axes = param.tmp.w_axes_1;
x_leftbottom = param.tmp.x_leftbottom_1;
y_leftbottom = param.tmp.y_leftbottom_1;
%%
img_new_project  = imread('new.tif');
img_new_project  = double(img_new_project(:,:,1:3)) / 255;
img_load_project = imread('load.tif');
img_load_project = double(img_load_project(:,:,1:3)) / 255;
img_parameters   = imread('parameters.tif');
img_parameters   = double(img_parameters(:,:,1:3)) / 255;
img_settings     = imread('settings.tif');
img_settings     = double(img_settings(:,:,1:3)) / 255;
%%
img_change_channel   = imread('change_channel.tif');
img_change_channel   = double(img_change_channel(:,:,1:3)) / 255;
img_change_overlay   = imread('change_overlay.tif');
img_change_overlay   = double(img_change_overlay(:,:,1:3)) / 255;
img_measure_distance = imread('measure_distance.tif');
img_measure_distance = double(img_measure_distance(:,:,1:3)) / 255;
img_draw_polygon     = imread('draw_polygon.tif');
img_draw_polygon     = double(img_draw_polygon(:,:,1:3)) / 255;
img_deselect_all     = imread('deselect_all.tif');
img_deselect_all     = double(img_deselect_all(:,:,1:3)) / 255;
img_delete_objects   = imread('delete_objects.tif');
img_delete_objects   = double(img_delete_objects(:,:,1:3)) / 255;
img_recover_objects  = imread('recover_objects.tif');
img_recover_objects  = double(img_recover_objects(:,:,1:3)) / 255;
img_split_objects    = imread('split_objects.tif');
img_split_objects    = double(img_split_objects(:,:,1:3)) / 255;
img_merge_objects    = imread('merge_objects.tif');
img_merge_objects    = double(img_merge_objects(:,:,1:3)) / 255;
img_get_predecessor  = imread('get_predecessor.tif');
img_get_predecessor  = double(img_get_predecessor(:,:,1:3)) / 255;
img_set_predecessor  = imread('set_predecessor.tif');
img_set_predecessor  = double(img_set_predecessor(:,:,1:3)) / 255;
%%
img_cell_segmentation  = imread('cellsegmentation.tif');
img_cell_segmentation  = double(img_cell_segmentation(:,:,1:3)) / 255;
img_feature_extraction = imread('featureextraction.tif');
img_feature_extraction = double(img_feature_extraction(:,:,1:3)) / 255;
img_cell_tracking      = imread('celltracking.tif');
img_cell_tracking      = double(img_cell_tracking(:,:,1:3)) / 255;
img_cell_lineage_reconstruction = imread('celllineagereconstruction.tif');
img_cell_lineage_reconstruction = double(img_cell_lineage_reconstruction(:,:,1:3)) / 255;
img_measurement = imread('measurement.tif');
img_measurement = double(img_measurement(:,:,1:3)) / 255;
%%
img_segmentation_gating   = imread('segmentationgating.tif');
img_segmentation_gating   = double(img_segmentation_gating(:,:,1:3)) / 255;
img_cell_pair_gating      = imread('cellpairgating.tif');
img_cell_pair_gating      = double(img_cell_pair_gating(:,:,1:3)) / 255;
img_cell_lineages_display = imread('celllineagesdisplay.tif');
img_cell_lineages_display = double(img_cell_lineages_display(:,:,1:3)) / 255;
%%
%%
hMain.fig = figure('name','eDetect','NumberTitle','off','Units','pixels','Position',[x_leftbottom y_leftbottom w_ctrl+w_axes h_p4+h_p3] , 'MenuBar' , 'none' , 'ToolBar' , 'none' ,'DockControls', 'off','SizeChangedFcn',@SizeChangedFcn_ImageDisplay,'CloseRequestFcn',@CloseAllInterfaces);
hMain.axes1 = axes('Parent',hMain.fig,'Units','pixels','Position',[w_ctrl+1 1 w_axes h_p4+h_p3],'xtick',[],'ytick',[]);
hMain.toolbar_manual_correction = uitoolbar(hMain.fig);
hMain.toolbar_pipeline  = uitoolbar(hMain.fig);
%%
hMain.pushtool_new_project       = uipushtool(  hMain.toolbar_manual_correction,'CData',img_new_project  , 'TooltipString','New project'  , 'Separator' , 'off' , 'Enable', 'on'  ,'ClickedCallback',@NewProject);
hMain.pushtool_load_project      = uipushtool(  hMain.toolbar_manual_correction,'CData',img_load_project , 'TooltipString','Load project' , 'Separator' , 'off' , 'Enable', 'on'  ,'ClickedCallback',@LoadProject);
hMain.pushtool_parameters        = uipushtool(  hMain.toolbar_manual_correction,'CData',img_parameters   , 'TooltipString','Parameters'   , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@Parameters);
hMain.pushtool_settings          = uipushtool(  hMain.toolbar_manual_correction,'CData',img_settings     , 'TooltipString','Settings'     , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@Settings);
%%
hMain.toggletool_channel         = uitoggletool(hMain.toolbar_manual_correction,'CData',img_change_channel   , 'TooltipString','Change channel'     , 'Separator' , 'on'  , 'Enable', 'off' ,'ClickedCallback',@CallbackToggleChannel);
hMain.toggletool_overlay         = uitoggletool(hMain.toolbar_manual_correction,'CData',img_change_overlay   , 'TooltipString','Change overlay'     , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@CallbackToggleOverlay);
hMain.pushtool_measure_distance  = uipushtool(  hMain.toolbar_manual_correction,'CData',img_measure_distance , 'TooltipString','Measure distance'   , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@MeasureDistance);
hMain.pushtool_draw_polygon      = uipushtool(  hMain.toolbar_manual_correction,'CData',img_draw_polygon     , 'TooltipString','Draw a polygon'     , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@ImageDrawPolygon);
hMain.pushtool_deselect_all      = uipushtool(  hMain.toolbar_manual_correction,'CData',img_deselect_all     , 'TooltipString','Deselect all'       , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@EditDeselect);
hMain.pushtool_delete_objects    = uipushtool(  hMain.toolbar_manual_correction,'CData',img_delete_objects   , 'TooltipString','Delete objects'     , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@EditObjects);
hMain.pushtool_recover_objects   = uipushtool(  hMain.toolbar_manual_correction,'CData',img_recover_objects  , 'TooltipString','Recover objects'    , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@EditObjects);
hMain.pushtool_split_objects     = uipushtool(  hMain.toolbar_manual_correction,'CData',img_split_objects    , 'TooltipString','Split objects'      , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@EditObjects);
hMain.pushtool_merge_objects     = uipushtool(  hMain.toolbar_manual_correction,'CData',img_merge_objects    , 'TooltipString','Merge objects'      , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@EditObjects);
hMain.pushtool_get_parent        = uipushtool(  hMain.toolbar_manual_correction,'CData',img_get_predecessor  , 'TooltipString','Get predecessor'    , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@EditPredecessorGet);
hMain.pushtool_set_parent        = uipushtool(  hMain.toolbar_manual_correction,'CData',img_set_predecessor  , 'TooltipString','Set predecessor'    , 'Separator' , 'off' , 'Enable', 'off' ,'ClickedCallback',@EditPredecessorSet);
%%
hMain.pushtool_cellsegmentation           = uipushtool(hMain.toolbar_pipeline,'CData',img_cell_segmentation            , 'TooltipString','Cell segmentation'             , 'Separator' , 'off' , 'Enable', 'off'   ,'ClickedCallback',@CellSegmentation);
hMain.pushtool_featureextraction          = uipushtool(hMain.toolbar_pipeline,'CData',img_feature_extraction           , 'TooltipString','Feature extraction'            , 'Separator' , 'off' , 'Enable', 'off'   ,'ClickedCallback',@FeatureExtraction);
hMain.pushtool_celltracking               = uipushtool(hMain.toolbar_pipeline,'CData',img_cell_tracking                , 'TooltipString','Cell tracking'                 , 'Separator' , 'off' , 'Enable', 'off'   ,'ClickedCallback',@CellTracking);
hMain.pushtool_celllineagereconstruction  = uipushtool(hMain.toolbar_pipeline,'CData',img_cell_lineage_reconstruction  , 'TooltipString','Cell lineage reconstruction'   , 'Separator' , 'off' , 'Enable', 'off'   ,'ClickedCallback',@CellLineageReconstruction);
hMain.pushtool_measurement                = uipushtool(hMain.toolbar_pipeline,'CData',img_measurement                  , 'TooltipString','Measurement'                   , 'Separator' , 'off' , 'Enable', 'off'   ,'ClickedCallback',@Measurement);
%%
hMain.pushtool_segmentationgating         = uipushtool(hMain.toolbar_pipeline,'CData',img_segmentation_gating          , 'TooltipString','Segmentation gating'           , 'Separator' , 'on'  , 'Enable', 'off'   ,'ClickedCallback',@SegmentationGating);
hMain.pushtool_cellpairgating             = uipushtool(hMain.toolbar_pipeline,'CData',img_cell_pair_gating             , 'TooltipString','Cell pair gating'              , 'Separator' , 'off' , 'Enable', 'off'   ,'ClickedCallback',@CellPairGating);
hMain.pushtool_celllineagesdisplay        = uipushtool(hMain.toolbar_pipeline,'CData',img_cell_lineages_display        , 'TooltipString','Cell lineages display'         , 'Separator' , 'off' , 'Enable', 'off'   ,'ClickedCallback',@CellLineagesDisplay);
%%
param.hMain = hMain;
guidata(hMain.fig,param);
end