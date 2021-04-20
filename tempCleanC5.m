function tempCleanC5 (c5file)

info = niftiinfo(c5file);
V = niftiread(info);

% show original c5
figure;
volshow(V);

% delete anything around edges
Vx = V;
Vx(1:10,:,:) = 0;
Vx(end-10:end,:,:) = 0;
Vx(:,1:10,:) = 0;
Vx(:,end-10:end,:) = 0;
Vx(:,:,1:10) = 0;
Vx(:,:,end-10:end) = 0;

% figure;
% volshow(Vx)

% Erode then dilate
se = strel('sphere',3);
Ve = imerode(Vx,se);
Ve = imdilate(Ve,se);
figure;
volshow(Ve);

% save original to new NIFTI
newnameforoldc5 = strrep(c5file,'.nii','_old.nii');
niftiwrite(V,newnameforoldc5,info);
info.Description = strcat(info.Description,' - cleaned');
niftiwrite(Ve,c5file,info)

