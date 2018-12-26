% from CellProfiler
function [ haralick , names] = calculate_feature_haralick( L , ImageData  )

offsets = [
    0 1;
    -1 1;
    -1 0;
    -1 -1;
    
    0 -1;
    1 -1;
    1 0;
    1 1
    ];

    labels = setdiff(unique(L(:)),0);
    ll = length( labels );
    haralick = zeros([ll,13*8]);
    for i = 1:ll
        for j = 1:8
            temp = zeros([ size(ImageData,1) , size(ImageData,2) ]) == 1;
            temp( L == labels(i) ) = true;
            haralick(i ,  ((j-1)*13+1) : (j*13) ) = calculate_haralick(ImageData , temp , 8 , offsets(j,:) );
        end
    end


str1 = {'asm','con','cor','var','idm','sav','sva','sen','ent','dva','den','f12','f13'};
str2 = 0:7;
names = cell([1,length(str1)*length(str2)]);
for i = 1:length(str1)
    for j = 1:length(str2)
        names{i+length(str1)*(j-1)} = [str1{i} '_' num2str(str2(j))];
    end
end

end

