function CellLineageReconstruction(h,~)
param = guidata(h);
%%
filenames_track = param.tmp.filenames_track;
filenames_lineage = param.tmp.filenames_lineage;
%%
scene_array = str2double(strsplit(param.tmp.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
scenes_for_lineage_reconstruction = scene_array;
%%
CloseAllInterfacesButMain(param);
%%
dir_lineage = param.tmp.dir_lineage;
ns = length(scenes_for_lineage_reconstruction);
%%
hbar = parfor_progressbar(ns , dir_lineage , 'Computing...');
for i = 1:ns
    s = scenes_for_lineage_reconstruction(i);
    s_id = find(param.tmp.scenes_all == s);
    temp = load(fullfile(dir_lineage, filenames_track{s_id}));
    [ lineage ]  = lineage_construct( temp.track);
    savefile(lineage, 'lineage'  ,fullfile(dir_lineage, filenames_lineage{s_id}));
    hbar.iterate(1);
end
close(hbar);
%%
[ param ] = CheckStatus( param );
InformAllInterfaces(param);
CellLineagesDisplay(h);
end