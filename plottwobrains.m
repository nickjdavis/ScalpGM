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