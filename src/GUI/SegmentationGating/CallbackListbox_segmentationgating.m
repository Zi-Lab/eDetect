function CallbackListbox_segmentationgating( h, ~ )
param = guidata(h);
%%
list = param.hNucleiSegmentationGating.List_features.Value;
l = length(list);
if l == 0
    fml = '';
else
    fml = ['v{' num2str(list(1)) '}'];
    if l > 1
        for j = 2:l
            fml = [fml ',v{' num2str(list(j)) '}'];
        end
    end
end
set(param.hNucleiSegmentationGating.Edit_formula,'String',fml);
%%
InformAllInterfaces(param);
end

