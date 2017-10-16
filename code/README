To see this project create the 2 panoramas, run "myPanorama.m".

myPanorama.m uses two sequences of pictures, attached in the data directory, to create a panorama.
In addition, myPanorama creates a panorama from a sequence that contains a parallax, therefore
 if I was to use regular stitching the image would return a faulty panorama with a double appearance
of the elf (the regular stitching appears in the output folder ("paralax_regular_stitch")).
My dynamic stitching eliminated that parallax.

For every sequence, I found the overlap between every two consecutive images, calculated the dynamic 
cut, and returned that mask. This calculation was done on the grayscale images, then later the mask
that was calculated was used on each channel of the colorful images.
When I found that there was no parallax, i.e - there was no need in dynamic stitching, I returned
the regular mask- the middle between the two centers (approximately).

This repository contains the following files:
accumulateHomographies.m - A function that given an index and a cell array of homographies - 
                        creates a new cell that for every image has the cumulative homography
                        towards the given index.
applyHomography.m - A function that given coordinates in the normal version (x,y) - converts
                them to (x,y,z), computes homography and returns to normal form.
blurInImageSpace.m - A function that blurs (Gaussian blur) an image (in image space).
createGausFilter.m - A helper function for the gaussian pyramid- that creates a gaussian filter.
createPan.m - A function that is called by the myPanorama script, reads and image, calculates
	      whatever is needed in order to create a panorama, then creates one and saves it.
displayMatches.m - A function that given two images, two positions and inliers- displays the 
                matched pairs of points(in yellow), and the outliers (in blue)
findFeatures.m - A function that finds feature points, and samples their descriptors, using the 
                relevant functions in order to do so.
GaussianPyramid.m - A function that creates a Gaussian pyramid with at most n levels.
HarrisCornerDetector.m - A function that detects edges in a given image.
imReadAndConvert.m - A function that reads an image into a specified format (grayscale or rgb).
leastSquaresHomography.m - A function not written by me, provided by the staff of the image processing course in which
			this exercise was done.
matchFeatures.m - A function that finds the best match for every feature in the two pictures, and
                accepts a match only under certain demands.
myPanorama.m - A function that runs and creates my two examples of panorama images.
nonMaximumSuppresion.m - A function not written by me, provided by the staff of the image processing course in which
			this exercise was done.
pyramidBlending.m - A function that belnds two images, using a laplacian pyramid.
ransacHomography.m - A function that finds the correct homography (hopefully)- using the random
                        sampling consensus (ransac) algorithm.
sampleDescriptor.m - A function that creates a MOPS like descriptor for every given positions.
spreadOutCorners.m - A function not written by me, provided by the staff of the image processing course in which
			this exercise was done.
