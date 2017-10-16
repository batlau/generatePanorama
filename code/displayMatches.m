function displayMatches(im1,im2,pos1,pos2,inliers)
% DISPLAYMATCHES Display matched pt. pairs overlayed on given image pair.
% Arguments:
% im1,im2 ? two grayscale images
% pos1,pos2 ? nx2 matrices containing n rows of [x,y] coordinates of matched
% points in im1 and im2 (i.e. the i’th match’s coordinate is
% pos1(i,:) in im1 and and pos2(i,:) in im2).
% inliers ? A kx1 vector of inlier matches (e.g. see output of
% ransacHomography.m)
row = max(size(im1, 1), size(im2, 1));
bothIm = zeros(row, size(im1, 2) + size(im2,2));
bothIm(:, 1:size(im1,2)) = im1;
bothIm(:, size(im1,2)+1:end) = im2;
outliers = setdiff(1:size(pos1, 1), inliers);
%calculating the new (x,y) coordinates of im2 in "bothIm"
newPos2 = [pos2(:,1)+size(im1,2) pos2(:,2)];
x = [pos1(inliers, 1) newPos2(inliers,1)].';
y = [pos1(inliers, 2) newPos2(inliers,2)].';
figure, imshow(bothIm); hold on;
%plot red dots with yellow lines between every pair of "matching" points
plot(pos1(:, 1), pos1(:, 2), 'r.');
plot(newPos2(:, 1), newPos2(:, 2), 'r.');
plot(x,y, 'y-');
%plot blue line between outlier pairs
plot([pos1(outliers, 1) newPos2(outliers,1)].', [pos1(outliers, 2) newPos2(outliers,2)].', 'b-');
hold off;