function [ output ] = my_quantile( vec , q )
if (size(vec,1)>1 && size(vec,2)>1) || isempty(vec)
    output = NaN;
    return;
end
if q < 0
    q = 0;
elseif q > 1
    q = 1;
end
l = length(vec);
vec_ = sort(vec);
output = vec_( round( 1+(l-1)*q ) );
end

