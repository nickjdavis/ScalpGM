function [distMNI, yfile] = ScalpGM_warpMNI (T1file,distfile,TPM)
%ScalpGM_warpMNI - Warps a native-space distance image into
% an MNI-space image
%  
% [distMNI, yfile] = ScalpGM_warpMNI (T1file,distfile,TPM)
% 
% Inputs:
%   T1file    : Participant's structural scan
%   distfile  : Scalp-GM distance image
%   TPM       : Link to SPM's tissue probability map
% Outputs:
%   distMNI   : Image containing scalp-GM distances in MNI space
%   yfile     : SPM-derived transformation file

% - 2 Jan 2017


%bb = [-78 -112 -70; 78 76 85]; % Previous bounding box (tighter on head)
bb = [-91 -126 -72; 90 91 109]; % Standard MNI bounding box
vox= [1 1 1]; % 1mm3 voxel size

spm_jobman('initcfg');
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {T1file};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {distfile};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {TPM};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = bb;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = vox;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
spm_jobman('run',matlabbatch);

[pathstr,name,ext] = fileparts(distfile);
distMNI = ['w' name ext];
[pathstr,name,ext] = fileparts(T1file);
yfile = ['y_' name '.nii'];
