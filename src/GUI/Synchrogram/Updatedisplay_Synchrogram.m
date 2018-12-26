function [ I_montage , I_stack] = Updatedisplay_Synchrogram( param )
%%
directories_label_gray  = param.tmp.directories_label_gray;
%directories_label_color = param.tmp.directories_label_color;
%directories_label_info  = param.tmp.directories_label_info;
directories_label_data  = param.tmp.directories_label_data;
filenames_label_gray  = param.tmp.filenames_label_gray;
%filenames_label_color = param.tmp.filenames_label_color;
%filenames_label_info  = param.tmp.filenames_label_info;
filenames_label_data  = param.tmp.filenames_label_data;
%%
CurrentMin = round((get(param.hMain.SliderFrame3,'Value')));
CurrentMax = round((get(param.hMain.SliderFrame4,'Value')));
CurrentTransparency = round(1000*(get(param.hMain.SliderFrame5,'Value')))/1000;
RadioValue1 = get(param.hMain.Radio11, 'value');
RadioValue2 = get(param.hMain.Radio12, 'value');
RadioValue3 = get(param.hMain.Radio13, 'value');
%%
%%
if param.tmp.n_scene == 1
    s = param.tmp.min_scene;
else
    s = round((get(param.hMain.SliderFrame1,'Value')));
end
s_id = find(param.tmp.scenes_all == s);
%%
n = param.tmp.n_synchrogram_crop;
I = cell([n,1]);
I_stack = cell([n,1]);
ymin = NaN([n,1]);
ymax = NaN([n,1]);
xmin = NaN([n,1]);
xmax = NaN([n,1]);
h_ob = NaN([n,1]);
w_ob = NaN([n,1]);
%%
row = param.tmp.row_for_synchrogram;
col = param.tmp.col_for_synchrogram;
if param.tmp.filtered_lineage_tree(row,col) ~= 0
    id_highlight = find(find(param.tmp.filtered_lineage_tree(row,:)>0)==col);
else
    id_highlight = 0;
end
%%
list = find(param.tmp.filtered_lineage_tree(param.tmp.row_for_synchrogram,:)>0);
list_objects = [ param.tmp.frames_displayed(list) ; param.tmp.filtered_lineage_tree(param.tmp.row_for_synchrogram,list) ];
%%
for i = 1:n
    CurrentFrame = list_objects(1,i);
    str_dir = param.tmp.dir_nucleimarker;
    str_file = param.tmp.filenames_nucleimarker{s_id,CurrentFrame};
    if ~isempty(str_dir)
        if exist(str_dir,'dir') == 7
            temp = fullfile(str_dir , str_file);
            if exist(temp,'file') == 2
                I_raw = imread(temp);
            end
        end
    end
    label_image = get_label_image( directories_label_gray{s_id} , filenames_label_gray{s_id,CurrentFrame}  );
    label_data  = get_label_data(  directories_label_data{s_id} , filenames_label_data{s_id,CurrentFrame}  );
    %label_info  = get_label_info(  directories_label_info{s_id} , filenames_label_info{s_id,CurrentFrame}  );
    %%
    %%
    if isempty(I_raw) || (CurrentMin >= CurrentMax && RadioValue1 == 1)
        param.hSynchrogram.image = imshow([],'Parent',param.hSynchrogram.axes_montage );
        return;
    end
    %%
    if RadioValue1 == 1
        I_raw = imadjust(I_raw , [double(CurrentMin)/param.tmp.val_range;                          double(CurrentMax)/param.tmp.val_range], [double(param.tmp.val_min)/param.tmp.val_range; double(param.tmp.val_max)/param.tmp.val_range] );
    elseif RadioValue2 == 1
        I_raw = imadjust(I_raw , [double(my_quantile(I_raw(:),0.00))/param.tmp.val_range;  double(my_quantile(I_raw(:),1.00))/param.tmp.val_range], [double(param.tmp.val_min)/param.tmp.val_range; double(param.tmp.val_max)/param.tmp.val_range] );
    elseif RadioValue3 == 1
        I_raw = imadjust(I_raw , [double(my_quantile(I_raw(:),0.01))/param.tmp.val_range;  double(my_quantile(I_raw(:),0.99))/param.tmp.val_range], [double(param.tmp.val_min)/param.tmp.val_range; double(param.tmp.val_max)/param.tmp.val_range] );
    end
    I_RGB_layer1 = repmat(I_raw,[1 1 3]);
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
            for j = 1:length(borders)
                I_borders_normal(borders{j}) = true;
            end
            I_green_borders = uint8(zeros([param.tmp.h,param.tmp.w,1]));
            I_green_borders(I_borders_normal) = 255;
            I_RGB_layer2 = cat(3 , uint8(zeros([param.tmp.h,param.tmp.w,1])) , I_green_borders , uint8(zeros([param.tmp.h,param.tmp.w,1])));
        else
            I_RGB_layer2 = uint8(zeros([param.tmp.h,param.tmp.w,3]));
        end
    end
    I{i} = double(I_RGB_layer1)/double(intmax(class(I_RGB_layer1))) * (1 - 0*CurrentTransparency) + double(I_RGB_layer2)/double(intmax(class(I_RGB_layer2))) * (1 - 1*CurrentTransparency);
    I_stack{i} = I{i};
    %%
    lb = label_data.object_labels(list_objects(2,i));
    [ys,xs ] = image_id_2_xy(label_data.object_borders{lb} , param.tmp.h);
    ymin(i) = min(ys);
    ymax(i) = max(ys);
    xmin(i) = min(xs);
    xmax(i) = max(xs);
    h_ob(i) = ymax(i) - ymin(i) + 1;
    w_ob(i) = xmax(i) - xmin(i) + 1;
    %%
    if ~isempty(label_image) && id_highlight == i
        I{id_highlight}(:,:,1) = I{id_highlight}(:,:,1) + double(label_image == param.tmp.filtered_lineage_tree(row,col));
    end
end
%%
%%
r = max(max(h_ob), max(w_ob));
d_crop = param.tmp.d_synchrogram_crop;
I_montage = ones([r,n*(r+d_crop),3]);
for i = 1:n
    y_d = r - h_ob(i);
    x_d = r - w_ob(i);
    y_range = max(1,ymin(i)-round(y_d/2)):min(param.tmp.h,ymax(i)+y_d-round(y_d/2));
    x_range = max(1,xmin(i)-round(x_d/2)):min(param.tmp.w,xmax(i)+x_d-round(x_d/2));
    I_montage(1:length(y_range),1+(i-1)*(r+d_crop):(i-1)*(r+d_crop)+length(x_range),:) = I{i}(y_range,x_range,:);
    I_stack{i} = I_stack{i}(y_range,x_range,:);
end
end