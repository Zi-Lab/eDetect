function param = Updatedisplay_Image_0(param)
if ~isfield(param.tmp,'n_scene')
    return;
elseif isempty(param.tmp.n_scene)
    return;
end
%%
if param.tmp.n_scene == 1
    CurrentScene = param.tmp.min_scene;
else
    CurrentScene = round((get(param.hMain.SliderFrame1,'Value')));
end
set(param.hMain.Edit1,'String',num2str(CurrentScene));
%%
if param.tmp.n_time == 1
    CurrentFrame = param.tmp.min_time;
else
    CurrentFrame = round((get(param.hMain.SliderFrame2,'Value')));
end
set(param.hMain.Edit2,'String',num2str(CurrentFrame));
%%
RadioValue1 = get(param.hMain.Radio11, 'value');
RadioValue2 = get(param.hMain.Radio12, 'value');
RadioValue3 = get(param.hMain.Radio13, 'value');
if RadioValue1 == 1
    param.hMain.Text3.Visible = 'on';
    param.hMain.Edit3.Visible = 'on';
    param.hMain.SliderFrame3.Visible = 'on';
    param.hMain.Text4.Visible = 'on';
    param.hMain.Edit4.Visible = 'on';
    param.hMain.SliderFrame4.Visible = 'on';
else
    param.hMain.Text3.Visible = 'off';
    param.hMain.Edit3.Visible = 'off';
    param.hMain.SliderFrame3.Visible = 'off';
    param.hMain.Text4.Visible = 'off';
    param.hMain.Edit4.Visible = 'off';
    param.hMain.SliderFrame4.Visible = 'off';
end
if RadioValue1 == 1
    CurrentMin = round((get(param.hMain.SliderFrame3,'Value')));
    CurrentMax = round((get(param.hMain.SliderFrame4,'Value')));
elseif RadioValue2 == 1
    CurrentMin = double(my_quantile(param.tmp.I(:),0.00));
    CurrentMax = double(my_quantile(param.tmp.I(:),1.00));
elseif RadioValue3 == 1
    CurrentMin = double(my_quantile(param.tmp.I(:),0.01));
    CurrentMax = double(my_quantile(param.tmp.I(:),0.99));
end
set(param.hMain.Edit3,'String',num2str(CurrentMin));
set(param.hMain.Edit4,'String',num2str(CurrentMax));
set(param.hMain.SliderFrame3,'Value',CurrentMin);
set(param.hMain.SliderFrame4,'Value',CurrentMax);
%%
if isempty(param.tmp.I) || (CurrentMin >= CurrentMax && RadioValue1 == 1)
    param.hMain.Image = imshow([],'Parent',param.hMain.axes1);
    return;
end
if size(param.tmp.I,3) > 1
    msgbox('Input images are not grayscale.','Error','error');
    param.hMain.Image = imshow([],'Parent',param.hMain.axes1);
    return;
end
%%
I_tmp = imadjust(param.tmp.I , [double(CurrentMin)/param.tmp.val_range; double(CurrentMax)/param.tmp.val_range], [double(param.tmp.val_min)/param.tmp.val_range; double(param.tmp.val_max)/param.tmp.val_range] );
I_RGB_layer1 = repmat(I_tmp,[1 1 3]);
label_image = param.tmp.manual_label_image;
label_data  = param.tmp.manual_label_data;
label_info  = param.tmp.manual_label_info;
if     strcmp( get(param.hMain.toggletool_overlay,'State') , 'on' )
    if ~isempty(label_image)
        I_RGB_layer2 = label2text(label_image,'black');
    else
        I_RGB_layer2 = uint8(zeros([param.tmp.h,param.tmp.w,3]));
    end
elseif strcmp( get(param.hMain.toggletool_overlay,'State') , 'off')
    if ~isempty(label_data)
        borders = label_data.object_borders;
        I_borders_normal = false([param.tmp.h,param.tmp.w]);
        I_borders_deleted = false([param.tmp.h,param.tmp.w]);
        for i = 1:length(borders)
            if ismember(i,label_info.erroneous)
                I_borders_deleted(borders{i}) = true;
            else
                I_borders_normal(borders{i}) = true;
            end
        end
        I_red_borders = uint8(zeros([param.tmp.h,param.tmp.w,1]));
        I_red_borders(I_borders_deleted) = 255;
        I_green_borders = uint8(zeros([param.tmp.h,param.tmp.w,1]));
        I_green_borders(I_borders_normal) = 255;
        I_RGB_layer2 = cat(3,I_red_borders,I_green_borders,uint8(zeros([param.tmp.h,param.tmp.w,1])));
    else
        I_RGB_layer2 = uint8(zeros([param.tmp.h,param.tmp.w,3]));
    end
end
%%
CurrentTransparency = round(1000*(get(param.hMain.SliderFrame5,'Value')))/1000;
set(param.hMain.Edit5,'String',num2str(CurrentTransparency));
I_RGB_final = double(I_RGB_layer1)/double(intmax(class(I_RGB_layer1))) * (1 - 0*CurrentTransparency) + double(I_RGB_layer2)/double(intmax(class(I_RGB_layer2))) * (1 - 1*CurrentTransparency);
%%
%%
if ~isempty(label_image) && ~isempty(param.tmp.manual_list_selected_objects)
    ids = ismember(label_image,param.tmp.manual_list_selected_objects);
    temp = I_RGB_final(:,:,1);
    temp(ids) = 1;
    I_RGB_final(:,:,1) = temp;
end
%%
cla(param.hMain.axes1,'reset');
param.hMain.Image = imshow(I_RGB_final,'Parent',param.hMain.axes1);
set(param.hMain.Image,'ButtonDownFcn',@CallbackMouseClickOnImage,'HitTest','on');
end