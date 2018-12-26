function [ UpdatedLabels  ] = track_frame_linking(id , prediction , info , coordinate , touch_border , max_displacement , max_shift , include_border_object)
UpdatedLabels = zeros([0,1]);
if id == 1
    UpdatedLabels = zeros([size(coordinate{2},1),1]);
    return;
end
if isempty(coordinate{1}) || isempty(coordinate{2})
    return;
end
%%
coordinate1 = coordinate{1};
coordinate2 = coordinate{2};
l1 = size(coordinate1,1);
l2 = size(coordinate2,1);
m1 = repmat(coordinate1,[1 1 l2]);
m2 = repmat(permute(coordinate2,[3 2 1]),[l1 1 1]);
%%
options = optimoptions('fmincon','Display','off');
if max_shift == 0
    x = [0 0];
else
    x = fmincon(@(x)calculate_cost_distances(x, m1 , m2 , max_displacement) , [0 0] , [],[],[],[] , [-max_shift,-max_shift] , [max_shift,max_shift],[],options);
end
m2_ = m2 + x;
%%
distances = permute(sqrt(sum((m1-m2_).^2,2)),[1 3 2]);
distances = padarray(distances,[1,0],max_displacement,'post');
[Y , I]  = min(distances , [] , 1);
I(I == l1+1) = 0;
UpdatedLabels = I(1:l2);
UpdatedLabels = UpdatedLabels';
for i = 1:length(UpdatedLabels)
    if UpdatedLabels(i) > 0
        if include_border_object
            if ismember(i , info{2}.erroneous) || ismember(UpdatedLabels(i) , info{1}.erroneous)
                UpdatedLabels(i) = 0;
            end
        else
            if ismember(i , info{2}.erroneous) || ismember(UpdatedLabels(i) , info{1}.erroneous) || touch_border{2}(i) || touch_border{1}(UpdatedLabels(i))
                UpdatedLabels(i) = 0;
            end
        end
    end
end
end
%%
function cost = calculate_cost_distances(vec, m1 , m2 , reject)
m2_ = m2 + vec;
distances = permute(sqrt(sum((m1-m2_).^2,2)),[1 3 2]);
distances = padarray(distances,[1,0] , reject , 'post');
[Y , I]  = min(distances , [] , 1);
cost = sum(Y);
end