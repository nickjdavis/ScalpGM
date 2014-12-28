% function ScalpGM_warp_MNI.m
%
% Warps distfile into template space (MNI)
%
% TODO
% 1. Tidy up!
% 2. Save y_ file?
% 3. Test goodness of warp


function [distMNI, yfile] = ScalpGM_warpMNI (T1file,distfile)

% Use SPM's tissue probability map
TPM = 'C:\Program Files\MATLAB\spm12b\tpm\TPM.nii';

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




%% OLD CODE BELOW HERE
%{

%% Step 1 - "Normalise: Est" T1 to template to get y_ file
% spm_jobman('initcfg');
% % matlabbatch{1}.spm.spatial.normalise.est.subj.vol = {'H:\Documents\Git\ScalpGM\data\sHIVE4-0301-00003-000001-01.img,1'};
% matlabbatch{1}.spm.spatial.normalise.est.subj.vol = {T1file};
% matlabbatch{1}.spm.spatial.normalise.est.eoptions.biasreg = 0.0001;
% matlabbatch{1}.spm.spatial.normalise.est.eoptions.biasfwhm = 60;
% matlabbatch{1}.spm.spatial.normalise.est.eoptions.tpm = {'C:\Program Files\MATLAB\spm12b\tpm\TPM.nii'};
% matlabbatch{1}.spm.spatial.normalise.est.eoptions.affreg = 'mni';
% matlabbatch{1}.spm.spatial.normalise.est.eoptions.reg = [0 0.001 0.5 0.05 0.2];
% matlabbatch{1}.spm.spatial.normalise.est.eoptions.fwhm = 0;
% matlabbatch{1}.spm.spatial.normalise.est.eoptions.samp = 3;
% spm_jobman('run',matlabbatch);
% 
% disp('Done normest')



%% Step 2 - "Normalise: Write" to warp distimage into template
%%% NB!!! Message in workspace...
% Item normalise: No field(s) named
% write
%%% CHECK!!! NB when does output file get specified? Need to check!
yfile = ['y_' T1file]; % CHECK!
spm_jobman('initcfg');
%{
matlabbatch{1}.spm.spatial.normalise.write.subj.def = {yfile};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {distfile};
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = 'w';
spm_jobman('run',matlabbatch);

%}

% matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {'C:\Users\psdavinj\Documents\MATLAB\ScalpGM\ScalpGM\data\sHIVE4-0301-00003-000001-01.img,1'};
% matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {'C:\Users\psdavinj\Documents\MATLAB\ScalpGM\ScalpGM\data\dc1sHIVE4-0301-00003-000001-01.nii,1'};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {T1file};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {distfile};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'C:\Program Files\MATLAB\spm12b\tpm\TPM.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                             78 76 85];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
spm_jobman('run',matlabbatch);

% TODO - check it conforms to output file
[pathstr,name,ext] = fileparts(distfile);
mnifile = ['w' name ext];

disp('Done normwrite')





%% SPARE CODE

% WRITE EXAMPLE SPM12b
% Normalise: Write
%--------------------------------------------------------------------------
% % matlabbatch{4}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% % matlabbatch{4}.spm.spatial.normalise.write.subj.resample = cellstr(f);
% % matlabbatch{4}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
% % 
% % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
% % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];



%{
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
%}

%}