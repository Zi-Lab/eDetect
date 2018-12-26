function CallbackListbox_cellpairgating( h, ~ )
param = guidata(h);
%%
list = param.hNucleiCellpairGating.List_features.Value;
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
set(param.hNucleiCellpairGating.Edit_formula,'String',fml);
%%
InformAllInterfaces(param);
end

