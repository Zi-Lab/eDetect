function [ DL , ADJ ] = nuclei_segmentation_adaptive_thresholding_1( I , param_seg , medfilt2size , gaufilt2size , gaufilt2sigm , sensitivity , max_depth , max_runtime , declump , merge)
I0 = I;
[h,w] = size(I0);
I0 = medfilt2(I0,'symmetric',[medfilt2size medfilt2size]);
I0 = imgaussfilt(I0,gaufilt2sigm,'FilterSize',gaufilt2size);
I1 = I0 - min(I0(:));
%%
rad_min = param_seg.min_object/2;
rad_med = param_seg.med_object/2;
rad_max = param_seg.max_object/2;
siz = floor( rad_med / 2 );
smin = floor( pi * rad_min^2 );
smax = floor( pi * rad_max^2);
%%
levels = cell([6,1]);
BWs = false([h,w,6]);
levels{1} = adaptthresh(I1 , sensitivity , 'NeighborhoodSize' , 2*floor(0.5*siz)+1 , 'Statistic' , 'gaussian');
BWs(:,:,1) = imbinarize(I1 , levels{1});
levels{2} = adaptthresh(I1 , sensitivity , 'NeighborhoodSize' , 2*siz+1            , 'Statistic' , 'gaussian');
BWs(:,:,2) = imbinarize(I1 , levels{2});
levels{3} = adaptthresh(I1 , sensitivity , 'NeighborhoodSize' , 2*floor(1.5*siz)+1 , 'Statistic' , 'gaussian');
BWs(:,:,3) = imbinarize(I1 , levels{3});
levels{4} = adaptthresh(I1 , sensitivity , 'NeighborhoodSize' , 4*siz+1            , 'Statistic' , 'mean');
BWs(:,:,4) = imbinarize(I1 , levels{4});
levels{5} = adaptthresh(I1 , sensitivity , 'NeighborhoodSize' , 6*siz+1            , 'Statistic' , 'mean');
BWs(:,:,5) = imbinarize(I1 , levels{5});
levels{6} = adaptthresh(I1 , sensitivity , 'NeighborhoodSize' , 8*siz+1            , 'Statistic' , 'mean');
BWs(:,:,6) = imbinarize(I1 , levels{6});
%%
BW1 = any(BWs,3);
%nbh1 = [0 1 0 ; 1 1 1 ; 0 1 0] > 0;
nbh2 = [ 0 1 1 1 0 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 0 1 1 1 0 ] > 0;
%se1 = strel('arbitrary',nbh1);
se2 = strel('arbitrary',nbh2);
BW2 = imopen(BW1,se2);
BW3 = bwareaopen(BW2,smin);
BW4 = imclose(BW3,se2);
BW5 = imfill(BW4,'holes');
%%
%%
if declump
    FG = BW5 > 0;
    D0 = bwdist(~FG);
    tolerance = 0.5;
    out2 = imhmax(D0,tolerance);
    D0 = -out2;
    D0(~FG) = Inf;
    D1 = watershed(D0);
    D1(~FG) = 0;
    BW6 = D1 > 0;
    BW7 = BW6 - bwareaopen(BW6, smax);
    DL_ = bwlabel(BW7);
    if max(DL_(:)) > 255
        DL_ = uint16(DL_);
    else
        DL_ = uint8(DL_);
    end
    [ADJ_] = adjacency_calculate(DL_ );
    if merge
        [ DL , ADJ ] = merge_oversegmented_objects_ellipsoid(  DL_ , ADJ_ , smax , max_depth , max_runtime);
    else
        DL = DL_;
        ADJ = ADJ_;
    end
else
    BW6 = BW5 - bwareaopen(BW5, smax);
    DL = bwlabel(BW6);
    if max(DL(:)) > 255
        DL = uint16(DL);
    else
        DL = uint8(DL);
    end
    ADJ = adjacency_calculate(DL );
end
end