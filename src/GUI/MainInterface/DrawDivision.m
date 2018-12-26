function DrawDivision( h,~ )
param = guidata(h);
if ~isfield(param.hMain,'curve')
    param.hMain.curve = [];
end
try
    hp = imfreehand(param.hMain.axes1,'Closed',false);
catch
    msgbox('Please finish drawing open curves before other tasks.','Error','error');
    return;
end
param.hMain.curve = [param.hMain.curve ; hp];
try
    id = addNewPositionCallback(hp,@refreshgating0_main);
catch
    msgbox('Please finish drawing open curves before other tasks.','Error','error');
    return;
end
InformAllInterfaces(param);
end
function refreshgating0_main(~,~)
h = gcf;
param = guidata(h);
guidata(h,param);
end
