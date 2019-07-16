function ScalpGM_MeanImage (filelist)
%ScalpGM_MeanImage - Calculates mean of several MRI images.
%  
% ScalpGM_MeanImage(filelist)
% 
% Inputs:
%   filelist  : Cell array of images in MNI space
% Outputs
%   Creates three files in home diectory:
%      XXX_mean.nii : Voxelwise mean of scalp-GM distance
%      XXX_sd.nii   : SD of voxelwise means
%      XXX_cov.nii  : Coefficient of variation

% - 12 Jun 2019

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
    % Bit hacky...
    IMGDATA = spm_read_vols(Dvol);
    X = find(IMGDATA<0.05); IMGDATA(X)=NaN; %%%

    ImageArray(:,:,:,i) = IMGDATA;
end


fname = filelist(1:strfind(filelist,'.txt')-1);

% TODO - mask here to prevent mean involving background


% Mean of ImageArray...
M = nanmean(ImageArray,4); % Avoid non-brain areas
Mvol = Dvol;
Mfname = strcat(fname,'_mean.nii');
Mvol.fname = Mfname;
Mvol.pinfo = [1; 0; 352]; %%% AAAARGH!!! This is a hack, as I don't understand it
spm_write_vol(Mvol,M);
disp (strcat('Mean image    : ', Mfname));

% ...and standard deviation...
S = nanstd(ImageArray,0,4);
Svol = Dvol;
Sfname = strcat(fname,'_std.nii');
Svol.fname = Sfname;
Svol.pinfo = [1; 0; 352]; %%% AAAARGH!!! This is a hack, as I don't understand it
spm_write_vol(Svol,S);
disp (strcat('Std dev image : ', Sfname));

% ...and finally coefficient of variation
C = S./M;
Cvol = Dvol;
Cfname = strcat(fname,'_cov.nii');
Cvol.fname = Cfname;
Cvol.pinfo = [1; 0; 352]; %%% AAAARGH!!! This is a hack, as I don't understand it
spm_write_vol(Cvol,C);
disp (strcat('CoV image     : ', Cfname));
 



