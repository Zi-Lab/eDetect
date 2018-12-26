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
param_.dir.path_projectfile       = get(param.hNewProject.Edit_set_project,'String');
param_.dir.dir_nucleimarker       = get(param.hNewProject.Edit_set_dir_nuc,'String');
param_.dir.dir_proteinofinterest1 = get(param.hNewProject.Edit_set_dir_int1,'String');
param_.dir.dir_proteinofinterest2 = get(param.hNewProject.Edit_set_dir_int2,'String');
param_.dir.dir_proteinofinterest3 = get(param.hNewProject.Edit_set_dir_int3,'String');
param_.dir.dir_proteinofinterest4 = get(param.hNewProject.Edit_set_dir_int4,'String');
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
param_.dir.dir_measurement1      = fullfile(prefix,[temp1{1} filesep 'measurements1'     ]);
param_.dir.dir_measurement2      = fullfile(prefix,[temp1{1} filesep 'measurements2'     ]);
param_.dir.dir_measurement3      = fullfile(prefix,[temp1{1} filesep 'measurements3'     ]);
param_.dir.dir_measurement4      = fullfile(prefix,[temp1{1} filesep 'measurements4'     ]);
%%
p1 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_label_nuclei);
p2 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_label_measurement);
p3 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_feature);
p4 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_lineage);
p51 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_measurement1);
p52 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_measurement2);
p53 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_measurement3);
p54 = absolutepath(param_.dir.path_projectfile,param_.dir.dir_measurement4);
%
if (exist(p1,'dir') - 7) * (exist(p2,'dir') - 7) * (exist(p3,'dir') - 7) * (exist(p4,'dir') - 7) * (exist(p51,'dir') - 7) * (exist(p52,'dir') - 7) * (exist(p53,'dir') - 7) * (exist(p54,'dir') - 7) == 0
    i = 0;
    while (exist([p1 num2str(i)],'dir') - 7) * (exist([p2 num2str(i)],'dir') - 7) * (exist([p3 num2str(i)],'dir') - 7) * (exist([p4 num2str(i)],'dir') - 7) * (exist([p51 num2str(i)],'dir') - 7) * (exist([p52 num2str(i)],'dir') - 7) * (exist([p53 num2str(i)],'dir') - 7) * (exist([p54 num2str(i)],'dir') - 7) == 0
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
str_nuc  = get(param.hNewProject.Edit_param_nuc_fil,'string');
str_pro1 = get(param.hNewProject.Edit_param_int_fil1,'string');
str_pro2 = get(param.hNewProject.Edit_param_int_fil2,'string');
str_pro3 = get(param.hNewProject.Edit_param_int_fil3,'string');
str_pro4 = get(param.hNewProject.Edit_param_int_fil4,'string');
str_min_scene = get(param.hNewProject.Edit_param_sce_min, 'String');
str_max_scene = get(param.hNewProject.Edit_param_sce_max, 'String');
str_min_frame = get(param.hNewProject.Edit_param_fra_min, 'String');
str_max_frame = get(param.hNewProject.Edit_param_fra_max, 'String');
flag = check_filename_format(str_nuc , str_pro1 , str_pro2 , str_pro3 , str_pro4 , str_min_scene , str_max_scene , str_min_frame , str_max_frame);
if ~flag
    return;
end
param_.met.filename_format_nucleimarker      = str_nuc;
param_.met.filename_format_proteinofinterest1 = str_pro1;
param_.met.filename_format_proteinofinterest2 = str_pro2;
param_.met.filename_format_proteinofinterest3 = str_pro3;
param_.met.filename_format_proteinofinterest4 = str_pro4;
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
        flag_nm = CheckInputImages(param_.tmp.dir_nucleimarker      , param_.tmp.filenames_nucleimarker     , param_.tmp.scenes_all , param_.tmp.n_time , true );
        close(hMsg1);
        if ~flag_nm
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest1)
        hMsg2 = msgbox('Checking Channel 2 files ...','Information','help');
        flag_pi1 = CheckInputImages(param_.tmp.dir_proteinofinterest1 , param_.tmp.filenames_proteinofinterest1, param_.tmp.scenes_all , param_.tmp.n_time , true );
        close(hMsg2);
        if ~flag_pi1
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest2)
        hMsg3 = msgbox('Checking Channel 3 files ...','Information','help');
        flag_pi2 = CheckInputImages(param_.tmp.dir_proteinofinterest2 , param_.tmp.filenames_proteinofinterest2, param_.tmp.scenes_all , param_.tmp.n_time , true );
        close(hMsg3);
        if ~flag_pi2
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest3)
        hMsg4 = msgbox('Checking Channel 4 files ...','Information','help');
        flag_pi3 = CheckInputImages(param_.tmp.dir_proteinofinterest3 , param_.tmp.filenames_proteinofinterest3, param_.tmp.scenes_all , param_.tmp.n_time , true );
        close(hMsg4);
        if ~flag_pi3
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest4)
        hMsg5 = msgbox('Checking Channel 5 files ...','Information','help');
        flag_pi4 = CheckInputImages(param_.tmp.dir_proteinofinterest4 , param_.tmp.filenames_proteinofinterest4, param_.tmp.scenes_all , param_.tmp.n_time , true );
        close(hMsg5);
        if ~flag_pi4
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