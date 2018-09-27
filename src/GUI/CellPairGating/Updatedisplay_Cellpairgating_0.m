function param = Updatedisplay_Cellpairgating_0(param)
cla(param.hNucleiCellpairGating.axes1,'reset');
l = length(param.hNucleiCellpairGating.axes1.Children);
for i = l:(-1):1
    if isa(param.hNucleiCellpairGating.axes1.Children(i),'matlab.graphics.chart.primitive.Line')
        delete(param.hNucleiCellpairGating.axes1.Children(i));
    end
end
id_s  =   param.tmp.cellpair_gating_selected;
id_us = ~ param.tmp.cellpair_gating_selected;
plot(param.tmp.pc_cellpairgating(id_s,1) ,param.tmp.pc_cellpairgating(id_s,2) ,'r.','Parent',param.hNucleiCellpairGating.axes1,'HitTest','off'),hold on;
plot(param.tmp.pc_cellpairgating(id_us,1),param.tmp.pc_cellpairgating(id_us,2),'b.','Parent',param.hNucleiCellpairGating.axes1,'HitTest','off'),hold on;
id_s  = [];
id_us = [];
set(param.hNucleiCellpairGating.axes1,'ButtonDownFcn',@CallbackMouseClickOnCellpairGating,'HitTest','on'),hold on;
end