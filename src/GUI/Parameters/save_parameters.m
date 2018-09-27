function save_parameters(h,~)
param = guidata(h);
%%
%%
%% 1 segmentation
str1 = get(param.hSetParameter.Edit_param_min_obj_rad, 'String');
str2 = get(param.hSetParameter.Edit_param_med_obj_rad, 'String');
str3 = get(param.hSetParameter.Edit_param_max_obj_rad, 'String');
num1 = str2double(str1);
num2 = str2double(str2);
num3 = str2double(str3);
flag1_seg = check_parameters_seg(true , num1,num2,num3);
if ~flag1_seg
    return;
end
param.seg.min_object = num1;
param.seg.med_object = num2;
param.seg.max_object = num3;
%% 2 tracking
str0 = get(param.hSetParameter.Edit_param_max_fra_dsp, 'String');
num0 = str2double(str0);
flag_tra = check_parameters_tra(true , num0);
if ~flag_tra
    return;
end
param.tra.max_frame_displacement = num0;
%% 3 expansion
str01 = get(param.hSetParameter.Edit_radii_n_1,'String');
str02 = get(param.hSetParameter.Edit_radii_c_1,'String');
str03 = get(param.hSetParameter.Edit_radii_c_2,'String');
num01 = str2double(str01);
num02 = str2double(str02);
num03 = str2double(str03);
flag_exp = check_parameters_exp(true  ,  param.dir.dir_proteinofinterest  ,  num01,num02,num03);
if ~flag_exp
    return;
end
param.exp.nuclei_radii                = num01;
param.exp.cytoplasm_ring_inner_radii  = num02;
param.exp.cytoplasm_ring_outer_radii  = num03;
%%
%%
%% save parameters to file
param_.dir = param.dir;
param_.met = param.met;
param_.seg = param.seg;
param_.tra = param.tra;
param_.exp = param.exp;
param_.set = param.set;
if ischar([param.dir.path_projectfile])
    try
        savefile( param_ , 'param' , [param.dir.path_projectfile]  );
        msgbox('Parameters saved','Information','help');
    catch
        msgbox('Parameters not saved','Error','error');
        return;
    end
end
%%
param = CheckStatus( param );
InformAllInterfaces(param);
close(param.hSetParameter.fig);
end