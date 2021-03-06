function [pos,desc] = findFeatures(pyr)
% FINDFEATURES Detect feature points in pyramid and sample their descriptors.
% This function should call the functions spreadOutCorners for getting the keypoints, and
% sampleDescriptor for sampling a descriptor for each keypoint
% Arguments:
% pyr ? Gaussian pyramid of a grayscale image having 3 levels.
% Returns:
% pos ? An Nx2 matrix of [x,y] feature positions per row found in pyr. These
% coordinates are provided at the pyramid level pyr{1}.
% desc ? A kxkxN feature descriptor matrix.
pos = spreadOutCorners(pyr{1}, 7, 7, 3);
subPos = pos;
%converting the positions to coordinates in level 3 of pyramid.
subPos = ((2^-2) .* (subPos-1)) + 1;
desc = sampleDescriptor(pyr{3}, subPos, 3);