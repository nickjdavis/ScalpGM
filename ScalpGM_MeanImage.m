function ScalpGM_MeanImage (filelist)
%ScalpGM_MeanImage - Calculates mean of several MRI images.
%  
% ScalpGM_MeanImage(filelist)
% 
% Inputs:
%   filelist  : Cell array of images in MNI space
% Outputs
%   Creates three files in home diectory:
%      meanimage_alt.nii     : Voxelwise mean of scalp-GM distance
%      meanimage_alt_sd.nii  : SD of voxelwise means
%      meanimage_alt_cov.nii : Coefficient of variation

% - 2 Jan 2017

if iscell(filelist)
    % this is what we expect
    F = filelist;
    nFiles = length(F);
    disp(strcat('Found ',nFiles,' files.'))
else
    % assume table file
    T = readtable(filelist);
    nFiles = size(T,1);
    F = {};
    D = T.imgfolder;
    I = T.imgfile;
    M = T.MNI;
    for i=1:nFiles
        % get folder
        %[p,n,e]=fileparts(I{i});
        p = D{i};
        % get MNI file
        f=strcat(p,'\',M{i});
        % add folder+mni to F
        F=[F;f];
    end
end



% These are standard sizes of MNI image in SPM
% mxX=79; mxY=95; mxZ=79;
mxX=182; mxY=218; mxZ=182;
ImageArray = zeros (mxX,mxY,mxZ,nFiles);

disp('Adding image files...')
for i=1:nFiles
    % import file
    distfile = F{i};
    disp(distfile)
    Dvol = spm_vol(distfile);
    ImageArray(:,:,:,i) = Dvol.private.dat;
end



% Mean of ImageArray...
M = mean(ImageArray,4);
Mvol = Dvol;
Mfname = 'new_new_new_mean.nii';
Mvol.fname = Mfname;
spm_write_vol(Mvol,M);
disp (strcat('Mean image    : ', Mfname));

% ...and standard deviation...
S = std(ImageArray,0,4);
Svol = Dvol;
Sfname = 'new_new_new_std.nii';
Svol.fname = Sfname;
spm_write_vol(Svol,S);
disp (strcat('Std dev image : ', Sfname));

% ...and finally coefficient of variation
C = S./M;
Cvol = Dvol;
Cfname = 'new_new_new_cov.nii';
Cvol.fname = Cfname;
spm_write_vol(Cvol,C);
disp (strcat('CoV image     : ', Cfname));
 



