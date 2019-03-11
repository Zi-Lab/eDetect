function Measurement(h,~)
param = guidata(h);
CloseAllInterfacesButMain(param);
%%
%%
if param.tmp.processing_number_of_cores > 1
    p = gcp('nocreate');
    if isempty(p)
        hMsg = msgbox('Starting parallel pool...','Information','help');
        delete(findobj(hMsg,'string','OK'));
        try
            parpool('local',param.tmp.processing_number_of_cores);
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
directories_measurement1 = param.tmp.directories_measurement1;
filenames_measurement1 = param.tmp.filenames_measurement1;
directories_measurement2 = param.tmp.directories_measurement2;
filenames_measurement2 = param.tmp.filenames_measurement2;
directories_measurement3 = param.tmp.directories_measurement3;
filenames_measurement3 = param.tmp.filenames_measurement3;
directories_measurement4 = param.tmp.directories_measurement4;
filenames_measurement4 = param.tmp.filenames_measurement4;
dir_proteinofinterest1 = param.tmp.dir_proteinofinterest1;
filenames_proteinofinterest1 = param.tmp.filenames_proteinofinterest1;
dir_proteinofinterest2 = param.tmp.dir_proteinofinterest2;
filenames_proteinofinterest2 = param.tmp.filenames_proteinofinterest2;
dir_proteinofinterest3 = param.tmp.dir_proteinofinterest3;
filenames_proteinofinterest3 = param.tmp.filenames_proteinofinterest3;
dir_proteinofinterest4 = param.tmp.dir_proteinofinterest4;
filenames_proteinofinterest4 = param.tmp.filenames_proteinofinterest4;
%%
scene_array = str2double(strsplit(param.tmp.processing_scenes,' '));
if isnan(scene_array)
    scene_array = param.tmp.scenes_all;
end
scenes_for_measure = scene_array;
%%
flag_pi1 = CheckInputImages(param.tmp.dir_proteinofinterest1 , param.tmp.filenames_proteinofinterest1, param.tmp.scenes_all , param.tmp.n_time , false);
flag_pi2 = CheckInputImages(param.tmp.dir_proteinofinterest2 , param.tmp.filenames_proteinofinterest2, param.tmp.scenes_all , param.tmp.n_time , false);
flag_pi3 = CheckInputImages(param.tmp.dir_proteinofinterest3 , param.tmp.filenames_proteinofinterest3, param.tmp.scenes_all , param.tmp.n_time , false);
flag_pi4 = CheckInputImages(param.tmp.dir_proteinofinterest4 , param.tmp.filenames_proteinofinterest4, param.tmp.scenes_all , param.tmp.n_time , false);
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
hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_measure) ,param.tmp.dir_label_measurement , '1st step: generating masks for quantification.');
for i = 1:length(scenes_for_measure)
    s = scenes_for_measure(i);
    s_id = find(param.tmp.scenes_all == s);
    if exist(directories_label_measure{s_id},'dir') ~= 7
        mkdir(directories_label_measure{s_id});
    end
    param_seg = param.seg;
    param_exp = param.exp;
    if param.tmp.processing_number_of_cores > 1
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
if flag_pi1 && size(filenames_proteinofinterest1,1) == length(scenes_for_measure) && size(filenames_proteinofinterest1,2) == param.tmp.n_time
    if exist(param.tmp.dir_measurement1,'dir') == 7
        ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
        switch ButtonName
            case 'Yes'
                [status, message, messageid] = rmdir(param.tmp.dir_measurement1, 's');
            case 'Cancel'
                return;
            case ''
                return;
        end
    end
    hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_measure) ,param.tmp.dir_proteinofinterest1 , '2nd step: quantification of Channel 2');
    for i = 1:length(scenes_for_measure)
        s = scenes_for_measure(i);
        s_id = find(param.tmp.scenes_all == s);
        mkdir( directories_measurement1{s_id});
        if param.tmp.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest1 , filenames_proteinofinterest1{s_id,t} , directories_measurement1{s_id} , filenames_measurement1{s_id,t});
                hbar.iterate(1);
            end
        else
            for t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest1 , filenames_proteinofinterest1{s_id,t} , directories_measurement1{s_id} , filenames_measurement1{s_id,t});
                hbar.iterate(1);
            end
        end
    end
    close(hbar);
