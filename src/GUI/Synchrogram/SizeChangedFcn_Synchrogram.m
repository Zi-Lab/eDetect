function SizeChangedFcn_Synchrogram( h,~ )
param = guidata(h);
if ~isempty(param)
    w_f = h.Position(3);
    h_f = h.Position(4);
    h_slider = param.tmp.h_synchrogram_slider;
    n = param.tmp.n_synchrogram_crop;
    d_crop = param.tmp.d_synchrogram_crop;
    if h_f < h_slider
        param.hSynchrogram.fig.Position(4) = h_slider;
        h_f = h_slider;
    end
    param.hSynchrogram.panel_synchrogram.Position = [1 1+h_slider w_f h_f-h_slider];
    param.hSynchrogram.SliderFrame.Position = [1 1 w_f h_slider];
    param.hSynchrogram.axes_montage.Position = [1 1 n*(h_f-h_slider+d_crop) (h_f-h_slider)];
    param.tmp.h_synchrogram_crop = (h_f-h_slider);
end
guidata(h,param);
end

