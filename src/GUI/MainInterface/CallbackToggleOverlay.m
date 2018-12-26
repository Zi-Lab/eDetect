function CallbackToggleOverlay(h,~)
param = guidata(h);
if isfield(param.hMain,'SliderFrame2')
    param = Updatedisplay_Image_0(param);
    InformAllInterfaces(param);
end
end

