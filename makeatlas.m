function makeatlas()

% load original atlas
ROIfile = 'ROI_MNI_V4.nii'
% Atlas = spm_read(ROIfile)
Atlas = spm_vol(ROIfile)
Atlas.pinfo
DATA = Atlas.private.dat;

% set up new image
% newimg = zeros(Atlas.dim.*2);
newimg = [DATA;DATA];
size(newimg)

% create new atlas image
% copy into each dimension
% change resolution in header
% % THIS IS UGLY
%X = zeros(Atlas.dim(1)*2,Atlas.dim(2),Atlas.dim(3));
newimg(1:2:(Atlas.dim(1)*2-1),:,:) = DATA(:,:,:);
newimg(2:2:(Atlas.dim(1)*2),:,:) = DATA(:,:,:);
% Y = zeros(Atlas.dim(1)*2,Atlas.dim(2)*2,Atlas.dim(3));
% Y(:,1:2:(Atlas.dim(2)*2-1),:) = X(:,:,:);
% Y(:,2:2:(Atlas.dim(2)*2),:) = X(:,:,:);
% newimg(:,:,1:2:(Atlas.dim(3)*2-1)) = Y(:,:,:);
% newimg(:,:,2:2:(Atlas.dim(3)*2)) = Y(:,:,:);
newnewimg = [newimg newimg];
newnewimg(:,1:2:(Atlas.dim(2)*2-1),:) = newimg(:,:,:);
newnewimg(:,2:2:(Atlas.dim(2)*2),:) = newimg(:,:,:);




% save
newAtlas = Atlas;
newAtlas.fname = ['new' ROIfile];
newAtlas.pinfo(1) = 1;
newAtlas.dim = Atlas.dim.*2;
% newAtlas.private.dat = newimg;
outFile = spm_create_vol(newAtlas)

% for i=1:2:(Atlas.dim(3)-1)
for i=1:Atlas.dim(3)
    % get slice
    S = newnewimg(:,:,i);
    % write slice
    plane = (i*2)-1;
        outFile  = spm_write_plane(outFile,S,plane);
        outFile  = spm_write_plane(outFile,S,plane+1);
end
    

% % Create outfile
% corrV = [];
% corrV.dim = [mxX mxY mxZ];
% % v.mat = [1 0 0 1; 0 1 0 1; 0 0 1 1; 0 0 0 1];
% corrV.mat = [1 0 0 -90; 0 1 0 -125; 0 0 1 -71; 0 0 0 1];
% corrV.pinfo = [1; 0; 0];
% corrV.dt = [16 0]; % float32
% corrV.fname = strrep(outFileName,'.nii','_r.nii');
% outFileV = spm_create_vol(corrV);