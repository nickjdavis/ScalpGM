% Quick script to make a unified ROI image

function ScalpGM_MakeROIs (ROIcodes)

%% Read ROI image
% ROIcodes is the code from the AAL atlas
% ROIimage = 'rROI_MNI_V4.nii';
ROIimage = 'ROI_MNI_V4.nii';
ROIatlas = spm_vol(ROIimage);
%ROIatlas = spm_read_vols(spm_vol(ROIimage));
% ROIatlas = spm_read_vols(ROIimage);
AtlasData = spm_read_vols(ROIatlas);
nROIs = length(ROIcodes);


%% For each ROI code, set ImageArray voxels to 1
% mxX=182; mxY=218; mxZ=182;
mxX=91; mxY=109; mxZ=91;
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
outvol.fname = 'newROIIMAGE.nii';
spm_write_vol(outvol,ImageArray);






