function CallbackMouseClickOnImage(h,~)
param = guidata(h);
%%
directories_label_gray  = param.tmp.directories_label_gray;
filenames_label_gray  = param.tmp.filenames_label_gray;
%%
if param.tmp.n_scene == 1
    CurrentScene = param.tmp.min_scene;
else
    CurrentScene = round((get(param.hMain.SliderFrame1,'Value')));
end
if param.tmp.n_time == 1
    CurrentFrame = param.tmp.min_time;
else
    CurrentFrame = round((get(param.hMain.SliderFrame2,'Value')));
end
coordinates  = get(param.hMain.axes1,'CurrentPoint'); 
x = round(coordinates(1,1));
y = round(coordinates(1,2));
if x < 1 || x > param.tmp.w || y < 1 || y > param.tmp.h
    return;
end
s = CurrentScene;
s_id = find(param.tmp.scenes_all == s);
[ label_gray] = get_label_image(directories_label_gray{s_id} , filenames_label_gray{s_id,CurrentFrame});
if ~isempty(label_gray)
    if label_gray(y,x) > 0
        m_type = get(param.hMain.fig, 'selectionType');
        if strcmp(m_type, 'normal')
            param.tmp.manual_list_selected_objects = union(    param.tmp.manual_list_selected_objects , label_gray(y,x) );
        elseif strcmp(m_type, 'alt')
            param.tmp.manual_list_selected_objects = setdiff(  param.tmp.manual_list_selected_objects , label_gray(y,x) );
        elseif strcmp(m_type, 'open')

        end            
    end
end

%%
param.tmp.manual_list_selected_scene_frame = [CurrentScene CurrentFrame];
param.tmp.manual_list_selected_objects;
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isgraphics(param.hNucleiSegmentationGating.fig)
            param = Updatedisplay_Segmentationgating_00(param);
        end
    end
end
%%
param = Updatedisplay_Image_0(param);
InformAllInterfaces(param);
end