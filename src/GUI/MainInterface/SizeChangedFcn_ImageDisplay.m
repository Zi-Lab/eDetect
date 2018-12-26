function SizeChangedFcn_ImageDisplay( h,~ )
param = guidata(h);
if ~isempty(param)
    w_f  = h.Position(3);
    h_f = h.Position(4);
    w_ctrl = param.tmp.w_ctrl_1;
    h_p4 = param.tmp.h_p4;
    h_p3 = param.tmp.h_p3;
    if w_f<w_ctrl
        param.hMain.fig.Position(3) = w_ctrl;
        w_f = w_ctrl;
    end
    if h_f<h_p4+h_p3
        %param.hMain.fig.Position(4) = h_p4+h_p3;
        %h_f = h_p4+h_p3;
    end
    if isfield(param.hMain,'panel_navigation')
        param.hMain.panel_navigation.Position = [1 h_f-h_p4      w_ctrl h_p4];
        param.hMain.panel_display.Position    = [1 h_f-h_p4-h_p3 w_ctrl h_p3];
    end
    param.hMain.axes1.Position = [w_ctrl+1 1 w_f-w_ctrl h_f];
end
guidata(h,param);
end

