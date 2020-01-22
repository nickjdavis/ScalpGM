function ScalpGM_MultiStats (filelist, ROIimage, ROIcodes, ROIlabels)

%% Checking and setup
pathstring = path();
if isempty(strfind(pathstring,'spm'))
    % No SPM in path. Need to add
    disp('Adding SPM to path')
    addpath('\\staffhome\staff_home0\55121576\Documents\MATLAB\spm12');
end
% TODO - check ROI list dimensions

%% Read file list
% assume table file
T = readtable(filelist,'Delimiter',',')
nFiles = size(T,1);
disp(sprintf('Found %d files.',nFiles))
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

%% Read ROI image
ROIatlas = spm_read_vols(spm_vol(ROIimage));
% ROIatlas = spm_read_vols(ROIimage);
nROIs = length(ROIcodes);

%% Extract ROI data
%  For each ROI, open each image to get matching image data, then get mean
%  at end.

for i=1:nROIs
    outtxt = sprintf('%s mean depth: %3.3f',ROIlabels{i},0.0);
    disp(outtxt)
end
