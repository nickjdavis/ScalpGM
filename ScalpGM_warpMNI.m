function mnifile = ScalpGM_warpMNI (distfile)

% Dvol = spm_vol(distfile);
% Dimg = spm_read_vols(Dvol);

if nargin <1 %no files
 distfile = spm_select(inf,'image','Select images to coreg');
end;
[pth,nam,ext] = spm_fileparts(deblank(distfile(1,:)));
src = fullfile(pth,[nam ext]);
if (exist(src) ~= 2) 
 	fprintf('nii_norm_linear error: unable to find template image %s.\n',src);
	return;  
end;
mnifile = fullfile(pth,['w' nam ext]);

ref = 'C:\Program Files\MATLAB\spm12b\canonical\single_subj_t1.nii';
if (exist(ref) ~= 2) 
 	fprintf('Error: unable to find template image %s.\n',ref);
	return;  
end;

spm_jobman('initcfg');

matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source = {[src ,',1']};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {[src ,',1']};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template = {[ref,',1']};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff = Inf;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
%matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [  -90 -126  -72;  90   90  108];
%matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [2 2 2];

matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [  -90.5 -126.5  -72.5;  90.5   90.5  108.5];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [1 1 1];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = 'w';
spm_jobman('run',matlabbatch);