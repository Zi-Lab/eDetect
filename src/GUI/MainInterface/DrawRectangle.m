function DrawRectangle( h,~ )
param = guidata(h);
if ~isfield(param.hMain,'rectangle')
    param.hMain.rectangle = [];
end
try
    hp = imrect(param.hMain.axes1);
catch
    msgbox('Please finish drawing rectangle before other tasks.','Error','error');
    return;
end
param.hMain.rectangle = [param.hMain.rectangle ; hp];
try
    id = addNewPositionCallback(hp,@refreshgating0_main);
catch
    msgbox('Please finish drawing rectangle before other tasks.','Error','error');
    return;
end
InformAllInterfaces(param);
end
function refreshgating0_main(~,~)
h = gcf;
param = guidata(h);
guidata(h,param);
end
