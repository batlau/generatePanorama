function [pyr, filter] = GaussianPyramid(im, maxLevels, filterSize)
pyr = cell(maxLevels, 1);
filter = createGausFilter(filterSize);
pyr{1} = im;
n = 2;
while ((n < (maxLevels + 1)) && (size(pyr{n - 1 ,1},1) > 16) && (size(pyr{n - 1 ,1},2) > 16))
    temp = conv2(double(pyr{n-1 ,1}), filter, 'same');
    temp = conv2(temp, filter.', 'same');
    %downsample
    subSample = temp(1:2:end, 1:2:end);
    pyr{n} = subSample;
    n = n + 1;
end
if n < maxLevels
    pyr = pyr(1:n - 1);
end