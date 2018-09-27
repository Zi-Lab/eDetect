function CallbackToggleChannel(h,~)
param = guidata(h);
if isfield(param.hMain,'SliderFrame2')
    param = Updatedisplay_Image_1(param);
    InformAllInterfaces(param);
end
end