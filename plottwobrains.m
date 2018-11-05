% Load two brain images
% Warp both to MNI
% 3d plot both in diff colours

function plottwobrains()

TPMfile = 'C:\SPM\spm12\spm12\tpm\tpm.nii';
imgX = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ScalpGM\data3\original\HIVEx.img';
imgY = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ScalpGM\data3\original\HIVEy.img';

imgs = {imgX,imgY};
M = {'',''};

for i=1:2
    T1file = imgs{i}
    
    [scalpfile, gmfile] = ScalpGM_segmentImage (T1file,TPMfile);
    disp(['-- Scalp file : ' scalpfile])
    disp(['-- Grey matter: ' gmfile])
    scalp_points = ScalpGM_getCH3d (scalpfile);
    distfile = ScalpGM_Distance (scalp_points,gmfile);
    [mnifile,yfile] = ScalpGM_warpMNI (T1file,distfile,TPMfile);
    M{i} = mnifile
    
end

% HOORAY!!!!
% The two images prooduced afetr warping overlay beautifully!
% So the 'mnifile' truly is in MNI space.
% TODO: Now work out what the source image is - colours/values
% don't look right for Scamlp-GM distance, so may need to use 
% the y-file to warp the image at the next stage.