% Make figures for ScalpGM

function ScalpGM_Figures(F)

% test for mni2fs
pathstring = path();
if isempty(strfind(pathstring,'mni2fs'))
    % No SPM in path. Need to add
    disp('Adding mni2fs to path')
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\export_fig');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\freezeColors');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\gifti-1.4');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\misc');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\myaa');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\nifti_tools');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\private');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\surf');
end

mni2fs_auto('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii','lh')