function [ I_out ] = overlay_outline( I_in ,  outline , color )
I_out = I_in;
c = size( I_in , 3 );
if c == 1
    if strcmp(color , 'black')
        I_out(outline) = 0;
    elseif strcmp(color , 'white')
        I_out(outline) = intmax(class(I_in));
    else
        I_out1 = I_out;
        I_out2 = I_out;
        I_out3 = I_out;
        if strcmp(color , 'red')
            I_out1(outline) = intmax(class(I_in));
            I_out2(outline) = 0;
            I_out3(outline) = 0;
            I_out = cat(3,I_out1,I_out2,I_out3);
        elseif strcmp(color , 'green')
            I_out1(outline) = 0;
            I_out2(outline) = intmax(class(I_in));
            I_out3(outline) = 0;
            I_out = cat(3,I_out1,I_out2,I_out3);
        elseif strcmp(color , 'blue')
            I_out1(outline) = 0;
            I_out2(outline) = 0;
            I_out3(outline) = intmax(class(I_in));
            I_out = cat(3,I_out1,I_out2,I_out3);
        end
    end
elseif c==3
    I_out1 = I_out(:,:,1);
    I_out2 = I_out(:,:,2);
    I_out3 = I_out(:,:,3);
    if strcmp(color , 'black')
        I_out1(outline) = 0;
        I_out2(outline) = 0;
        I_out3(outline) = 0;
        I_out = cat(3,I_out1,I_out2,I_out3);
    elseif strcmp(color , 'white')
        I_out1(outline) = intmax(class(I_in));
        I_out2(outline) = intmax(class(I_in));
        I_out3(outline) = intmax(class(I_in));
        I_out = cat(3,I_out1,I_out2,I_out3);
    elseif strcmp(color , 'red')
        I_out1(outline) = intmax(class(I_in));
        I_out2(outline) = 0;
        I_out3(outline) = 0;
        I_out = cat(3,I_out1,I_out2,I_out3);
    elseif strcmp(color , 'green')
        I_out1(outline) = 0;
        I_out2(outline) = intmax(class(I_in));
        I_out3(outline) = 0;
        I_out = cat(3,I_out1,I_out2,I_out3);
    elseif strcmp(color , 'blue')
        I_out1(outline) = 0;
        I_out2(outline) = 0;
        I_out3(outline) = intmax(class(I_in));
        I_out = cat(3,I_out1,I_out2,I_out3);
    end
end

end