end
if flag_pi2 && size(filenames_proteinofinterest2,1) == length(scenes_for_measure) && size(filenames_proteinofinterest2,2) == param.tmp.n_time
    hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_measure) ,param.tmp.dir_proteinofinterest2 , '2nd step: quantification of Channel 3');
    if exist(param.tmp.dir_measurement2,'dir') == 7
        ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
        switch ButtonName
            case 'Yes'
                [status, message, messageid] = rmdir(param.tmp.dir_measurement2, 's');
            case 'Cancel'
                return;
            case ''
                return;
        end
    end
    for i = 1:length(scenes_for_measure)
        s = scenes_for_measure(i);
        s_id = find(param.tmp.scenes_all == s);
        mkdir( directories_measurement2{s_id});
        if param.tmp.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest2 , filenames_proteinofinterest2{s_id,t} , directories_measurement2{s_id} , filenames_measurement2{s_id,t});
                hbar.iterate(1);
            end
        else
            for t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest2 , filenames_proteinofinterest2{s_id,t} , directories_measurement2{s_id} , filenames_measurement2{s_id,t});
                hbar.iterate(1);
            end
        end
    end
    close(hbar);
end
if flag_pi3 && size(filenames_proteinofinterest3,1) == length(scenes_for_measure) && size(filenames_proteinofinterest3,2) == param.tmp.n_time
    if exist(param.tmp.dir_measurement3,'dir') == 7
        ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
        switch ButtonName
            case 'Yes'
                [status, message, messageid] = rmdir(param.tmp.dir_measurement3, 's');
            case 'Cancel'
                return;
            case ''
                return;
        end
    end
    hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_measure) ,param.tmp.dir_proteinofinterest3 , '2nd step: quantification of Channel 4');
    for i = 1:length(scenes_for_measure)
        s = scenes_for_measure(i);
        s_id = find(param.tmp.scenes_all == s);
        mkdir( directories_measurement3{s_id});
        if param.tmp.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest3 , filenames_proteinofinterest3{s_id,t} , directories_measurement3{s_id} , filenames_measurement3{s_id,t});
                hbar.iterate(1);
            end
        else
            for t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest3 , filenames_proteinofinterest3{s_id,t} , directories_measurement3{s_id} , filenames_measurement3{s_id,t});
                hbar.iterate(1);
            end
        end
    end
    close(hbar);
end
if flag_pi4 && size(filenames_proteinofinterest4,1) == length(scenes_for_measure) && size(filenames_proteinofinterest4,2) == param.tmp.n_time
    if exist(param.tmp.dir_measurement4,'dir') == 7
        ButtonName = questdlg('Results already exist. Overwrite existing results?', 'Question', 'Yes', 'Cancel', 'Cancel');
        switch ButtonName
            case 'Yes'
                [status, message, messageid] = rmdir(param.tmp.dir_measurement4, 's');
            case 'Cancel'
                return;
            case ''
                return;
        end
    end
    hbar = parfor_progressbar(param.tmp.n_time * length(scenes_for_measure) ,param.tmp.dir_proteinofinterest4 , '2nd step: quantification of Channel 5');
    for i = 1:length(scenes_for_measure)
        s = scenes_for_measure(i);
        s_id = find(param.tmp.scenes_all == s);
        mkdir( directories_measurement4{s_id});
        if param.tmp.processing_number_of_cores > 1
            parfor t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest4 , filenames_proteinofinterest4{s_id,t} , directories_measurement4{s_id} , filenames_measurement4{s_id,t});
                hbar.iterate(1);
            end
        else
            for t = 1:param.tmp.n_time
                execute_intensity_quantification( directories_label_measure{s_id} , filenames_label_measure{s_id,t} , dir_proteinofinterest4 , filenames_proteinofinterest4{s_id,t} , directories_measurement4{s_id} , filenames_measurement4{s_id,t});
                hbar.iterate(1);
            end
        end
    end
    close(hbar);
end
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