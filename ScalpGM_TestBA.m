function M = ScalpGM_TestBA (imgfile)


% BA1 = 2001; % code of Precentral_L in AAL
% %BA = 2; % code of Left_M1 in HMAT
% BA2 = 3001; % Insula_L in AAL
BA1 = 4; % code of Precentral_L in AAL
% BA2 = 13; % Insula_L in AAL
BA2 = 17; % visual cortex

% load atlas
Atlas = spm_read_vols(spm_vol('brodmann.nii'));
% Atlas = spm_read_vols(spm_vol('aal.nii'));
% Atlas = spm_read_vols(spm_vol('hmat.nii'));
% size(Atlas)
% Extract Left M1, Left V1
% NB L hemi has x<92
BAmask1 = ismember(Atlas,BA1); BAmask1(92:end,:,:)=false; 
BAmask2 = ismember(Atlas,BA2); BAmask2(92:end,:,:)=false; 


% load mean image
img = spm_read_vols(spm_vol(imgfile));
img = img(2:end,2:end,2:end);

img(isnan(img))=0;
BAinIMG1 = BAmask1 & img;
BAinIMG2 = BAmask2 & img;

% size(BAinIMG1)
M = [mean(img(BAmask1)) mean(img(BAmask2))];

