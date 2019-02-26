function M = ScalpGM_TestBA (imgfile,BA1)


% This step - only use if image is not in correct format?
%{
% Very ugly! Warp image to itself...
TPM = 'C:\Program Files\MATLAB\spm12b\tpm\TPM.nii';
spm_jobman('initcfg');
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {imgfile};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {imgfile};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {TPM};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-91 -126 -72
                                                             90 91 109];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [1 1 1];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
spm_jobman('run',matlabbatch);
%}


% [pathstr,name,ext] = fileparts(distfile);
% distMNI = ['w' name ext];
% [pathstr,name,ext] = fileparts(T1file);
% yfile = ['y_' name '.nii'];
% 

% BA1 = 2001; % code of Precentral_L in AAL
% %BA = 2; % code of Left_M1 in HMAT
% BA2 = 3001; % Insula_L in AAL
BA1 = 4; % code of Precentral_L in AAL
BA2 = 13; % Insula_L in AAL

% load atlas
Atlas = spm_read_vols(spm_vol('brodmann.nii'));
% Atlas = spm_read_vols(spm_vol('aal.nii'));
% Atlas = spm_read_vols(spm_vol('hmat.nii'));
size(Atlas)
BAmask1 = ismember(Atlas,BA1);
BAmask2 = ismember(Atlas,BA2);
% size(BAmask)

% load mean image
% img = spm_read_vols(spm_vol(strcat('w',imgfile)));
img = spm_read_vols(spm_vol(imgfile));
size(img)
img = img(2:end,2:end,2:end);
size(img)

BAinIMG1 = BAmask1 & img;
BAinIMG2 = BAmask2 & img;

% size(BAinIMG1)
M = [mean(img(BAmask1)) mean(img(BAmask2))];

% V = spm_vol('hmat.nii');
% V.fname = 'TestBA_mask.nii';
% V.private.dat.fname = V.fname;
% spm_write_vol(V,BAinIMG1);