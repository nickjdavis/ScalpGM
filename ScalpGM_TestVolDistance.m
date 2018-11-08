% Sanity check for distance routine
% Uses .\data3 folder for convenience

function ScalpGM_TestVolDistance ()

%% Some constants
T1 = '.\data3\HIVEx.img';
GM = '.\data3\c1HIVEx.nii';
SC = '.\data3\c5HIVEx.nii';
z  = 100;  % z-level for slice
th = 0.95; % Threshold for scalp/GM mask

%% Get data from files
T1data = spm_read_vols (spm_vol(T1));
% T1slice = T1data(:,:,z);
GMdata = spm_read_vols (spm_vol(GM));
% GMslice = GMdata(:,:,z);
SCdata = spm_read_vols (spm_vol(SC));
% SCslice = SCdata(:,:,z);
% GMmask = imbinarize(GMslice,th);
% SCmask = bwareafilt(imbinarize(SCslice,th),1);
% distslice = zeros(size(T1slice));

%% Get scalp mesh
[Ns,Es,Fs] = v2m (SCdata,.95,5,100);


%% Build dist vol
DistVol = zeros(size(GMdata));
nSlices = size(GMdata,3);
for s=1:nSlices
    disp(sprintf('Slice : %d',s)); drawnow
    GMslice = GMdata(:,:,s);
    GMmask = imbinarize(GMslice,th);
    if ~isempty(GMmask)
        % get voxels from GM
        G = find(GMmask);
        for i=1:length(G)
            [x,y] = ind2sub(size(GMmask),G(i));
            distvec = sqrt( (Ns(:,1)-x).^2 + (Ns(:,2)-y).^2 + (Ns(:,3)-z).^2 );
            [d,pos] = min( distvec );
            %disp(d)
            DistVol(x,y,s)=d;
            % Get x,y of pos from CH
            %%%P = [SCboundary(pos,1) SCboundary(pos,2)];
            % draw line from GM point to point on CH
            % - will break because plotting moved below
            % line ([P(2) y],[P(1) x])
        end
    end
end

% %% Get convex hull of SCslice
% B = bwboundaries (SCmask, 'noholes');
% SCboundary = B{1};

%% Calculate distance per voxel
% get voxels from GM
% G = find(GMmask);
% for i=1:length(G)
%     [x,y] = ind2sub(size(GMmask),G(i));
%     distvec = sqrt( (SCboundary(:,1)-x).^2 + (SCboundary(:,2)-y).^2 ); % + (scalp_points(:,3)-z).^2);
%     [d,pos] = min( distvec );
%     %disp(d)
%     distslice(x,y)=d;
%     % Get x,y of pos from CH
%     P = [SCboundary(pos,1) SCboundary(pos,2)];
%     % draw line from GM point to point on CH
%     % - will break because plotting moved below
%     % line ([P(2) y],[P(1) x])
% end

%% Plots

figure; image(DistVol(:,:,100), 'CDataMapping','scaled');  colorbar

%% Save
% NB - doesn't work! .mat save is okay, but NIFTI output seems to be in
% range [0,1]. Could use scale info below? Or keep everything in .mat?
% Latter might be better for later averaging, but still need to figure
% out transforming to MNI space!

% V - a structure array containing image volume information
%     The elements of the structures are:
%       V.fname - the filename of the image.
%       V.dim   - the x, y and z dimensions of the volume
%       V.dt    - A 1x2 array.  First element is datatype (see spm_type).
%                 The second is 1 or 0 depending on the endian-ness.
%       V.mat   - a 4x4 affine transformation matrix mapping from
%                 voxel coordinates to real world coordinates.
%       V.pinfo - plane info for each plane of the volume.
%              V.pinfo(1,:) - scale for each plane
%              V.pinfo(2,:) - offset for each plane
%                 The true voxel intensities of the jth image are given
%                 by: val*V.pinfo(1,j) + V.pinfo(2,j)
%              V.pinfo(3,:) - offset into image (in bytes).
%                 If the size of pinfo is 3x1, then the volume is assumed
%                 to be contiguous and each plane has the same scalefactor
%                 and offset.

save('distvol_temp','DistVol')
V = spm_vol_nifti(GM);
V.fname = 'distvol_Jul17.nii';
V.descrip = 'Scalp-GM distance';
spm_write_vol(V,DistVol);
