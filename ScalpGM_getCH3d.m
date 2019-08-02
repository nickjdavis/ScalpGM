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


SCallpoints = [];
SC = [];

% older - slicewise
% for i=1:SCvol.dim(3)
%     %i
%     SCimg = spm_slice_vol(SCvol,spm_matrix([0 0 i]),SCvol(1).dim(1:2),0);
%     [r,c] = find(SCimg>0.9);
%     SC = [SC; r c i*ones(length(r),1)];
% end

% newer - volume (non-brain to NaN)
SCimg = spm_read_vols(SCvol);
X = find(SCimg>0.9);
[x,y,z] = ind2sub(size(SCimg),find(SCimg>0.9););
SC = [x,y,z];
    


% K = convhull(X,Y,Z) returns the 3-D convex hull of the points (X,Y,Z),
% where X, Y, and Z are column vectors. K is a triangulation representing 
% the boundary of the convex hull. K is of size mtri-by-3, where mtri is 
% the number of triangular facets. That is, each row of K is a triangle 
% defined in terms of the point indices.
% NB: K = convhull(...,'simplify', logicalvar) returns a smaller number of
% points, which are only the ones that contribute to the area/volume of 
% the shape - not used here but may help performance.
SCallpoints = convhull(SC);

% size(SC)
s = size(SCallpoints);

% trimesh(SCallpoints,SC(:,1),SC(:,2),SC(:,3))


% This is ugly, but...
R = reshape(SCallpoints,[s(1)*s(2) 1]);
U = unique(R);
size(U);
SCpoints = SC(U,:);


