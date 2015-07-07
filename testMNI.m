% function to test coregistration of output image to MNI space
%
% IN: TPM      - tissue probability map (template)
% IN: T1file   - subject's own structural scan (native)
% IN: distfile - subject's distance image (native)
%
% TODO
% OUT: distMNI - distance image warped to MNI (template)
%
% Why do I input T1 and dist in the first parameters? Does this
% guarantee an MNI fit? - SEEMS TO!!!


function [distMNI,yfile] = testMNI (TPM, T1file, distfile)

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
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                             78 76 85];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
spm_jobman('run',matlabbatch);

[pathstr,name,ext] = fileparts(distfile);
distMNI = ['w' name ext];
[pathstr,name,ext] = fileparts(T1file);
yfile = ['y_' name '.nii'];