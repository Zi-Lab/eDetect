function [ param ] = Updatedisplay_Segmentationgating_00( param )
if isfield(param,'hNucleiSegmentationGating')
    if isfield(param.hNucleiSegmentationGating,'hl')
        if isvalid(param.hNucleiSegmentationGating.hl)
            delete(param.hNucleiSegmentationGating.hl);
        end
    end
end
if ~isempty(param.tmp.manual_list_selected_scene_frame)
    s = param.tmp.manual_list_selected_scene_frame(1);
    t = param.tmp.manual_list_selected_scene_frame(2);
    objs = param.tmp.manual_list_selected_objects;
    %param.tmp.label_segmentation_gating = [param.tmp.label_segmentation_gating ; [ zeros([size(feature_matrix,1),1])+s zeros([size(feature_matrix,1),1])+t  (1:size(feature_matrix,1))'  ]];
    highlight = [];
    for i = 1:length(objs)
        highlight = [highlight; find( param.tmp.label_segmentation_gating(:,1) == s & param.tmp.label_segmentation_gating(:,2) == t & param.tmp.label_segmentation_gating(:,3) == objs(i) )];
    end
    %for i = 1:length(highlight)
    %    plot(param.tmp.pc_segmentationgating(highlight(i),1),  param.tmp.pc_segmentationgating(highlight(i),2),  'rs','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off','MarkerSize',20,'LineWidth',2);%,hold on;'MarkerEdgeColor', 'MarkerFaceColor'
    %end
    param.hNucleiSegmentationGating.hl = plot(param.tmp.pc_segmentationgating(highlight,1),  param.tmp.pc_segmentationgating(highlight,2),  'rs','Parent',param.hNucleiSegmentationGating.axes1,'HitTest','off','MarkerSize',20,'LineWidth',2);%,hold on;'MarkerEdgeColor', 'MarkerFaceColor'
end
end

