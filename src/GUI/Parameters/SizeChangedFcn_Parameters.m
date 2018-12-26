function SizeChangedFcn_Parameters( h,~ )
param = guidata(h);
if ~isempty(param)
    w_f  = h.Position(3);
    h_f = h.Position(4);
    w_ctrl = param.tmp.w_ctrl_2;
    h_p1 = param.tmp.h_p1;
    h_p2 = param.tmp.h_p2;
    w_axes = param.tmp.w_axes_2;
    if w_f < w_ctrl+w_axes
        param.hSetParameter.fig.Position(3) = w_ctrl+w_axes;
    end
    if h_f < h_p2+h_p2
        param.hSetParameter.fig.Position(4) = h_p2+h_p2;
    end
end
guidata(h,param);
end

