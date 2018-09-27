function param = Updatedisplay_Segmentationgating_0(param)
%l = length(param.hNucleiSegmentationGating.axes1.Children);
%for i = l:(-1):1
%    if isa(param.hNucleiSegmentationGating.axes1.Children(i),'matlab.graphics.chart.primitive.Line')
%        delete(param.hNucleiSegmentationGating.axes1.Children(i));
%    end
%end
%cla(param.hNucleiSegmentationGating.axes1,'reset');
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
if param.set.deleted_objects_display == 1
    param.hNucleiSegmentationGating.points_s_d = plot(param.tmp.pc_segmentationgating(id_s_d,1),   param.tmp.pc_segmentationgating(id_s_d,2),   'ro','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');%,hold on;
elseif param.set.deleted_objects_display == 2
    param.hNucleiSegmentationGating.points_s_d = plot(param.tmp.pc_segmentationgating(id_s_d,1),   param.tmp.pc_segmentationgating(id_s_d,2),   'r.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');%,hold on;
end
if param.set.deleted_objects_display == 1
    param.hNucleiSegmentationGating.points_us_d = plot(param.tmp.pc_segmentationgating(id_us_d,1),  param.tmp.pc_segmentationgating(id_us_d,2),  'bo','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');%,hold on;
elseif param.set.deleted_objects_display == 2
    param.hNucleiSegmentationGating.points_us_d = plot(param.tmp.pc_segmentationgating(id_us_d,1),  param.tmp.pc_segmentationgating(id_us_d,2),  'g.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');%,hold on;
end
param.hNucleiSegmentationGating.points_us_ud = plot(param.tmp.pc_segmentationgating(id_us_ud,1), param.tmp.pc_segmentationgating(id_us_ud,2), 'b.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');%,hold on;
param.hNucleiSegmentationGating.points_s_ud = plot(param.tmp.pc_segmentationgating(id_s_ud,1),  param.tmp.pc_segmentationgating(id_s_ud,2),  'r.','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off');%,hold on;
id_s_d = [];
id_s_ud = [];
id_us_d = [];
id_us_ud = [];
set(param.hNucleiSegmentationGating.axes1,'ButtonDownFcn',@CallbackMouseClickOnSegmentationGating,'HitTest','on');
%%
[ param ] = Updatedisplay_Segmentationgating_00( param );
end