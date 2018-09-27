function InformAllInterfaces( param )
if isfield(param,'hMain')
    if isfield(param.hMain,'fig')
        if isvalid(param.hMain.fig)
            guidata(param.hMain.fig,param);
        end
    end
end
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isvalid(param.hNucleiSegmentationGating.fig)
            guidata(param.hNucleiSegmentationGating.fig,param);
        end
    end
end
if isfield(param,'hNucleiCellpairGating')
    if isfield(param.hNucleiCellpairGating,'fig')
        if isvalid(param.hNucleiCellpairGating.fig)
            guidata(param.hNucleiCellpairGating.fig,param);
        end
    end
end
if isfield(param,'hLineage')
    if isfield(param.hLineage,'fig')
        if isvalid(param.hLineage.fig)
            guidata(param.hLineage.fig,param);
        end
    end
end
if isfield(param,'hSynchrogram')
    if isfield(param.hSynchrogram,'fig')
        if isvalid(param.hSynchrogram.fig)
            guidata(param.hSynchrogram.fig,param);
        end
    end
end
if isfield(param,'hSettings')
    if isfield(param.hSettings,'fig')
        if isvalid(param.hSettings.fig)
            guidata(param.hSettings.fig,param);
        end
    end
end
if isfield(param,'hSetParameter')
    if isfield(param.hSetParameter,'fig')
        if isvalid(param.hSetParameter.fig)
            guidata(param.hSetParameter.fig,param);
        end
    end
end
if isfield(param,'hNewProject')
    if isfield(param.hNewProject,'fig')
        if isvalid(param.hNewProject.fig)
            guidata(param.hNewProject.fig,param);
        end
    end
end
end

