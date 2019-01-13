function param = Updatedisplay_Segmentationgating_0(param)
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'points_s_d')
        if isvalid(param.hNucleiSegmentationGating.points_s_d)
            delete(param.hNucleiSegmentationGating.points_s_d);
        end
    end
    if isfield(param.hNucleiSegmentationGating,'points_us_d')
        if isvalid(param.hNucleiSegmentationGating.points_us_d)
            delete(param.hNucleiSegmentationGating.points_us_d);
        end
    end
    if isfield(param.hNucleiSegmentationGating,'points_s_ud')
        if isvalid(param.hNucleiSegmentationGating.points_s_ud)
            delete(param.hNucleiSegmentationGating.points_s_ud);
        end
    end
    if isfield(param.hNucleiSegmentationGating,'points_us_ud')
        if isvalid(param.hNucleiSegmentationGating.points_us_ud)
            delete(param.hNucleiSegmentationGating.points_us_ud);
        end
    end
end
%%
id_s_d   =  param.tmp.segmentation_gating_selected &  param.tmp.gating_deleted;
id_s_ud  =  param.tmp.segmentation_gating_selected & ~param.tmp.gating_deleted;
id_us_d  = ~param.tmp.segmentation_gating_selected &  param.tmp.gating_deleted;
id_us_ud = ~param.tmp.segmentation_gating_selected & ~param.tmp.gating_deleted;
hold( param.hNucleiSegmentationGating.axes1, 'on' );
if strcmp( get(param.hNucleiSegmentationGating.toggletool_DisplayDeleted,'State') , 'on')
    param.hNucleiSegmentationGating.points_s_d = plot(param.tmp.pc_segmentationgating(id_s_d,1),   param.tmp.pc_segmentationgating(id_s_d,2),   'r.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');
    param.hNucleiSegmentationGating.points_us_d = plot(param.tmp.pc_segmentationgating(id_us_d,1),  param.tmp.pc_segmentationgating(id_us_d,2),  'g.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');
end
param.hNucleiSegmentationGating.points_us_ud = plot(param.tmp.pc_segmentationgating(id_us_ud,1), param.tmp.pc_segmentationgating(id_us_ud,2), 'b.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');
param.hNucleiSegmentationGating.points_s_ud = plot(param.tmp.pc_segmentationgating(id_s_ud,1),  param.tmp.pc_segmentationgating(id_s_ud,2),  'r.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');
id_s_d = [];
id_s_ud = [];
id_us_d = [];
id_us_ud = [];
set(param.hNucleiSegmentationGating.axes1,'ButtonDownFcn',@CallbackMouseClickOnSegmentationGating,'HitTest','on');
%%
[ param ] = Updatedisplay_Segmentationgating_00( param );
end