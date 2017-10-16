function [H12,inliers] = ransacHomography(pos1,pos2,numIters,inlierTol)
% RANSACHOMOGRAPHY Fit homography to maximal inliers given point matches
% using the RANSAC algorithm.
% Arguments:
% pos1,pos2 ? Two nx2 matrices containing n rows of [x,y] coordinates of
% matched points.
% numIters ? Number of RANSAC iterations to perform.
% inlierTol ? inlier tolerance threshold.
% Returns:
% H12 ? A 3x3 normalized homography matrix.
% inliers ? A kx1 vector where k is the number of inliers, containing the indices in pos1/pos2 of the maximal set of
% inlier matches found.
bestScore = 0;
bestSet = 0;
for i = 1:numIters
    %randomly pick 4 matched pairs.
    j = randperm(size(pos1,1),4);
    %use leastSquaresHomography to compute homography based on the 4 random
    %pairs picked
    curHomography = leastSquaresHomography(pos1(j, :), pos2(j,:));
    if isempty(curHomography) 
        continue;
    end
    %transform all of p1->p1' (using apply homgraphy)
    tempP1 = applyHomography(pos1,curHomography);
    %calculate the score of this homography by computing:
    %ei,j = ||p1' - p1||^2 sum(ei,j) < inlierTol
    temp = (tempP1 - pos2);
    tempInliers = sum(temp.^2, 2) < inlierTol;
    temp = sum(tempInliers);
    if (bestScore < temp)
        bestScore = temp;
        bestSet = find(tempInliers);
    end
end
if bestSet == 0
    display('no match that fits all demands, returning null');
    H12 = 0;
    inliers = 0;
    return;
else
    % calculate the homography with the best score, based on more points
    H12 = leastSquaresHomography(pos1(bestSet, :), pos2(bestSet, :));
    H12 = H12/H12(3,3); %normalize
    inliers = bestSet;
end