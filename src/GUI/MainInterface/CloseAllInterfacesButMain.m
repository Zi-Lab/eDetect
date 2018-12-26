function CloseAllInterfacesButMain( param )
if isfield(param,'hLineage')
    if isfield(param.hLineage,'fig')
        if isvalid(param.hLineage.fig)
            close(param.hLineage.fig);
        end
    end
end
if isfield(param,'hNucleiCellpairGating')
    if isfield(param.hNucleiCellpairGating,'fig')
        if isvalid(param.hNucleiCellpairGating.fig)
            close(param.hNucleiCellpairGating.fig);
        end
    end
end
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'fig')
        if isvalid(param.hNucleiSegmentationGating.fig)
            close(param.hNucleiSegmentationGating.fig);
        end
    end
end
if isfield(param,'hSettings')
    if isfield(param.hSettings,'fig')
        if isvalid(param.hSettings.fig)
            close(param.hSettings.fig);
        end
    end
end
if isfield(param,'hSetParameter')
    if isfield(param.hSetParameter,'fig')
        if isvalid(param.hSetParameter.fig)
            close(param.hSetParameter.fig);
        end
    end
end
if isfield(param,'hNewProject')
    if isfield(param.hNewProject,'fig')
        if isvalid(param.hNewProject.fig)
            close(param.hNewProject.fig);
        end
    end
end
if isfield(param,'hSynchrogram')
    if isfield(param.hSynchrogram,'fig')
        if isvalid(param.hSynchrogram.fig)
            close(param.hSynchrogram.fig);
        end
    end
end
end

