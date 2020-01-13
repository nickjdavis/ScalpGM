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

T1file = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM/single_subj_T1.nii';
Mfile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ALLTEST_M.nii';
Sfile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ALLTEST_SD.nii';
Cfile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ALLTEST_COV.nii';


% Draw one
% mni2fs_auto('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii','lh')


% Draw two
% mni2fs_auto('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii','lh')
% mni2fs_auto('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii','rh')
% view([40 30])


% Mean figure
figure('Color','k','position',[20 72 600 500])
% Load and Render the FreeSurfer surface
S = [];
S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
S.inflationstep = 2; % 1 no inflation, 6 fully inflated
S.decimation = 0;
S = mni2fs_brain(S);
%S.mnivol = fullfile('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/HOA_heschlsL.nii');
S.mnivol = fullfile(T1file);
% S.roicolorspec = 'm'; % color. Can also be a three-element vector
S.roialpha = 1; % transparency 0-1
S = mni2fs_roi(S); 
% Add overlay, theshold to 98th percentile
NIFTI = mni2fs_load_nii(Mfile); % mnivol can be a NIFTI structure
S.mnivol = NIFTI;
% S.clims_perc = 0.80; % overlay masking below 98th percentile
S = mni2fs_overlay(S);
view([-90 0]); % change camera angle
% mni2fs_lights; % Dont forget to turn on the lights!






%{
figure('Color','k','position',[20 72 800 600])
% Load and Render the FreeSurfer surface
S = [];
S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
S.inflationstep = 6; % 1 no inflation, 6 fully inflated
S = mni2fs_brain(S);
S.mnivol = fullfile('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/HOA_heschlsL.nii');
S.roicolorspec = 'm'; % color. Can also be a three-element vector
S.roialpha = 0.5; % transparency 0-1
S = mni2fs_roi(S); 
% Add overlay, theshold to 98th percentile
NIFTI = mni2fs_load_nii('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\examples/AudMean.nii'); % mnivol can be a NIFTI structure
S.mnivol = NIFTI;
S.clims_perc = 0.98; % overlay masking below 98th percentile
S = mni2fs_overlay(S); 
view([-90 0]); % change camera angle
mni2fs_lights; % Dont forget to turn on the lights!
%}

%{
%% Simple Auto Wrapper - All Settings are at Default and Scaling is Automatic
close all
mni2fs_auto(fullfile(toolboxpath, 'examples/AudMean.nii'),'lh')

%% Plot ROI and Overlay
close all
figure('Color','k','position',[20 72 800 600])

% Load and Render the FreeSurfer surface
S = [];
S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
S.inflationstep = 6; % 1 no inflation, 6 fully inflated
S = mni2fs_brain(S);

% Plot an ROI, and make it semi transparent
S.mnivol = fullfile(toolboxpath, 'examples/HOA_heschlsL.nii');
S.roicolorspec = 'm'; % color. Can also be a three-element vector
S.roialpha = 0.5; % transparency 0-1
S = mni2fs_roi(S); 

% Add overlay, theshold to 98th percentile
NIFTI = load_nii(fullfile(toolboxpath, 'examples/AudMean.nii')); % mnivol can be a NIFTI structure
S.mnivol = NIFTI;
S.clims_perc = 0.98; % overlay masking below 98th percentile
S = mni2fs_overlay(S); 
view([-90 0]) % change camera angle
mni2fs_lights % Dont forget to turn on the lights!
% Optional - lighting can be altered after rendering






%% For high quality output 
% Try export_fig package included in this release
% When using export fig use the bitmap option 
export_fig('filename.bmp','-bmp')
%}