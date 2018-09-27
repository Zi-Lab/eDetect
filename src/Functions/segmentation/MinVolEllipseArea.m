function [ area ] = MinVolEllipseArea( I0 )
tol = 0.05;
I1 = bwmorph(I0,'shrink',2);
I2 = I0 & ~I1;
[y0 , x0] = find(I2);
[A , ~] = MinVolEllipse([y0 x0]', tol);
area = pi / sqrt(det(A));
end

