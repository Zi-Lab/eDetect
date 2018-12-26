function [ idset ] = image_xy_2_id(  ys , xs , H )
idset = (xs-1) * H + ys;
end