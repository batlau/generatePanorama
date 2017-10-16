function [panorama, mask] = renderPanorama(im,H, mask)
% RENDERPANORAMA Renders a set of images into a combined panorama image.
% Arguments:
% im ? Cell array of n grayscale images.
% H ? Cell array of n 3x3 homography matrices transforming the ith image
% coordinates to the panorama image coordinates.
% Returns:
% panorama ? A grayscale panorama image composed of n vertical strips that
% were backwarped each from the relevant frame im{i} using homography H{i}
corners = cellfun(@(inIm) ([1,1; 1,size(inIm,2); size(inIm,1),1; size(inIm)]), im, 'UniformOutput', 0);
corners = cellfun(@(corners, hom) applyHomography([corners(:,2), corners(:,1)], hom), corners, H.', 'UniformOutput', 0);
corners = cell2mat(corners);
minCorn = floor(min(corners));
maxCorn = ceil(max(corners));
%now, the image range is between minCorn and maxCorn (as the main diagonal)
panorama = zeros((maxCorn(2)+ abs(minCorn(2)) + 1),(maxCorn(1)+ abs(minCorn(1))+1));
[xPano, yPano] = meshgrid(minCorn(1):maxCorn(1), minCorn(2):maxCorn(2));
%lowerMask = minCorn(1);
shiftX = 0;
if (nargin == 2)
    mask = cell(size(im,1));
end
if minCorn(1) < 0
    shiftX = abs(minCorn(1))+1;
end
for i = 1:(size(H, 2))
    lowerPic = min(corners((4*(i-1)+1):(4*i),:),[],1);
    upperPic = max(corners((4*(i-1)+1):(4*i),:),[],1);
    %adding in the current image/strip to the panorama- creating the strip
    %in a picture the size of the whole panorama then blending the panorama
    %and the strip
    stripToBlend = ceil(lowerPic:upperPic) + shiftX;
    wholePic = zeros(size(panorama));
    tempX = xPano(:, stripToBlend);
    tempY = yPano(:, stripToBlend);
    %calculating the coordinates
    coor = (applyHomography([tempX(:) tempY(:)],inv(H{i})));
    tempX(:) = coor(:,1);
    tempY(:) = coor(:,2);
    wholePic(:, stripToBlend) = interp2(im{i}, tempX, tempY);
    wholePic(isnan(wholePic)) = 0;
    if (i == 1)
        panorama = wholePic;
    else
        if (nargin == 2)
            mask{i} = getMinMask(panorama, wholePic, ...
                min([corners(4*(i-1)-2,:); corners(4*(i-1),:)],[],1),...
                max([corners(4*(i-1)+1,:); corners(4*(i-1)+3,:)],[],1),...
                shiftX-1);
        end
        panorama = pyramidBlending(panorama, wholePic, mask{i}, 10, 11, 11);
    end
end
panorama(isnan(panorama)) = 0;
end

%send two pics the size of the panorama to this function, will find minimal
%error, and create a mask for the blending. send the first and 3rd corner of the right pic
function mask = getMinMask(leftIm, rightIm, rightCorner, leftCorner, shift)
    mask = zeros(size(leftIm));
    leftCorner = floor(leftCorner);
    rightCorner = ceil(rightCorner);
    %the whole left portion of the image should have the same effect on the
    % end product- therefore it is all 1's from the left corner.
    mask(:, 1:(leftCorner(1)+shift)) = 1;
    overlapArea = (leftCorner(1):rightCorner(1)) + shift;
    overlap = leftIm(:, overlapArea)-rightIm(:, overlapArea);
    startPoint = floor(size(overlapArea,2)*0.05);
    if (startPoint <2)
        startPoint = 2;
    end
    %search for the best seam
    for i =	startPoint:max(rightCorner(2), leftCorner(2))
        overlap(i,1) = overlap(i,1) + min(overlap(i-1,1), overlap(i-1,2));
        for j = 2:size(overlap,2) -1
            overlap(i,j) = overlap(i,j) + min(overlap(i-1,j-1:j+1));
        end
        overlap(i,end) = overlap(i,end) + min(overlap(i-1,end-1), overlap(i-1,end));
    end
    %creating mask - entering 0/1 to the correct locations
    curMin = find(overlap(end, :) == min(overlap(end,:)), 1, 'first');
    overlap(i, 1:curMin) = 1;
    overlap(i, curMin:end) = 0;
    for i =	size(leftIm,1):-1:1
        oldMin = curMin;
        if (curMin ==1)
            curMin = find(overlap(i,curMin:curMin+1) == min([256 overlap(i,curMin:curMin+1)]), 1) + 1;
        elseif curMin == size(overlap,2)
                curMin = find(overlap(i,curMin-1:curMin) == min([overlap(i,curMin-1:curMin) 256]), 1);
        else
            curMin = find(overlap(i,curMin-1:curMin+1) == min(overlap(i,curMin-1:curMin+1)), 1);
        end
        if (curMin == 1)
            curMin = oldMin -1;
        elseif (curMin == 2)
            curMin = oldMin;
        else
            curMin = oldMin +1;
        end
        overlap(i, 1:curMin) = 1;
        overlap(i, curMin:end) = 0;
    end
    if (sum(sum(overlap == 1)) ==0)
        %if the dynamic stitching isn't needed
        whiteArea = floor((rightCorner(1) - leftCorner(1))/2) + shift;
        mask(:,1:leftCorner(1) + whiteArea) = 1;
    else
        mask(:,(leftCorner(1):rightCorner(1))+shift) = double(overlap);
    end
end