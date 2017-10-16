function pos = HarrisCornerDetector( im )
% HARRISCORNERDETECTOR Extract key points from the image.
% Arguments:
% im ? nxm grayscale image to find key points inside.
% pos ? A nx2 matrix of [x,y] key points positions in im.
ix = conv2(im, [1 0 -1], 'same');
iy = conv2(im, [1; 0; -1], 'same');
ix2 = blurInImageSpace(ix .* ix, 3);
iy2 = blurInImageSpace(iy .* iy, 3);
ixIy = blurInImageSpace(ix .* iy, 3);
r = ((ix2 .* iy2) - (ixIy.^2)) - 0.04*((ix2 + iy2) .^ 2);
r = nonMaximumSuppression(r);
[row, col] = find(r == 1);
pos = [col, row];