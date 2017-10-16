function pan = createPan(picName, numOfPics, displayMatches)
    im = cell(numOfPics,1);
    redIm = cell(numOfPics,1);
    greenIm = cell(numOfPics,1);
    blueIm = cell(numOfPics,1);
    for i = 1:numOfPics
        toRead = strcat('../data/inp/', picName,int2str(i),'.jpg');
        temp = imReadAndConvert(toRead,2);
        redIm{i} = temp(:,:,1);
        greenIm{i} = temp(:,:,2);
        blueIm{i} = temp(:,:,3);
        im{i} = rgb2gray(temp);
    end
    homs = cell(numOfPics-1, 1);
    %calculating homography 1 -> 2
    for i = 1:(numOfPics-1)
        %getting descriptors from both images
        [pos1, desc1] = findFeatures(GaussianPyramid(im{i}, 3, 3));
        [pos2, desc2] = findFeatures(GaussianPyramid(im{i+1}, 3, 3));
        [ind1, ind2] = matchFeatures(desc1,desc2,0.3);
        %calculating homography using RANSAC
        [H12, inlind1] = ransacHomography(pos1(ind1, :), pos2(ind2,:), 1500, 9);
        homs{i} = H12;
        if (displayMatches)
            displayMatches(im{i}, im{i+1}, pos1(ind1,:), pos2(ind2,:), inlind1);
        end
    end
    m = ceil(numOfPics/2);
    htot = accumulateHomographies(homs, m);
    [~, mask] = renderPanorama(im, htot);
    pan(:,:,1) = renderPanorama(redIm, htot, mask);
    pan(:,:,2) = renderPanorama(greenIm, htot, mask);
    pan(:,:,3) = renderPanorama(blueIm, htot, mask);
    outPath = strcat('../data/out/', picName,'.jpg');
    imwrite(pan,outPath,'Quality',93);
end

