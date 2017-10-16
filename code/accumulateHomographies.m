function Htot = accumulateHomographies(Hpair,m)
% ACCUMULATEHOMOGRAPHY Accumulate homography matrix sequence.
% Arguments:
% Hpair ? Cell array of M?1 3x3 homography matrices where Hpair{i} is a
% homography that transforms between coordinate systems i and i+1.
% m ? Index of coordinate system we would like to accumulate the
% given homographies towards (see details below).
% Returns:
% Htot ? Cell array of M 3x3 homography matrices where Htot{i} transforms
% coordinate system i to the coordinate system having the index m.
% Note:
% In this exercise homography matrices should always maintain
% the property that H(3,3)==1. This should be done by normalizing them as
% follows before using them to perform transformations H = H/H(3,3).

Htot = cell(1, size(Hpair, 1)+1);
%normalize all homographies
Hpair =  cellfun(@(hom) (hom/hom(3,3)), Hpair,  'UniformOutput', 0);
Htot{m} = eye(3); %the middle image isn't changed
for i = 1:(m-1)
    %calculate the accumulated forward or backward homography
    Htot{m-i} = Htot{m-i+1}*Hpair{m-i};
    Htot{m+i} = Htot{m+i-1}/(Hpair{m+i-1});
end
if ((2*m-1) == size(Hpair, 1))
    %odd number of homographies, so last one wasn't calculated
    Htot{end} = Htot{end-1}/(Hpair{end});
end

