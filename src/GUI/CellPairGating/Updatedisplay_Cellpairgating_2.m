function param = Updatedisplay_Cellpairgating_2(param , flag , list)
directory_track = param.tmp.dir_lineage;
filenames_track = param.tmp.filenames_track;
directories_feature = param.tmp.directories_feature;
filenames_feature = param.tmp.filenames_feature;
fml = get(param.hNucleiCellpairGating.Edit_formula,'String');
%%
if flag
    for k = 1:size(list,1)
        s = list(k,1);
        t = list(k,2);
        if t > param.tmp.n_time || t < 1
            continue;
        end
        s_id = find(param.tmp.scenes_all == s);
        i = find(param.tmp.scenes_for_gating == s);
        if isempty(i)
            continue;
        end
        path = fullfile(directory_track, filenames_track{s_id});
        if exist(path,'file')==2
            temp_track = load(path);
        else
            continue;
        end
        [newfeature ,newlabel, output_flag] = calculate_cellpair_feature(directories_feature , filenames_feature , s,s_id , t , fml , temp_track);
        if output_flag == -1
            return;
        end
        param.tmp.pair_gating_data_cell_array{t,i} = newfeature;
        param.tmp.pair_gating_labl_cell_array{t,i} = newlabel;
    end
else
    param.tmp.pair_gating_data_cell_array = cell([param.tmp.n_time , length(param.tmp.scenes_for_gating)]);
    param.tmp.pair_gating_labl_cell_array = cell([param.tmp.n_time , length(param.tmp.scenes_for_gating)]);
    for i = 1:length(param.tmp.scenes_for_gating)
        s = param.tmp.scenes_for_gating(i);
        s_id = find(param.tmp.scenes_all == s);
        path = fullfile(directory_track, filenames_track{s_id});
        if exist(path,'file')==2
            temp_track = load(path);
        else
            continue;
        end
        for t = 1:param.tmp.n_time
            [newfeature ,newlabel, output_flag] = calculate_cellpair_feature(directories_feature , filenames_feature , s,s_id , t , fml , temp_track);
            if output_flag == -1
                return;
            end
            param.tmp.pair_gating_data_cell_array{t,i} = newfeature;
            param.tmp.pair_gating_labl_cell_array{t,i} = newlabel;
        end
    end
end
%%
nl1 = 0;
for i = 1:length(param.tmp.scenes_for_gating)
    for t = 1:param.tmp.n_time
        nl1 = nl1 + size(param.tmp.pair_gating_data_cell_array{t,i},1);
    end
end
data = NaN([nl1,size(newfeature,2)]);
param.tmp.label_cellpair_gating = NaN([nl1,size(newlabel,2)]);
nl2 = 0;
for i = 1:length(param.tmp.scenes_for_gating)
    for t = 1:param.tmp.n_time
        nl3 = size(param.tmp.pair_gating_data_cell_array{t,i},1);
        data(nl2+1:nl2+nl3,:) = param.tmp.pair_gating_data_cell_array{t,i};
        param.tmp.label_cellpair_gating(nl2+1:nl2+nl3,:) = param.tmp.pair_gating_labl_cell_array{t,i};
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
    flag_normalize = get(param.hNucleiCellpairGating.Check_normalize,'value') == 1;
    if flag_normalize
        data = data - mean(data,1);
        data = data ./ std(data,1);
    end
end
%%
if size(data,2) == 1
    param.tmp.pc_cellpairgating = [data rand(size(data))];
elseif size(data,2) == 2
    param.tmp.pc_cellpairgating = data;
elseif size(data,1)<2
    param.tmp.pc_cellpairgating = data(:,1:2);
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
    param.tmp.pc_cellpairgating = data * W(:,1:2);
