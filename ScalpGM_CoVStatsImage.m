function ScalpGM_CoVStatsImage (CVimagefile,Nimagefile,gamma)

if nargin<3
    % gamma is the test value in the t-test
    gamma = .2;
end

pathstring = path();
if ~contains(pathstring,'mni2fs')
    % No SPM in path. Need to add
    disp('Adding mni2fs to path')
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\export_fig');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\freezeColors');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\gifti-1.4');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\misc');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\myaa');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\nifti_tools');
    %addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\private');
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\mni2fs\surf');
end

%% Collect data and check

Nvol = spm_vol(Nimagefile);
Nimg = spm_read_vols(Nvol);

CVvol = spm_vol(CVimagefile);
CVimg = spm_read_vols(CVvol);
I = find(Nimg>5);

% test CVimage for normality
[h,p] = kstest(CVimg(I));
if (h==true)
    % normal
    msg = sprintf('Data passes assumption of normality.');
else
    % non-normal
    msg = sprintf('CAUTION: Data fails test for normality (p=%1.4f)',p);
    msg = strcat(msg,'Analysis of coefficient of variation is not robust for non-normal data.');    
end
disp(msg)


%% Stats - modified pointwise t-test 

% overall mean CoV
M = mean(CVimg(I));

% t-test of CV data
correctionfactor = (1+1./(4.*Nimg));
CVunbiased = CVimg.*correctionfactor;
CVstd = CVimg./sqrt(2.*Nimg);
CVt = (CVunbiased-gamma)./CVstd;
CVp = 1-tcdf(CVt,Nimg);


%% Output image
% - this is ugly - need to fix

% X = zeros(182,218,182);
% X(I) = CVp(I);
% pvol = CVvol;
% pvol.fname = 'testpvol30.nii';
% spm_write_vol(pvol,X);


Y = zeros(182,218,182);
% High values
CVt = (CVunbiased-gamma)./CVstd;
CVp = 1-tcdf(CVt,Nimg);
P = find(CVp<.05);
Y(P) = gamma;
% Low values
CVt = (CVunbiased-gamma)./CVstd;
CVp = tcdf(CVt,Nimg);
P = find(CVp<.05);
Y(P) = -gamma;
% Write
pvol = CVvol;
ttestfile = sprintf('ScalpGM CoV ttest %f.nii',gamma);
pvol.fname = ttestfile;
spm_write_vol(pvol,Y);


%% Plot image
% - Bit messy. Need to manually select hemisphere for plotting

    NIFTI = mni2fs_load_nii(ttestfile); % mnivol can be a NIFTI structure
%     X = find(isnan(NIFTI.img));
%     m = nanmean(nanmean(nanmean(NIFTI.img)));
%     NIFTI.img(X) = m; % zero here smooths the nans
%     % Load and Render the FreeSurfer surface
    % Mean LH
    figure('Color','w','position',[20 72 600 500])
    S = [];
    S.hem = 'lh'; % choose the hemesphere 'lh' or 'rh'
    S.inflationstep = 5; % 1 no inflation, 6 fully inflated
    S.decimation = 0;
    S.plotsurf = 'inflated';
    S.lookupsurf = 'mid'; % was pial - mid better
    S = mni2fs_brain(S);
    % Add overlay, theshold to 98th percentile
    %S.surfacetype = 'xx'; % NOT USED???? was 'inflated' ('xx',pial, smoothwm, mid no diff)
    S.mnivol = NIFTI;
    %S.climstype = 'pos';
    S.smoothdata = 1; % 1, 3 worse than zero - propagating nans?
% S.clims = [.125 .375];
%     S.clims_perc = .00001; % overlay masking below 98th percentile
    S.interpmethod = 'nearest'; % 'spline' crashes; 'linear', 'cubic' worse
    S = mni2fs_overlay(S);
    view([-90 0]); % change camera angle
    mni2fs_lights; % Dont forget to turn on the lights!
%     colorbar;
