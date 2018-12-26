function [ cell_matrix_new ] = update_ids( cell_matrix, to_update )
cell_matrix_new = cell_matrix;
[h , w] = size(cell_matrix_new);
list = sort(to_update , 'descend');
target = list(end);
del = list(1:(end-1));
for i = 1:h
    for j = 1:w
        for k = 1:length(del)
            cell_matrix_new{i,j}(cell_matrix_new{i,j} == del(k)) = target;
            for l = (del(k) + 1):max(max(cell_matrix_new{i,j}))
                cell_matrix_new{i,j}(cell_matrix_new{i,j}==l) = l-1;
            end
        end
        
    end
end
end

