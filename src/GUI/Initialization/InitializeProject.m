function [ param ] = InitializeProject
%
param.dir.path_projectfile = '';
param.dir.dir_nucleimarker = '';
param.dir.dir_proteinofinterest = '';
param.dir.dir_label_nuclei = '';
param.dir.dir_feature = '';
param.dir.dir_lineage = '';
param.dir.dir_label_measurement = '';
param.dir.dir_measurement = '';
%
param.met.filename_format_nucleimarker = '';
param.met.filename_format_proteinofinterest = '';
param.met.min_scene = '';
param.met.max_scene = '';
param.met.min_time = '';
param.met.max_time = '';
%
param.seg.max_object = Inf;
param.seg.med_object = [];
param.seg.min_object = 0;
%
param.tra.max_frame_displacement = Inf;
%
param.exp.nuclei_radii = 1;
param.exp.cytoplasm_ring_inner_radii = 1;
param.exp.cytoplasm_ring_outer_radii = [];
%%
end
%%