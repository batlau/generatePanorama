function [ind1,ind2] = matchFeatures(desc1,desc2,minScore)
% MATCHFEATURES Match feature descriptors in desc1 and desc2.
% Arguments:
% desc1 ? A kxkxn1 feature descriptor matrix.
% desc2 ? A kxkxn2 feature descriptor matrix.
% minScore ? Minimal match score between two descriptors required to be
% regarded as matching.
% Returns:
% ind1,ind2 ? These are m-entry arrays of match indices in desc1 and desc2.
%
% Note:
% 1. The descriptors of the ith match are desc1(ind1(i)) and desc2(ind2(i)).
% 2. The number of feature descriptors n1 generally differs from n2
% 3. ind1 and ind2 have the same length.
n1 = size(desc1,3);
n2 = size(desc2,3);
k = size(desc2,1);
%flatten descriptors
tempDesc1 = reshape(desc1, k^2, n1);
tempDesc2 = reshape(desc2, k^2, n2);
%finding the best matches- the higher the dot product is, the better the
%match
s = tempDesc1.' * tempDesc2;
sortedCols = sort(s, 1);
sortedRows = sort(s, 2);
%create matrix for thresholding
colMax = sortedCols(end-1, :);
colMax = repmat(colMax,size(s,1), 1);
rowMax = sortedRows(:, end-1);
rowMax = repmat(rowMax, 1, size(s,2));
%set all cells to 0 except the cells which are the best match and are over
%the given threshold
s = (s>=rowMax) & (s>=colMax) & (s>=minScore);
[ind1, ind2] = find(s == 1);
