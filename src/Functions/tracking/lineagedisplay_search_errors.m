function [ errors ] = lineagedisplay_search_errors( diff , lines , cutoff)
newlines = lines(~isnan(lines(:,5)),:);
n = size(newlines,1);
table = NaN([0,5]);
for i = 1:n
    table = [table ; (newlines(i,5):1:newlines(i,6)-1)' , (newlines(i,5)+1:1:newlines(i,6))' , repmat([newlines(i,3) newlines(i,4)],[newlines(i,6)-newlines(i,5) 1]) , diff(newlines(i,7),newlines(i,5)+1:newlines(i,6))'];
end
table = table(~isnan(table(:,5)),:);
id_outliers = is_outlier(table(:,5), cutoff);
errors = table(id_outliers,1:4);
end

