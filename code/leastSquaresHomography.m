function H12 = leastSquaresHomography(pos1,pos2)
% LEASTSQUARESHOMOGRAPHY Compute least square fit to homography 
% transforming between two sets of points.
%
% Arguments:
% pos1,pos2 - Two nx2 matrices containing n rows of [x,y] coordinates of 
%   matched points.
%
% Returns:
% H12 - A normalized homography matrix that transforms the points pos1 as 
%   close as possible (in the least squares sense) to pos2. 
%
% Description:
% Denoting by [x1i,y1i] = pos1(i,:), by [x2,y2] = pos2(i,:), and by 
% [xtag1i,ytag1i] = H12(x1i,y1i), then H12 is the homography for which 
% sum_i[(xtag1i-x2i)^2+(ytag1i-y2i)^2] is minimal.

epsilon = 1e-10;
one = ones(size(pos1,1),1);
zer = 0*one;
x1 = pos1(:,1);
x2 = pos2(:,1);
y1 = pos1(:,2);
y2 = pos2(:,2);
A = [x1, zer, -x1.*x2, y1,  zer, -y1.*x2, one, zer;...
     zer,x1,  -x1.*y2, zer, y1,  -y1.*y2, zer, one];
if size(A,1) == 8
  %if the computation of the inverse of A is prone to many mistakes, the
  %rcond will be very low, therefore we will return an empty homography
  if rcond(A) < epsilon
    H12 = [];
    return;
  end
end
H12 = A\[x2;y2]; %solving the system: A*H12 = [x2;y2], here H12 is a vector
H12(end+1) = 1; %add z coordinate
H12 = reshape(H12,[3,3]); %return a 3*3 matrix
