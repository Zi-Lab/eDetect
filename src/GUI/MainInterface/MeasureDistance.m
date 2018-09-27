function MeasureDistance( h,~ )
param = guidata(h);
param.hMain.dist = imdistline(param.hMain.axes1);
guidata(h,param);
end

