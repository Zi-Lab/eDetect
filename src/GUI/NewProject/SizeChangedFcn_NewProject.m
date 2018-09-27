function SizeChangedFcn_NewProject( h,~ )
param = guidata(h);
if ~isempty(param)
    w_f  = h.Position(3);
    h_f = h.Position(4);
    w_ctrl_1 = param.tmp.w_ctrl_1;
    h_p1 = param.tmp.h_p1;
    h_p2 = param.tmp.h_p2;
    w_axes_1 = param.tmp.w_axes_1;
    if w_f < w_ctrl_1+w_axes_1
        param.hNewProject.fig.Position(3) = w_ctrl_1+w_axes_1;
    end
    if h_f < h_p1+h_p2
        param.hNewProject.fig.Position(4) = h_p1+h_p2;
    end
end
guidata(h,param);
end

