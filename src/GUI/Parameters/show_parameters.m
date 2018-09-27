function show_parameters(param)
h = param.hSetParameter;
%%
set(h.Edit_set_project,'String',param.dir.path_projectfile);
set(h.Edit_set_dir_nuc_raw,'String',param.dir.dir_nucleimarker);
set(h.Edit_set_dir_int_raw,'String',param.dir.dir_proteinofinterest);
set(h.Edit_set_dir_nuc_lab,'String',param.dir.dir_label_nuclei);
set(h.Edit_set_dir_nuc_fea,'String',param.dir.dir_feature);
set(h.Edit_set_dir_lineage,'String',param.dir.dir_lineage);
set(h.Edit_set_dir_cyt_lab,'String',param.dir.dir_label_measurement);
set(h.Edit_set_dir_measurement,'String',param.dir.dir_measurement);
%%
set(h.Edit_param_max_obj_rad,'String',num2str(param.seg.max_object));
set(h.Edit_param_med_obj_rad,'String',num2str(param.seg.med_object));
set(h.Edit_param_min_obj_rad,'String',num2str(param.seg.min_object));
%
set(h.Edit_param_max_fra_dsp,'String',num2str(param.tra.max_frame_displacement));
%
set(h.Edit_radii_n_1,'String',num2str(param.exp.nuclei_radii));
set(h.Edit_radii_c_1,'String',num2str(param.exp.cytoplasm_ring_inner_radii));
set(h.Edit_radii_c_2,'String',num2str(param.exp.cytoplasm_ring_outer_radii));
%%
set(h.Edit_param_nuc_fil,'String',param.met.filename_format_nucleimarker);
set(h.Edit_param_int_fil,'String',param.met.filename_format_proteinofinterest);
set(h.Edit_param_sce_min,'String',param.met.min_scene);
set(h.Edit_param_sce_max,'String',param.met.max_scene);
set(h.Edit_param_fra_min,'String',param.met.min_time);
set(h.Edit_param_fra_max,'String',param.met.max_time);
%%
if isempty(h.Edit_set_dir_int_raw.String)
    h.Edit_param_int_fil.String = '';
    h.Edit_radii_n_1.String = '';
    h.Edit_radii_c_1.String = '';
    h.Edit_radii_c_2.String = '';
    h.Edit_radii_c_3.String = '';
    h.Edit_param_int_fil.Enable = 'off';
    h.Edit_radii_n_1.Enable = 'off';
    h.Edit_radii_c_1.Enable = 'off';
    h.Edit_radii_c_2.Enable = 'off';
    h.Edit_radii_c_3.Enable = 'off';
end
%%
str1 = get(h.Edit_param_nuc_fil,'string');
if isempty(str1)
    flag1 = -1;
else
    flag1 = length(strfind(str1,'<'));
end
if flag1 <= 0
    set(h.Edit_param_sce_min,'enable','off');
    set(h.Edit_param_sce_max,'enable','off');
end
%%
end