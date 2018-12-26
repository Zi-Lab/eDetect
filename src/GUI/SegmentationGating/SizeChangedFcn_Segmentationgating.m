function SizeChangedFcn_Segmentationgating( h,~ )
param = guidata(h);
if ~isempty(param)
    w_f  = h.Position(3);
    h_f = h.Position(4);
    w_ctrl = param.tmp.w_ctrl_1;
    h_p1 = param.tmp.h_p1;
    h_p2 = param.tmp.h_p2;
    if w_f<w_ctrl
        param.hNucleiSegmentationGating.fig.Position(3) = w_ctrl;
        w_f = w_ctrl;
    end
    if h_f<h_p1+h_p2
        %param.hNucleiSegmentationGating.fig.Position(4) = h_p1+h_p2;
        %h_f = h_p1+h_p2;
    end
    param.hNucleiSegmentationGating.panel_customize.Position = [1 h_f-h_p1-h_p2+1 w_ctrl h_p1+h_p2];
    param.hNucleiSegmentationGating.axes1.Position = [w_ctrl+1 1 w_f-w_ctrl h_f];
end
guidata(h,param);
end

