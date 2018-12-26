function CallbackSliderSynchrogram( h,~ )
param = guidata(h);
shift = round(1000*(get(param.hSynchrogram.SliderFrame,'Value')))/1000;
h_crop = param.tmp.h_synchrogram_crop;
d_crop = param.tmp.d_synchrogram_crop;
n      = param.tmp.n_synchrogram_crop;
pos = param.hSynchrogram.fig.Position;
set(param.hSynchrogram.axes_montage,'Position',[1-shift*( max(0, n*(h_crop+d_crop)-pos(3))  ) 1 n*(h_crop+d_crop) h_crop]);
guidata(h,param);
end

