function save_settings(h,~)
param = guidata(h);
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
        msgbox('Parameters and settings saved','Information','help');
    catch
        msgbox('Parameters and settings not saved','Error','error');
        return;
    end
end
%%
param = CheckStatus( param );
InformAllInterfaces(param);
close(param.hSettings.fig);
end