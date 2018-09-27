function ImageDrawPolygon( h,~ )
param = guidata(h);
if ~isfield(param.hMain,'poly')
    param.hMain.poly = [];
end
hp = impoly(param.hMain.axes1);
param.hMain.poly = [param.hMain.poly ; hp];
try
    id = addNewPositionCallback(hp,@refreshgating0_main);
catch
    msgbox('Please finish drawing polygon before other tasks.','Error','error');
    return;
end
param = updatepolygonselection_main(param);
param = Updatedisplay_Image_0(param);
InformAllInterfaces(param);
end
function refreshgating0_main(~,~)
h = gcf;
param = guidata(h);
param = updatepolygonselection_main(param);
param = Updatedisplay_Image_0(param);
guidata(h,param);
end
function param = updatepolygonselection_main(param)
list = setdiff(unique(param.tmp.manual_label_image(:)),0);
xlist = zeros([length(list),1]);
ylist = zeros([length(list),1]);
for i = 1:length(list)
    [ys,xs] = find(param.tmp.manual_label_image == list(i));
    ylist(i) = median(ys);
    xlist(i) = median(xs);
end
if isfield(param.hMain,'poly')
    l = length(param.hMain.poly);
    pos = cell([l,1]);
    for j = 1:l
        if isvalid(param.hMain.poly(j))
            pos{j} = getPosition(param.hMain.poly(j));
            in = inpolygon(xlist,ylist,pos{j}(:,1),pos{j}(:,2));
            param.tmp.manual_list_selected_objects = union(param.tmp.manual_list_selected_objects , find(in)');
        end
    end
    param.tmp.manual_list_selected_objects = param.tmp.manual_list_selected_objects(:)';
end
end
