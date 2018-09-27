function [ prediction ] = track_nuclei(info , coo , tbd , max_displacement , max_deviation)
nt = length(coo);
prediction = cell([nt,1]);
prediction{1} = zeros([size(coo{1},1),1]);
for i = 2:nt
    [ prediction{i} ] = track_frame_linking( i , prediction , info(i-1:i) , coo(i-1:i) , tbd(i-1:i) , max_displacement , max_deviation);
end
end
