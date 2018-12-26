function param = Updatedisplay_Image_1(param)
if ~isfield(param.tmp,'n_scene')
    return;
elseif isempty(param.tmp.n_scene)
    return;
end
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
%%
s = CurrentScene;
s_id = find(param.tmp.scenes_all == s);
%%
c = get(param.hMain.Drop_channel,'Value');
switch c
    case 1
        str_dir = param.tmp.dir_nucleimarker;
        str_file = param.tmp.filenames_nucleimarker{s_id,CurrentFrame};
    case 2
        if size(param.tmp.filenames_proteinofinterest1,1) < s_id || size(param.tmp.filenames_proteinofinterest1,2) < CurrentFrame
            str_dir = [];
            str_file = [];
        else
            str_dir = param.tmp.dir_proteinofinterest1;
            str_file = param.tmp.filenames_proteinofinterest1{s_id,CurrentFrame};
        end
    case 3
        if size(param.tmp.filenames_proteinofinterest2,1) < s_id || size(param.tmp.filenames_proteinofinterest2,2) < CurrentFrame
            str_dir = [];
            str_file = [];
        else
            str_dir = param.tmp.dir_proteinofinterest2;
            str_file = param.tmp.filenames_proteinofinterest2{s_id,CurrentFrame};
        end
    case 4
        if size(param.tmp.filenames_proteinofinterest3,1) < s_id || size(param.tmp.filenames_proteinofinterest3,2) < CurrentFrame
            str_dir = [];
            str_file = [];
        else
            str_dir = param.tmp.dir_proteinofinterest3;
            str_file = param.tmp.filenames_proteinofinterest3{s_id,CurrentFrame};
        end
    case 5
        if size(param.tmp.filenames_proteinofinterest4,1) < s_id || size(param.tmp.filenames_proteinofinterest4,2) < CurrentFrame
            str_dir = [];
            str_file = [];
        else
            str_dir = param.tmp.dir_proteinofinterest4;
            str_file = param.tmp.filenames_proteinofinterest4{s_id,CurrentFrame};
        end
    otherwise
        str_dir = [];
        str_file = [];
end
%%
param.tmp.I = [];
if ~isempty(str_dir)
    if exist(str_dir,'dir') == 7
        temp = fullfile(str_dir , str_file);
        if exist(temp,'file') == 2
            param.tmp.I = imread(temp);
            param.tmp.h = size(param.tmp.I,1);
            param.tmp.w = size(param.tmp.I,2);
        end
    end
end
%%
directories_label_gray  = param.tmp.directories_label_gray;
%directories_label_color = param.tmp.directories_label_color;
directories_label_info  = param.tmp.directories_label_info;
directories_label_data  = param.tmp.directories_label_data;
filenames_label_gray  = param.tmp.filenames_label_gray;
%filenames_label_color = param.tmp.filenames_label_color;
filenames_label_info  = param.tmp.filenames_label_info;
filenames_label_data  = param.tmp.filenames_label_data;
%%
[param.tmp.manual_label_image] = get_label_image( directories_label_gray{s_id} , filenames_label_gray{s_id,CurrentFrame}  );
[param.tmp.manual_label_data]  = get_label_data(  directories_label_data{s_id} , filenames_label_data{s_id,CurrentFrame}  );
[param.tmp.manual_label_info]  = get_label_info(  directories_label_info{s_id} , filenames_label_info{s_id,CurrentFrame}  );
param = Updatedisplay_Image_0(param);
end