% ScalpGM.m
%
% - Calculate distance from scalp to each grey matter voxel in
%   a structural MRI
%
% - 5 June 2014
%

function ScalpGM (folder)

% TODO
% 1. Separate functions for each component
% 2. Parent function scans a folder
% 3. Some kind of output...
% 4. More descriptive screen info

dirin = cd();
cd (folder);
% file mask for scans
d = dir ([folder '\*.img']);
n = length(d);

for i=1:n
    T1file = d(i).name;
    fprintf('Processing file %d of %d : %s',i,n,T1file)
    % OASIS brains need to be be rescaled
    %uT1file = nii_unity(T1file);
    %snfile = ScalpGM_getSN (T1file);
    % segment image
    [scalpfile, gmfile] = ScalpGM_segmentImage (T1file);
    disp(['-- Scalp file : ' scalpfile])
    disp(['-- Grey matter: ' gmfile])
    % get convex hull
    scalp_points = ScalpGM_getCH (scalpfile); 
    %disp(['-- CH file    : ' scalp_points])
    % smooth convex hull
    % calculate scalp-GM distance
    distfile = ScalpGM_Distance (scalp_points,gmfile);
    disp(['-- Dist file  : ' distfile])
    % warp file
    %mnifile = ScalpGM_warpMNI (distfile,snfile);
    
    % output???
    
    %plot3 (scalp_points(:,1),scalp_points(:,2),scalp_points(:,3),'.')
end





% clean up and exit
cd (dirin)