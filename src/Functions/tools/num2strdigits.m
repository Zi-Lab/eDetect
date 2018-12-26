function [ x_str ] = num2strdigits( x , n)
x_str = num2str(x);
for i = 1:(n-1)
    if x < 10^i
        x_str = ['0' x_str];
    end
end
end

