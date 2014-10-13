% ScalpGM.m
%
% - Calculate distance from scalp to each grey matter voxel in
%   a structural MRI
%
% - 13 Oct 2014
%

function ScalpGM (folder,benchmark)

% TODO
% 1. Separate functions for each component
% 2. Parent function scans a folder
% 3. Some kind of output...
% 4. More descriptive screen info

if nargin<2
    benchmark=0;
end

dirin = cd();
cd (folder);
% file mask for scans
d = dir ([folder '\*.img']);
n = length(d);

for i=1:n
    tic
    T1file = d(i).name;
    fprintf('Processing file %d of %d : %s',i,n,T1file)
    % OASIS brains need to be be rescaled
    %uT1file = nii_unity(T1file);
    %snfile = ScalpGM_getSN (T1file);
    % segment image
    [scalpfile, gmfile] = ScalpGM_segmentImage (T1file);
    disp(['-- Scalp file : ' scalpfile])
    disp(['-- Grey matter: ' gmfile])
    toc1 = toc;
    % get convex hull
    scalp_points = ScalpGM_getCH (scalpfile); 
    toc2=toc;
    %disp(['-- CH file    : ' scalp_points])
    % smooth convex hull
    % calculate scalp-GM distance
    distfile = ScalpGM_Distance (scalp_points,gmfile);
    toc3=toc;
    disp(['-- Dist file  : ' distfile])
    % warp file
    %mnifile = ScalpGM_warpMNI (distfile,snfile);
    
    % output???
    if benchmark==1
        fprintf('Total elapsed time: %4.2f\nSegment  : %4.2f sec\nConvHull : %4.2f\nDistance : %4.2f\n\n',...
            toc3,toc1,toc2-toc1,toc3-toc2)
    end
    %plot3 (scalp_points(:,1),scalp_points(:,2),scalp_points(:,3),'.')
end





% clean up and exit
cd (dirin)