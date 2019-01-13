function param = Updatedisplay_Cellpairgating_0(param)
if isfield(param,'hNucleiCellpairGating')
    if isfield(param.hNucleiCellpairGating,'points_s')
        if isvalid(param.hNucleiCellpairGating.points_s)
            delete(param.hNucleiCellpairGating.points_s);
        end
    end
    if isfield(param.hNucleiCellpairGating,'points_us')
        if isvalid(param.hNucleiCellpairGating.points_us)
            delete(param.hNucleiCellpairGating.points_us);
        end
    end
end
id_s  =   param.tmp.cellpair_gating_selected;
id_us = ~ param.tmp.cellpair_gating_selected;
hold( param.hNucleiCellpairGating.axes1, 'on' );
param.hNucleiCellpairGating.points_s  = plot(param.tmp.pc_cellpairgating(id_s,1) ,param.tmp.pc_cellpairgating(id_s,2) ,'r.','Parent',param.hNucleiCellpairGating.axes1,'HitTest','off');
param.hNucleiCellpairGating.points_us = plot(param.tmp.pc_cellpairgating(id_us,1),param.tmp.pc_cellpairgating(id_us,2),'b.','Parent',param.hNucleiCellpairGating.axes1,'HitTest','off');
id_s  = [];
id_us = [];
set(param.hNucleiCellpairGating.axes1,'ButtonDownFcn',@CallbackMouseClickOnCellpairGating,'HitTest','on');
end