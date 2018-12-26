function SizeChangedFcn_CellLineagesDisplay( h,~ )
param = guidata(h);
if ~isempty(param)
    w_f  = h.Position(3);
    h_f = h.Position(4);
    w_ctrl = param.tmp.w_ctrl_2;
    h_p1 = param.tmp.h_p1;
    h_p5 = param.tmp.h_p5;
    h_p = h_p5+h_p1 + h_p1;
    if w_f<w_ctrl
        param.hLineage.fig.Position(3) = w_ctrl;
        w_f = w_ctrl;
    end
    if h_f<h_p
        %param.hLineage.fig.Position(4) = h_p;
        %h_f = h_p;
    end
    param.hLineage.panel_display.Position = [1 h_f-h_p5+1        w_ctrl h_p5];
    param.hLineage.panel_filters.Position = [1 h_f-h_p1-h_p5+1   w_ctrl h_p1];
    param.hLineage.panel_outlier.Position = [1 h_f-h_p1-h_p1-h_p5+1 w_ctrl h_p1];
    param.hLineage.panel_lineage.Position = [w_ctrl+1 1 w_f-w_ctrl h_f];
end
guidata(h,param);
end

