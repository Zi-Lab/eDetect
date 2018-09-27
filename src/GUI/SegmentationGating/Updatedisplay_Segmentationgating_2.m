function param = Updatedisplay_Segmentationgating_2(param , flag , list)
directories_feature = param.tmp.directories_feature;
filenames_feature = param.tmp.filenames_feature;


fml = get(param.hNucleiSegmentationGating.Edit_formula,'String');
%%
if flag
    for k = 1:size(list,1)
        s = list(k,1);
        t = list(k,2);
        s_id = find(param.tmp.scenes_all == s);
        i = find(param.tmp.scenes_for_gating == s);
        if isempty(i)
            continue;
        end
        [newfeature , newlabel , output_flag] = calculate_segmentation_feature(directories_feature , filenames_feature , s,s_id ,t ,fml );
        if output_flag == -1
            return;
        end
        param.tmp.segmentation_gating_data_cell_array{t,i} = newfeature;
        param.tmp.segmentation_gating_labl_cell_array{t,i} = newlabel;
    end
else
    param.tmp.segmentation_gating_data_cell_array = cell([param.tmp.n_time , length(param.tmp.scenes_for_gating)]);
    param.tmp.segmentation_gating_labl_cell_array = cell([param.tmp.n_time , length(param.tmp.scenes_for_gating)]);
    for i = 1:length(param.tmp.scenes_for_gating)
        s = param.tmp.scenes_for_gating(i);
        s_id = find(param.tmp.scenes_all == s);
        for t = 1:param.tmp.n_time
            [newfeature , newlabel , output_flag] = calculate_segmentation_feature(directories_feature , filenames_feature ,s, s_id ,t ,fml );
            if output_flag == -1
                return;
            end
            param.tmp.segmentation_gating_data_cell_array{t,i} = newfeature;
            param.tmp.segmentation_gating_labl_cell_array{t,i} = newlabel;
        end
    end
end
nl1 = 0;
for i = 1:length(param.tmp.scenes_for_gating)
    for t = 1:param.tmp.n_time
        nl1 = nl1 + size(param.tmp.segmentation_gating_data_cell_array{t,i},1);
    end
end
data = NaN([nl1,size(newfeature,2)]);
param.tmp.label_segmentation_gating = NaN([nl1,size(newlabel,2)]);
nl2 = 0;
for i = 1:length(param.tmp.scenes_for_gating)
    for t = 1:param.tmp.n_time
        nl3 = size(param.tmp.segmentation_gating_data_cell_array{t,i},1);
        data(nl2+1:nl2+nl3,:) = param.tmp.segmentation_gating_data_cell_array{t,i};
        param.tmp.label_segmentation_gating(nl2+1:nl2+nl3,:) = param.tmp.segmentation_gating_labl_cell_array{t,i};
        nl2 = nl2+ nl3;
    end
end
%%
if ~isempty(data)
    if ~isempty(find(isnan(data(:)), 1))
        msgbox('There are NaN values in the feature matrix. They have been replaced by 0. Consider changing the Formula.','Error','error');
        data(isnan(data)) = 0;
    end
    if ~isempty(find(isinf(data(:)), 1))
        msgbox('There are Inf values in the feature matrix. They have been replaced by MATLAB realmax. Consider changing the Formula.','Error','error');
        data(data ==  Inf) =  realmax;
        data(data == -Inf) = -realmax;
    end
    flag_normalize = get(param.hNucleiSegmentationGating.Check_normalize,'value') == 1;
    if flag_normalize
        data = data - mean(data,1);
        data = data ./ std(data,1);
    end
end
%%
if size(data,2) == 1
    param.tmp.pc_segmentationgating = [data rand(size(data))];
elseif size(data,2) == 2
    param.tmp.pc_segmentationgating = data;
elseif size(data,1)<2
    param.tmp.pc_segmentationgating = data(:,1:2);
else
    data_cov = cov(data);
    if ~isempty(find(isnan(data_cov(:)), 1))
        msgbox('There are NaN values in the covariance matrix. They have been replaced by 0. Consider changing the Formula.','Error','error');
        data_cov(isnan(data_cov)) = 0;
    end
    if ~isempty(find(isinf(data_cov(:)), 1))
        msgbox('There are Inf values in the covariance matrix. They have been replaced by MATLAB realmax. Consider changing the Formula.','Error','error');
        data_cov(data_cov ==  Inf) =  realmax;
        data_cov(data_cov == -Inf) = -realmax;
    end
    [ W , ~ ] = eig(data_cov);
    W = W(:,end:-1:1);
    param.tmp.pc_segmentationgating = data * W(:,1:2);
end
%%
if ~isempty(param.tmp.pc_segmentationgating)
    coordinates = param.tmp.pc_segmentationgating;
    if ~isempty(find(isnan(coordinates(:)), 1))
        msgbox('There are NaN values in the PCA result. They have been replaced by 0. Consider changing the Formula.','Error','error');
        coordinates(isnan(coordinates)) = 0;
    end
    if ~isempty(find(isinf(coordinates(:)), 1))
        msgbox('There are Inf values in the PCA result. They have been replaced by MATLAB realmax. Consider changing the Formula.','Error','error');
        coordinates(coordinates ==  Inf) =  realmax;
        coordinates(coordinates == -Inf) = -realmax;
    end
    param.tmp.pc_segmentationgating = coordinates;
end
%%
param = Updatedisplay_Segmentationgating_1(param, flag , list);
end
%%
function [newfeature , newlabel , flag] = calculate_segmentation_feature(directories_feature , filenames_feature ,s, s_id ,t ,fml )
flag = 1;
newfeature = [];
feature_matrix = [];
file_dir = fullfile(directories_feature{s_id} , filenames_feature{s_id,t});
if exist(file_dir,'file') ~= 2
    flag = 0;
    return;
end
tempdata = load(file_dir);
%%
if isfield(tempdata,'feature_sha_value')
    feature_matrix = [feature_matrix tempdata.feature_sha_value];
end
if isfield(tempdata,'feature_coo_value')
    feature_matrix = [feature_matrix tempdata.feature_coo_value];
end
if isfield(tempdata,'feature_int_value')
    feature_matrix = [feature_matrix tempdata.feature_int_value];
end
if isfield(tempdata,'feature_zer_value')
    feature_matrix = [feature_matrix tempdata.feature_zer_value];
end
if isfield(tempdata,'feature_har_value')
    feature_matrix = [feature_matrix tempdata.feature_har_value];
end
if isfield(tempdata,'feature_add_value')
    feature_matrix = [feature_matrix tempdata.feature_add_value];
end
v = cell([1,size(feature_matrix,2)]);
for j = 1:size(feature_matrix,2)
    v{j} = feature_matrix(:,j);
end
try
    eval(['newfeature = [' fml '];']);
catch
    msgbox('Please specify the input for dimension reduction in the correct format.','Error','error');
    flag = -1;
    return;
end
if size(newfeature,2) ~= length(strfind(fml,','))+1
    msgbox('Please specify the input for dimension reduction in the correct format.','Error','error');
    flag = -1;
    return;
end
newlabel = [ zeros([size(feature_matrix,1),1])+s zeros([size(feature_matrix,1),1])+t  (1:size(feature_matrix,1))'  ];
newlabel = newlabel(~tempdata.feature_touch_border,:);
newfeature = newfeature(~tempdata.feature_touch_border,:);
end
