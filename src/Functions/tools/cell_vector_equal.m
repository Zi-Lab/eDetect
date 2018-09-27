function [ eq ] = cell_vector_equal( cell1 , cell2 )
eq = true;
if length(cell1) ~= length(cell2)
    eq = false;
    return;
end
l = length(cell1);
%
first1 = zeros([l,1]);
first2 = zeros([l,1]);
for i = 1:l
    first1(i) = cell1{i}(1);
    first2(i) = cell2{i}(1);
end
[~,id1] = sort(first1);
[~,id2] = sort(first2);
for i = 1:l
    if ~isequal(cell1{id1(i)},cell2{id2(i)})
        eq = false;
        return;
    end
end
end