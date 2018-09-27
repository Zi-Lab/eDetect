function save_project(h,~)
param = guidata(h);
param_ = param;
param1 = InitializeProject;
param2 = InitializeSettings;
param3 = InitializeVariables;
param_.dir = param1.dir;
param_.met = param1.met;
param_.seg = param1.seg;
param_.tra = param1.tra;
param_.exp = param1.exp;
param_.set = param2.set;
param_.tmp = param3.tmp;
%%
%%
%% directories
param_.dir.path_projectfile      = get(param.hNewProject.Edit_set_project,'String');
param_.dir.dir_nucleimarker      = get(param.hNewProject.Edit_set_dir_nuc_raw,'String');
param_.dir.dir_proteinofinterest = get(param.hNewProject.Edit_set_dir_int_raw,'String');
if isempty(param_.dir.path_projectfile)
    msgbox('Project file path is not specified.','Error','error');
    return;
end
if isempty(param_.dir.dir_nucleimarker)
    msgbox('Channel 1: nuclei marker folder is not specified.','Error','error');
    return;
end
[C,~] = strsplit(param_.dir.dir_nucleimarker,{'/','\'});
if isempty(C{end})
    prefix = param_.dir.dir_nucleimarker(1:end-1-length(C{end-1}));
else
    prefix = param_.dir.dir_nucleimarker(1:end-length(C{end}));
end
%%
temp0 = strsplit(param_.dir.path_projectfile,{'\','/'});
temp1 = strsplit(temp0{end},'.');
param_.dir.dir_label_nuclei      = fullfile(prefix,[temp1{1} filesep 'labels_objects'    ]);
param_.dir.dir_label_measurement = fullfile(prefix,[temp1{1} filesep 'labels_measurement']);
param_.dir.dir_feature           = fullfile(prefix,[temp1{1} filesep 'features'          ]);
param_.dir.dir_lineage           = fullfile(prefix,[temp1{1} filesep 'lineages'          ]);
param_.dir.dir_measurement       = fullfile(prefix,[temp1{1} filesep 'measurements'      ]);
%%
p1 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_label_nuclei);
p2 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_label_measurement);
p3 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_feature);
p4 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_lineage);
p5 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_measurement);
%
if (exist(p1,'dir') - 7) * (exist(p2,'dir') - 7) * (exist(p3,'dir') - 7) * (exist(p4,'dir') - 7) * (exist(p5,'dir') - 7) == 0
    i = 0;
    while (exist([p1 num2str(i)],'dir') - 7) * (exist([p2 num2str(i)],'dir') - 7) * (exist([p3 num2str(i)],'dir') - 7) * (exist([p4 num2str(i)],'dir') - 7) * (exist([p5 num2str(i)],'dir') - 7) == 0
        i = i + 1;
    end
    param_.dir.dir_label_nuclei      = [param_.dir.dir_label_nuclei       num2str(i)];
    param_.dir.dir_label_measurement = [param_.dir.dir_label_measurement  num2str(i)];
    param_.dir.dir_feature           = [param_.dir.dir_feature            num2str(i)];
    param_.dir.dir_lineage           = [param_.dir.dir_lineage            num2str(i)];
    param_.dir.dir_measurement       = [param_.dir.dir_measurement        num2str(i)];
end
%%
%%
%% filenames
str_nuc = get(param.hNewProject.Edit_param_nuc_fil,'string');
str_pro = get(param.hNewProject.Edit_param_int_fil,'string');
str_min_scene = get(param.hNewProject.Edit_param_sce_min, 'String');
str_max_scene = get(param.hNewProject.Edit_param_sce_max, 'String');
str_min_frame = get(param.hNewProject.Edit_param_fra_min, 'String');
str_max_frame = get(param.hNewProject.Edit_param_fra_max, 'String');
flag = check_filename_format(str_nuc , str_pro , str_min_scene , str_max_scene , str_min_frame , str_max_frame);
if ~flag
    return;
end
param_.met.filename_format_nucleimarker      = str_nuc;
param_.met.filename_format_proteinofinterest = str_pro;
param_.met.min_scene = str_min_scene;
param_.met.max_scene = str_max_scene;
param_.met.min_time  = str_min_frame;
param_.met.max_time  = str_max_frame;
%%
str = 'Please check again the directories, filenames and files.';
%% generate filenames
try
    param_ = GenerateFilenames(param_);
catch
    msgbox(str,'Error','error');
    return;
end
%% check input images
try
    if ~isempty(param_.dir.dir_nucleimarker)
        hMsg1 = msgbox('Checking Channel 1 files ...','Information','help');
        flag_nm = CheckInputImages(param_.tmp.dir_nucleimarker      , param_.tmp.filenames_nucleimarker     , param_.tmp.scenes_all , param_.set.processing_scenes , param_.tmp.n_time , true );
        close(hMsg1);
        if ~flag_nm
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest)
        hMsg2 = msgbox('Checking Channel 2 files ...','Information','help');
        flag_pi = CheckInputImages(param_.tmp.dir_proteinofinterest , param_.tmp.filenames_proteinofinterest, param_.tmp.scenes_all , param_.set.processing_scenes , param_.tmp.n_time , true );
        close(hMsg2);
        if ~flag_pi
            msgbox(str,'Error','error');
            return;
        end
    end
catch
    msgbox(str,'Error','error');
    return;
end
%% display example image and other panels
try
    param_ = DisplayImage(param_);
catch
    msgbox(str,'Error','error');
    return;
end
%% image not displayed successfully
if isfield(param_.hMain,'Image')
    if isempty(param_.hMain.Image.CData)
        return;
    end
end
%% save project to file
if ischar([param_.dir.path_projectfile])
    try
        param__.dir = param_.dir;
        param__.met = param_.met;
        param__.seg = param_.seg;
        param__.tra = param_.tra;
        param__.exp = param_.exp;
        param__.set = param_.set;
        savefile( param__ , 'param' , [param__.dir.path_projectfile]  );
        msgbox('Project saved','Information','help');
    catch
        msgbox('Project not saved','Error','error');
        return;
    end
end
%%
param_ = CheckStatus( param_ );
InformAllInterfaces(param_);
CloseAllInterfacesButMain(param_);
end