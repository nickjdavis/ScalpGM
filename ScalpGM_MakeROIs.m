% Quick script to make a unified ROI image

function ScalpGM_MakeROIs (ROIcodes)

%% Read ROI image
% ROIcodes is the code from the AAL atlas
ROIimage = 'rROI_MNI_V4.nii';
ROIatlas = spm_vol(ROIimage);
%ROIatlas = spm_read_vols(spm_vol(ROIimage));
% ROIatlas = spm_read_vols(ROIimage);
AtlasData = spm_read_vols(ROIatlas);
nROIs = length(ROIcodes);


%% For each ROI code, set ImageArray voxels to 1
mxX=182; mxY=218; mxZ=182;
%ImageArray = zeros(mxX-1,mxY-1,mxZ-1);
ImageArray = zeros(mxX,mxY,mxZ);
for i=1:nROIs
    Mask = ismember(AtlasData,ROIcodes(i));
    %size(Mask)
    %size(ImageArray)
    ImageArray = ImageArray + Mask;
end


%% Ugly - 'fixes' (disguises) problem of sparse ROIs
IAs = smooth3(ImageArray,'gaussian');
IAsm= IAs>0.05;
ImageArray = IAsm;




%% Create file for output
outvol = ROIatlas;
outvol.fname = 'ROIIMAGE.nii';
spm_write_vol(outvol,ImageArray);








%% old code below
%{
% basic atlas
BA = spm_vol('brodmann.nii');
mxX=182; mxY=218; mxZ=182;
ImageArray = zeros(mxX-1,mxY-1,mxZ-1);
offset = [90 125 71]; % offset of origin

% add L M1
M1vol = spm_vol('.\ROIs\rhandnew.nii');
V = spm_read_vols(M1vol);
X = 1*(V>0.5);
ImageArray = ImageArray+X;


% add R TPJ
TPJvol = spm_vol('.\ROIs\rR-TPJ.nii');
V = spm_read_vols(TPJvol);
X = 2*(V>0.5);
ImageArray = ImageArray+X;

% add R CogControl
CCvol = spm_vol('.\ROIs\rR-CogControl.nii');
V = spm_read_vols(CCvol);
X = 3*(V>0.5);
ImageArray = ImageArray+X;


% expt - sphere for left V1
ctr = [-12 -102 6];
offsetctr = ctr+offset;
ImageArray(offsetctr(1),offsetctr(2),offsetctr(3))=99;



% create new volume
outvol = BA;
 outvol.fname = 'ROI.nii';
%  outvol.pinfo = [1; 0; 352];
%  spm_write_vol(outvol,ImageArray(2:end,2:end,2:end))
 spm_write_vol(outvol,ImageArray)

%}