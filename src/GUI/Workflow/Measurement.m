function Measurement(h,~)
param = guidata(h);
CloseAllInterfacesButMain(param);
%%
if exist(param.tmp.dir_label_measurement,'dir') == 7
    ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
    switch ButtonName
        case 'Yes'
            [status, message, messageid] = rmdir(param.tmp.dir_label_measurement, 's');
        case 'Cancel'
            return;
        case ''
            return;
    end
end
if exist(param.tmp.dir_measurement,'dir') == 7
    ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
    switch ButtonName
        case 'Yes'
            [status, message, messageid] = rmdir(param.tmp.dir_measurement, 's');
        case 'Cancel'
            return;
        case ''
            return;
    end
end
%%
if param.set.processing_number_of_cores > 1
    p = gcp('nocreate');
    if isempty(p)
        hMsg = msgbox('Starting parallel pool...','Information','help');
        delete(findobj(hMsg,'string','OK'));
        try
            parpool('local',param.set.processing_number_of_cores);
        catch e
            msgbox([e.message],'Warning','warn');
        end
        if isvalid(hMsg)
            close(hMsg);
        end
    end
end
%%
directories_label_measure = param.tmp.directories_label_measure;
filenames_label_measure = param.tmp.filenames_label_measure;
directories_label_gray  = param.tmp.directories_label_gray;
filenames_label_gray  = param.tmp.filenames_label_gray;
directories_measurement = param.tmp.directories_measurement;
filenames_measurement = param.tmp.filenames_measurement;
dir_proteinofinterest = param.tmp.dir_proteinofinterest;
filenames_proteinofinterest = param.tmp.filenames_proteinofinterest;
%%
scene_array = str2double(strsplit(param.set.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
scenes_for_measure = scene_array;
%%
hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_measure) ,param.tmp.dir_label_measurement , '1st step...');
for i = 1:length(scenes_for_measure)
    s = scenes_for_measure(i);
    s_id = find(param.tmp.scenes_all == s);
    if exist(directories_label_measure{s_id},'dir') ~= 7
        mkdir(directories_label_measure{s_id});
    end
    param_seg = param.seg;
    param_exp = param.exp;
    if param.set.processing_number_of_cores > 1
        parfor t = 1:param.tmp.n_time
            execute_nuclei_expansion(param_seg,param_exp , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_label_measure{s_id} , filenames_label_measure{s_id,t} );
            hbar.iterate(1);
        end
    else
        for t = 1:param.tmp.n_time
            execute_nuclei_expansion(param_seg,param_exp , directories_label_gray{s_id} , filenames_label_gray{s_id,t} , directories_label_measure{s_id} , filenames_label_measure{s_id,t} );
            hbar.iterate(1);
        end
    end
end
close(hbar);
%%
hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_measure) ,param.tmp.dir_proteinofinterest , '2nd step...');
for i = 1:length(scenes_for_measure)
    s = scenes_for_measure(i);
    s_id = find(param.tmp.scenes_all == s);
    mkdir( directories_measurement{s_id});
    if param.set.processing_number_of_cores > 1
        parfor t = 1:param.tmp.n_time
            execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest , filenames_proteinofinterest{s_id,t} , directories_measurement{s_id} , filenames_measurement{s_id,t});
            hbar.iterate(1);
        end
    else
        for t = 1:param.tmp.n_time
            execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest , filenames_proteinofinterest{s_id,t} , directories_measurement{s_id} , filenames_measurement{s_id,t});
            hbar.iterate(1);
        end
    end
end
close(hbar);
%%
[ param ] = CheckStatus( param );
InformAllInterfaces(param);
CellLineagesDisplay(h);
end
%%
%%
%%
%%
function execute_nuclei_expansion(param_seg , param_exp , directory_label_gray , filename_label_gray , directory_label_measure , filename_label_measure )
label = get_label_image(directory_label_gray , filename_label_gray );
label_measure_nuclei          = expand_nuclei(label , -param_exp.nuclei_radii);
label_measure_cytoplasm_inner = expand_nuclei(label , param_exp.cytoplasm_ring_inner_radii);
label_measure_cytoplasm_outer = expand_nuclei(label , param_exp.cytoplasm_ring_outer_radii);
label_measure_foreground      = expand_nuclei(label , max(param_seg.max_object, param_exp.cytoplasm_ring_outer_radii * 2));
temp1 = fullfile(directory_label_measure,filename_label_measure);
savefile(label_measure_nuclei          , 'label_measure_nuclei'          , temp1);
savefile(label_measure_cytoplasm_inner , 'label_measure_cytoplasm_inner' , temp1);
savefile(label_measure_cytoplasm_outer , 'label_measure_cytoplasm_outer' , temp1);
savefile(label_measure_foreground      , 'label_measure_foreground'      , temp1);
end
%%
function execute_intensity_quantification( directory_label_measure , filename_label_measure , directory_proteinofinterest , filename_proteinofinterest , directory_measurement , filename_measurement)
if ~isempty(filename_proteinofinterest)
    data = imread(fullfile(directory_proteinofinterest , filename_proteinofinterest));
    temp = load(fullfile( directory_label_measure , filename_label_measure));
    label_measure_nuclei          = temp.label_measure_nuclei;
    label_measure_cytoplasm_inner = temp.label_measure_cytoplasm_inner;
    label_measure_cytoplasm_outer = temp.label_measure_cytoplasm_outer;
    label_measure_foreground      = temp.label_measure_foreground;
    if isempty(label_measure_cytoplasm_inner) || isempty(label_measure_cytoplasm_outer)
        label_measure_cytoplasm = [];
    else
        label_measure_cytoplasm = label_measure_cytoplasm_outer - label_measure_cytoplasm_inner;
    end
    [ nuclei_median , cytoplasm_median , nuclei_mean , cytoplasm_mean , background_min , background_max , background_mean , background_median ] = calculate_intensity_ratio(data , label_measure_nuclei , label_measure_cytoplasm , label_measure_foreground );
    nucl_to_cyto_median_ratio = (nuclei_median - background_median) ./ (cytoplasm_median - background_median);
    nucl_to_cyto_mean_ratio = (nuclei_mean - background_mean) ./ (cytoplasm_mean - background_mean);
    image_mean   = mean(double(data(:)));
    image_median = median(double(data(:)));
    temp_str = fullfile( directory_measurement, filename_measurement);
    savefile(nuclei_median      , 'nuclei_median'      , temp_str);
    savefile(cytoplasm_median   , 'cytoplasm_median'   , temp_str);
    savefile(nuclei_mean        , 'nuclei_mean'        , temp_str);
    savefile(cytoplasm_mean     , 'cytoplasm_mean'     , temp_str);
    savefile(background_min     , 'background_min'     , temp_str);
    savefile(background_max     , 'background_max'     , temp_str);
    savefile(background_mean    , 'background_mean'    , temp_str);
    savefile(background_median  , 'background_median'  , temp_str);
    savefile(image_mean         , 'image_mean'         , temp_str);
    savefile(image_median       , 'image_median'       , temp_str);
    savefile(nucl_to_cyto_median_ratio , 'nucl_to_cyto_median_ratio'  , temp_str);
    savefile(nucl_to_cyto_mean_ratio   , 'nucl_to_cyto_mean_ratio'    , temp_str);
end
end