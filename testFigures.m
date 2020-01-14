
function testFigures(f)

% toolboxpath = 'C:\Users\psdavinj\Documents\MATLAB\mni2fs';
% addpath(genpath(toolboxpath)) % will add all subfolders and dependencies
% sgmdir = 'C:\Users\psdavinj\Documents\MATLAB\ScalpGM\ScalpGM';
sgmdir = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM';


% CoV image
if any(f==1)
    figure('Color','k','position',[200 72 600 400])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 6; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated'; % options: 'inflated', 'pial', 'mid' or 'smoothwm'
    S.lookupsurf = 'pial'; % options: 'pial', 'mid' or 'smoothwm'
    S.surfacecolorspec = 0;
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(fullfile(sgmdir,'AllPOSTFIX_COV.nii'));
    S.mnivol = NIFTI;
    S.clims_perc = 0.8; % overlay masking below 98th percentile
    S.overlayalpha = 1;
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
end


% Mean image
if any(f==2)
    figure('Color','k','position',[200 72 600 400])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 6; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated'; % options: 'inflated', 'pial', 'mid' or 'smoothwm'
    S.lookupsurf = 'pial'; % options: 'pial', 'mid' or 'smoothwm'
    S.surfacecolorspec = 0;
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(fullfile(sgmdir,'AllPOSTFIX_M.nii'));
    S.mnivol = NIFTI;
    S.clims_perc = 0; % overlay masking below 98th percentile
    S.overlayalpha = 1;
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
end


% SD image
if any(f==3)
    figure('Color','k','position',[200 72 600 400])
    % Load and Render the FreeSurfer surface
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 6; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated'; % options: 'inflated', 'pial', 'mid' or 'smoothwm'
    S.lookupsurf = 'pial'; % options: 'pial', 'mid' or 'smoothwm'
    S.surfacecolorspec = 0;
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    NIFTI = mni2fs_load_nii(fullfile(sgmdir,'AllPOSTFIX_SD.nii'));
    S.mnivol = NIFTI;
    S.clims_perc = 0; % overlay masking below 98th percentile
    S.overlayalpha = 1;
    S = mni2fs_overlay(S)
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
end

% Plot an ROI, and make it semi transparent
% S.mnivol = fullfile(toolboxpath, 'examples/HOA_heschlsL.nii');
% S.roicolorspec = 'm'; % color. Can also be a three-element vector
% S.roialpha = 0.5; % transparency 0-1
% S = mni2fs_roi(S);
