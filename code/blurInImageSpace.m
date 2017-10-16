%given an odd number and an image, creates an approximation of a gaussian
%filter, and blurs the image using it.
function blurImage = blurInImageSpace(inImage,kernelSize)
gausKer = [1 1];
for n = 1:kernelSize - 2;
    gausKer = conv2(gausKer, [1 1]);
end
if kernelSize ~= 1
    gausKer = conv2(gausKer, gausKer');
end
gausKer = gausKer / sum(sum(gausKer));
blurImage = conv2(inImage, gausKer, 'same');