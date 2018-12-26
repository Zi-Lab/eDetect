function param = Synchrogram(param)
if isfield(param,'hSynchrogram')
    if isfield(param.hSynchrogram,'fig')
        if isgraphics(param.hSynchrogram.fig)
            close(param.hSynchrogram.fig);
        end
    end
end
w_ctrl_1 = param.tmp.w_ctrl_1;
w_axes_1 = param.tmp.w_axes_1;
x_leftbottom_1 = param.tmp.x_leftbottom_1;
y_leftbottom_1 = param.tmp.y_leftbottom_1;
h_slider = param.tmp.h_synchrogram_slider;
%%
list = find(param.tmp.filtered_lineage_tree(param.tmp.row_for_synchrogram,:)>0);
n = length(list);
param.tmp.n_synchrogram_crop = n;
hMsg = msgbox('Generating synchrogram...','Information','help');
[ I , I_stack ] = Updatedisplay_Synchrogram( param );
close(hMsg);
param.tmp.I_synchrogram_stack = I_stack;
h_crop = size(I,1);
param.tmp.r_synchrogram_crop = h_crop;
param.tmp.h_synchrogram_crop = h_crop;
d_crop = param.tmp.d_synchrogram_crop;
%%
hSynchrogram.fig = figure('name','Synchrogram','NumberTitle','off','Units','pixels','Position',[x_leftbottom_1 y_leftbottom_1 w_ctrl_1+w_axes_1 h_crop+h_slider], 'MenuBar' , 'none' , 'ToolBar' , 'figure','DockControls', 'off','SizeChangedFcn',@SizeChangedFcn_Synchrogram);
hSynchrogram.panel_synchrogram = uipanel('Parent',hSynchrogram.fig,'Units','pixels','Position',[1 h_slider+1 w_ctrl_1+w_axes_1 h_crop] );
hSynchrogram.SliderFrame       = uicontrol('Parent',hSynchrogram.fig,'Style','slider','Units','pixels','Position',[1 1 w_ctrl_1+w_axes_1 h_slider],  'Min',0,'Max',1,'Value',0,'SliderStep',[1/100 2/100],'Callback',@CallbackSliderSynchrogram);
hSynchrogram.axes_montage      = axes('Parent',hSynchrogram.panel_synchrogram,'Units','pixels','Position',[1 1 (h_crop+d_crop)*n h_crop],'xtick',[],'ytick',[]);
%%
temp1 = findall(hSynchrogram.fig);
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
temp2 = findall(hSynchrogram.fig,'tag','FigureToolBar');
img_export_video = imread('export_video.tif');
img_export_video = double(img_export_video(:,:,1:3)) / 255;
hSynchrogram.pushtool_exportvideo = uipushtool(  temp2,'CData',img_export_video    ,'TooltipString','Export video'    , 'Separator' , 'on' ,'ClickedCallback',@export_crop_video);
%%
param.hSynchrogram = hSynchrogram;
cla(param.hSynchrogram.axes_montage,'reset');
param.hSynchrogram.image = imshow(I,'Parent',param.hSynchrogram.axes_montage );
set(param.hSynchrogram.image,'ButtonDownFcn',@CallbackMouseClickOnSynchrogram,'HitTest','on');
end

