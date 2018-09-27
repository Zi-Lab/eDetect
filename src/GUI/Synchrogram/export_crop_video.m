function export_crop_video( h,~ )
param = guidata(h);
%%
I = param.tmp.I_synchrogram_stack;
n = param.tmp.n_synchrogram_crop;
%param.tmp.filtered_lineage_tree;
y = param.tmp.row_for_synchrogram;
temp = find(param.tmp.filtered_lineage_tree(y,:)>0);
xs = param.tmp.frames_displayed(temp);
%%
if param.tmp.n_scene == 1
    s = param.tmp.min_scene;
else
    s = round((get(param.hLineage.SliderFrame1,'Value')));
end
s_id = find(param.tmp.scenes_all == s);
%%
for j = 0:9999
    dir_video = fullfile(param.tmp.directories_crop_video{s_id} , num2strdigits(j,4));
    if exist(dir_video,'dir') ~= 7
        mkdir(dir_video);
        for i = 1:n
            filename = fullfile(dir_video , [num2str(xs(i)) '_' num2str(param.tmp.filtered_lineage_tree(y,temp(i))) '.tif']);
            imwrite(I{i},filename);
        end
        break;
    end
end
msgbox('Image sequence saved.','Information','help');
end

