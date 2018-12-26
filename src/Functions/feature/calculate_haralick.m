% adapted from CellProfiler
function [ H ] = calculate_haralick( im, mask, Levels , offset )

[ys,xs] = find(mask);
im = im(min(ys):max(ys),min(xs):max(xs));
mask = mask(min(ys):max(ys),min(xs):max(xs));

im = double(im)/255;
BinEdges = linspace(0,1,Levels+1);
intensities = im(mask);
Imax = max(intensities);
Imin = min(intensities);
if Imax ~= Imin
    im = (im - Imin)/(Imax-Imin);
end

qim = zeros(size(im));
for k = 1:Levels
    qim(find(im >= BinEdges(k))) = k;
end

im1 = qim( max(1,1-offset(1)) : min(end,end-offset(1)) , max(1,1-offset(2)) : min(end,end-offset(2)) ); im1 = im1(:);
im2 = qim( max(1,1+offset(1)) : min(end,end+offset(1)) , max(1,1+offset(2)) : min(end,end+offset(2)) ); im2 = im2(:);
m1 = mask( max(1,1-offset(1)) : min(end,end-offset(1)) , max(1,1-offset(2)) : min(end,end-offset(2)) ); m1 = m1(:);
m2 = mask( max(1,1+offset(1)) : min(end,end+offset(1)) , max(1,1+offset(2)) : min(end,end+offset(2)) ); m2 = m2(:);

index = (sum([m1 m2],2) == 2);
if isempty(index)
    H = [0 0 0 0 0 0 0 0 0 0 0 0 0];
    return
end
im1 = im1(index);
im2 = im2(index);

P = full(sparse(im1,im2,1,Levels,Levels)); 
P = P/length(im1);

%%
px = sum(P,2);
py = sum(P,1);
mux = sum((1:Levels)'.*px);
muy = sum((1:Levels).*py);
sigmax = sqrt(sum(((1:Levels)' - mux).^2.*px));
sigmay = sqrt(sum(((1:Levels) - muy).^2.*py));
HX = -sum(px.*log(px+eps));
HY = -sum(py.*log(py+eps));
HXY = -sum(P(:).*log(P(:)+eps));
HXY1 = -sum(sum(P.*log(px*py+eps)));
HXY2 = -sum(sum(px*py .* log(px*py+eps)));

p_xplusy = zeros(2*Levels-1,1);      % Range 2:2*Levels
p_xminusy = zeros(Levels,1);         % Range 0:Levels-1
for x=1:Levels
    for y = 1:Levels
        p_xplusy(x+y-1) = p_xplusy(x+y-1) + P(x,y);
        p_xminusy(abs(x-y)+1) = p_xminusy(abs(x-y)+1) + P(x,y);
    end
end

%%
% H1. Angular Second Moment
H1 = sum(P(:).^2);

% H2. Contrast
H2 = sum((0:Levels-1)'.^2.*p_xminusy);

% H3. Correlation
H3 = (sum(sum((1:Levels)'*(1:Levels).*P)) - mux*muy)/(sigmax*sigmay);
if isinf(H3),
    H3 = 0;
end

% H4. Sum of Squares: Variation
H4 = sigmax^2;

% H5. Inverse Difference Moment
H5 = sum(sum(1./(1+toeplitz(0:Levels-1).^2).*P));

% H6. Sum Average
H6 = sum((2:2*Levels)'.*p_xplusy);

% H7. Sum Variance (error in Haralick's original paper here)
H7 = sum(((2:2*Levels)' - H6).^2 .* p_xplusy);

% H8. Sum Entropy
H8 = -sum(p_xplusy .* log(p_xplusy+eps));

% H9. Entropy
H9 = HXY;

% H10. Difference Variance
H10 = sum(p_xminusy.*((0:Levels-1)' - sum((0:Levels-1)'.*p_xminusy)).^2);

% H11. Difference Entropy
H11 = - sum(p_xminusy.*log(p_xminusy+eps));

% H12. Information Measure of Correlation 1
H12 = (HXY-HXY1)/max(HX,HY);

% H13. Information Measure of Correlation 2
H13 = real(sqrt(1-exp(-2*(HXY2-HXY))));             % An imaginary result has been encountered once, reason unclear

warning on MATLAB:DivideByZero

% H14. Max correlation coefficient (not currently used)
% Q = zeros(Levels);
% for i = 1:Levels
%     for j = 1:Levels
%         Q(i,j) = sum(P(i,:).*P(j,:)/(px(i)*py(j)));
%     end
% end
% [V,lambda] = eig(Q);
% lambda = sort(diag(lambda));
% H14 = sqrt(max(0,lambda(end-1)));

H = [H1 H2 H3 H4 H5 H6 H7 H8 H9 H10 H11 H12 H13];
H(isnan(H))=0;

end