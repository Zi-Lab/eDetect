function [ I_out ] = print_number( I , N , pos , color)
I_out = I;
n = length(N);
load('numbers.mat');
[H , W , C] = size(I_out);
for i = 1:n
    digits = num2str(N(i))*1-'0';
    mas = [];
    for k = 1:length(digits)
        mas = [ mas , numbers(:,:,digits(k)+1)];
    end
    [h , w] = size(mas);
    h_max = min(pos(i,1)+h-1,H);
    w_max = min(pos(i,2)+w-1,W);
    h_min = max(h_max-h+1,1);
    w_min = max(w_max-w+1,1);
    h_range = h_min:(h_min+h-1);
    w_range = w_min:(w_min+w-1);
    if C==1 && ~strcmp(color,'white') && ~strcmp(color,'black') 
        I_out = cat(3,I_out,I_out,I_out);
    end
    I_out( h_range , w_range , : ) = overlay_outline( I_out( h_range , w_range , : ) ,  mas==1 , color );
end
end

