function DrawObject( h,~ )
param = guidata(h);
if ~isfield(param.hMain,'freehand')
    param.hMain.freehand = [];
end
try
    hp = imfreehand(param.hMain.axes1,'Closed',true);
catch
    msgbox('Please finish drawing closed curves before other tasks.','Error','error');
    return;
end
param.hMain.freehand = [param.hMain.freehand ; hp];
try
    id = addNewPositionCallback(hp,@refreshgating0_main);
catch
    msgbox('Please finish drawing closed curves before other tasks.','Error','error');
    return;
end
InformAllInterfaces(param);
end
function refreshgating0_main(~,~)
h = gcf;
param = guidata(h);
guidata(h,param);
end
