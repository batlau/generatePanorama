function desc = sampleDescriptor(im,pos,descRad)
% SAMPLEDESCRIPTOR Sample a MOPS?like descriptor at given positions in the image.
% Arguments:
% im ? nxm grayscale image to sample within.
% pos ? A Nx2 matrix of [x,y] descriptor positions in im.
% descRad ? ”Radius” of descriptors to compute (see below).
% Returns:
% desc ? A kxkxN 3?d matrix containing the ith descriptor
% at desc(:,:,i). The per?descriptor dimensions kxk are related to the
% descRad argument as follows k = 1+2*descRad.
rad = descRad +0.5;
%creating a matrix that will contain the N descriptors
desc = zeros(rad*2, rad*2, size(pos,1));
for i = 1:size(pos,1)
    %getting coordinates for descriptor
   xq = (pos(i, 1)-rad) : (pos(i, 1) + rad-1);
   yq = (pos(i, 2)-rad : pos(i, 2) + rad-1).';
   temp = interp2(im, xq, yq);
   %normalizing the descriptor so it is less sensitive to noise.
   u = mean2(temp);
   temp = ((temp - u) / norm(temp - u));
   desc(:,:,i) = temp;
end
