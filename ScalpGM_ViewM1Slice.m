% ScalpGM_ViewM1Slice
%
% Loads a single slice at around M1 level
% displays SGM distance
%
% MNI: Left M1 [-48 -8 54], Right M1 [52 -4 50]


function ScalpGM_ViewM1Slice (imagefile)

% open file
im = spm_vol(imagefile);
imdata = im.private.dat;
% size(imdata)

% select slice
X = squeeze(imdata(:,140,:));
% size(X)

% display
imagesc(rot90(X)); 
cm = get(gcf,'Colormap');
cm(1:3,:) = 0;
set (gcf,'Colormap',cm);
colorbar;