end
%%
if ~isempty(param.tmp.pc_cellpairgating)
    coordinates = param.tmp.pc_cellpairgating;
    if ~isempty(find(isnan(coordinates(:)), 1))
        msgbox('There are NaN values in the PCA result. They have been replaced by 0. Consider changing the Formula.','Error','error');
        coordinates(isnan(coordinates)) = 0;
    end
    if ~isempty(find(isinf(coordinates(:)), 1))
        msgbox('There are Inf values in the PCA result. They have been replaced by MATLAB realmax. Consider changing the Formula.','Error','error');
        coordinates(coordinates ==  Inf) =  realmax;
        coordinates(coordinates == -Inf) = -realmax;
    end
    param.tmp.pc_cellpairgating = coordinates;
end
%%
param.tmp.cellpair_gating_selected = false([size(param.tmp.pc_cellpairgating,1),1]);
param = Updatedisplay_Cellpairgating_0(param);
end
%%
function [newfeature,  newlabel, flag] = calculate_cellpair_feature(directories_feature , filenames_feature ,s, s_id ,t ,fml ,temp_track)
flag = 1;
newfeature = [];
feature_matrix = [];
file_dir = fullfile(directories_feature{s_id}, filenames_feature{s_id,t});
if exist(file_dir,'file') ~= 2
    flag = 0;
    return;
end
tempdata = load(file_dir);        
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
%%
coo = tempdata.feature_coo_value;
sha = tempdata.feature_sha_value;
l1 = size(coo,1);
m1 = repmat(coo,[1,1,l1]);
m2 = permute(m1,[3,2,1]);
m1 = permute(m1,[1,3,2]);
m2 = permute(m2,[1,3,2]);
dist = sqrt(sum((m1 - m2).^2,3));
%
A = temp_track.track{t};
mat = repmat(A,[1,l1]);
try
    [s1 , s2] = find(mat == mat');
catch
    msgbox('Results of cell tracking and feature extraction are not compatible. A possible reason is cell segmentation and feature extraction has been re-run after manual correction of segmentation and tracking. A solution is to re-run cell tracking.','Error');
    flag = -1;
    return;
end
pairs = [s1 s2];
if isempty(pairs)
    flag = 0;
    return;
end
f1 = s1 < s2;
f2 = A(s1) ~= 0;
pairs = pairs(f1 & f2 , : );
l2 = size(pairs,1);
%
feature1 = NaN([l2,1]);
for j = 1:l2
    feature1(j) = dist(pairs(j,1),pairs(j,2)) ./ sqrt( sha(pairs(j,1),7) * sha(pairs(j,2),7) );
end
%
feature2 = abs(sha(pairs(:,1),5) - sha(pairs(:,2),5));
feature2 = min([feature2 , 180 - feature2],[],2);
%
feature3_temp = coo(pairs(:,2),:) - coo(pairs(:,1),:);
feature3_temp = 180 / pi * atan(- feature3_temp(:,1) ./ feature3_temp(:,2));
feature3_temp_1 = abs(sha(pairs(:,1),5) - feature3_temp);
feature3_temp_1 = min([feature3_temp_1 , 180 - feature3_temp_1],[],2);
feature3_temp_2 = abs(sha(pairs(:,2),5) - feature3_temp);
feature3_temp_2 = min([feature3_temp_2 , 180 - feature3_temp_2],[],2);
feature3 = sort([feature3_temp_1 feature3_temp_2] , 2);
%%
v = cell( [ 1 , size(feature_matrix,2) ] );
for j = 1:size(feature_matrix,2)
     tmp = cat( 3 , feature_matrix(pairs(:,1),j) , feature_matrix(pairs(:,2),j) );
     tmp = sort(tmp,3);
     v{j} = [tmp(:,:,1) tmp(:,:,2)];
end
%%
try
    eval(['newfeature = [  feature2 , feature3 , ' fml '];']);
catch
    msgbox('Please specify the input for dimension reduction in the correct format.','Error','error');
    flag = -1;
    return;
end
if size(newfeature,2) ~= 2*length(strfind(fml,','))+2+3
    msgbox('Please specify the input for dimension reduction in the correct format.','Error','error');
    flag = -1;
    return;
end
newlabel = [ zeros([l2,1])+s , zeros([l2,1])+t , (1:l2)' , pairs ] ;
end