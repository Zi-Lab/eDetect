function [ DLrgb2_text ] = label2text( DL2 , color)
DLrgb2 = label2rgb(DL2 , 'spring' , 'c' , 'shuffle');
labels = setdiff(unique(DL2),0);
l = length(labels);
pos = zeros(l,2);
for i = 1:l
    [ys,xs] = find(DL2 == labels(i));
    pos(i,:) = round(mean([ys,xs],1));
end
DLrgb2_text = print_number(DLrgb2 , labels , pos , color);
end

