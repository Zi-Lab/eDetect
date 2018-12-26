function CallbackDropColor(h,~)
param = guidata(h);
try
    param = Updatedisplay_Heatmap_0(param);
catch
    msgbox('Something is wrong. Please try re-running the workflow.','Error','error');
    return;
end
InformAllInterfaces(param);
end