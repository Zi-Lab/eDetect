function LoadProject(h,~)
param = guidata(h);
[ FileName , PathName , ~ ] = uigetfile('*.eDetectProject');
if isa(PathName,'double')
    return;
end
try
    param_ = param;
    param2 = InitializeSettings;
    param3 = InitializeVariables;
    param_.set = param2.set;
    param_.tmp = param3.tmp;
    temp = load([PathName FileName],'-mat');
    param_.dir = temp.param.dir;
    param_.met = temp.param.met;
    param_.seg = temp.param.seg;
    param_.tra = temp.param.tra;
    param_.exp = temp.param.exp;
    if isfield(temp.param,'set')
        param_.set = temp.param.set;
    end
    param_.dir.path_projectfile = fullfile(PathName,FileName);
catch
    msgbox('The project was not loaded.','Error','error');
    return;
end
str = 'The directories and filenames from loaded project are incorrect.';
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
        flag_nm = CheckInputImages(param_.tmp.dir_nucleimarker      , param_.tmp.filenames_nucleimarker     , param_.tmp.scenes_all , param_.tmp.n_time , false);
        if ~flag_nm
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest1)
        flag_pi1 = CheckInputImages(param_.tmp.dir_proteinofinterest1 , param_.tmp.filenames_proteinofinterest1, param_.tmp.scenes_all , param_.tmp.n_time , false);
        if ~flag_pi1
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest2)
        flag_pi2 = CheckInputImages(param_.tmp.dir_proteinofinterest2 , param_.tmp.filenames_proteinofinterest2, param_.tmp.scenes_all , param_.tmp.n_time , false);
        if ~flag_pi2
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest3)
        flag_pi3 = CheckInputImages(param_.tmp.dir_proteinofinterest3 , param_.tmp.filenames_proteinofinterest3, param_.tmp.scenes_all , param_.tmp.n_time , false);
        if ~flag_pi3
            msgbox(str,'Error','error');
            return;
        end
    end
    if ~isempty(param_.dir.dir_proteinofinterest4)
        flag_pi4 = CheckInputImages(param_.tmp.dir_proteinofinterest4 , param_.tmp.filenames_proteinofinterest4, param_.tmp.scenes_all , param_.tmp.n_time , false);
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
%%
msgbox('Project loaded','Information','help');
%%
param_ = CheckStatus( param_ );
InformAllInterfaces(param_);
CloseAllInterfacesButMain(param_);
end