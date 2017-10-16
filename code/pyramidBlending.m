function imBlend = pyramidBlending(im1, im2, mask, maxLevels, filterSizeIm, filterSizeMask)
[lap1,filter] = LaplacianPyramid(im1, maxLevels, filterSizeIm);
lap2 = LaplacianPyramid(im2, maxLevels, filterSizeIm);
gausMask = GaussianPyramid(im2double(mask), maxLevels, filterSizeMask);
temp = cell(size(lap1));
for n = 1:size(temp)
   gausMask{n}(isnan(gausMask{n})) = 0;
   %applying gaussian mask on the image from the laplacian pyramid of the
   %first image, then applying the inverse of that mask on the laplacian of
   %image 2, then blending the two images by adding them one to the other
   temp{n} = gausMask{n}.*lap1{n} + (1-gausMask{n}).*lap2{n};
end
imBlend = LaplacianToImage(temp, filter, ones(size(temp)));
end

function img = LaplacianToImage(lpyr, filter, coeffMultVec)
%reconstructing an image based on it's laplacian pyramid.
temp = lpyr{end}*coeffMultVec(end);
for n = (size(lpyr)-1): -1: 1
    temp = expandLevel(temp, size(lpyr{n}), filter*2) + lpyr{n}*coeffMultVec(n);
end
img = temp;
end

function [pyr, filter] = LaplacianPyramid(im, maxLevels, filterSize)
%creates a laplacian pyramid- given a gaussian pyramid, every level in the
%laplacian pyr will be gaussian{i}-expand(gaussian{i+1}). The highest level
%of the pyramid is the smallest image, and is the same element in both the
%gaussian and laplacian.
[gaus, filter] = GaussianPyramid(im, maxLevels, filterSize);
pyr = cell(size(gaus));
pyr{end} = gaus{end};
pyr{end}(isnan(pyr{end})) = 0;
for n = (size(gaus, 1) - 1): -1:1
   expanded = expandLevel(gaus{n+1}, size(gaus{n}), filter*2);
   pyr{n}(isnan(pyr{n})) = 0;
   gaus{n}(isnan(gaus{n})) = 0;
   pyr{n} = gaus{n} - expanded;
end
end

function im = expandLevel(origIm, zerosSize, filter)
%insert the smaller image into an image 2 times larger than it, by
%inserting a pixel in every other pixel in the enlarged image. Then apply
%the filter to get a bigger image from the smaller one
im = zeros(zerosSize);
im(1:2:end, 1:2:end) = origIm;
im = conv2(im, filter, 'same');
im = conv2(im, filter .' ,'same');
end