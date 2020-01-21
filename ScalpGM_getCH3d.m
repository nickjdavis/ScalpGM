function SCpoints = ScalpGM_getCH3d (scalpimage)
%ScalpGM_getCH3d - Returns points in convex hull of scalp
%  
% SCallpoints = ScalpGM_getCH3d(scalpimage)
% 
% Inputs:
%   scalpimage  : SPM-derived image of the scalp layer
% Outputs:
%   SCpoints : points that lie on 3d convex hull of scalp

% - 8 Nov 2018

SCvol = spm_vol(scalpimage);

% newer - volume (non-brain to NaN)
SCimg = spm_read_vols(SCvol);
[x,y,z] = ind2sub(size(SCimg),find(SCimg>0.9));
SC = [x,y,z];
    
% NB: K = convhull(...,'simplify', logicalvar) returns a smaller number of
% points, which are only the ones that contribute to the area/volume of 
% the shape - not used here but may help performance.
SCallpoints = convhull(SC);

s = size(SCallpoints);

% This is ugly, but...
R = reshape(SCallpoints,[s(1)*s(2) 1]);
U = unique(R);
size(U);
SCpoints = SC(U,:);


