% Sanity check for distance routine
% Uses .\data3 folder for convenience

function ScalpGM_TestSliceDistance3d ()

%% Some constants
T1 = '.\data3\HIVEx.img';
GM = '.\data3\c1HIVEx.nii';
SC = '.\data3\c5HIVEx.nii';
z  = 100;  % z-level for slice
% 3d: drop the above
th = 0.95; % Threshold for scalp/GM mask

%% Get data from files
% 3d: Slice within loop?
T1data = spm_read_vols (spm_vol(T1));
T1slice = T1data(:,:,z);
GMdata = spm_read_vols (spm_vol(GM));
GMslice = GMdata(:,:,z);
SCdata = spm_read_vols (spm_vol(SC));
SCslice = SCdata(:,:,z);
GMmask = imbinarize(GMslice,th);
SCmask = bwareafilt(imbinarize(SCslice,th),1);
distslice = zeros(size(T1slice));

%% Get convex hull of SCslice
% 3d: How to do this for 3d?
B = bwboundaries (SCmask, 'noholes');
SCboundary = B{1};

%% Calculate distance per voxel
% get voxels from GM
G = find(GMmask);
for i=1:length(G)
    % 3d: below needs extra index
    [x,y] = ind2sub(size(GMmask),G(i));
    % 3d: below needs z
    distvec = sqrt( (SCboundary(:,1)-x).^2 + (SCboundary(:,2)-y).^2 ); % + (scalp_points(:,3)-z).^2);
    [d,pos] = min( distvec );
    % 3d: below needs extra index
    distslice(x,y)=d;
    % Get x,y of pos from CH
    % 3d: below needs index from 3d convex hull
    P = [SCboundary(pos,1) SCboundary(pos,2)];
    % draw line from GM point to point on CH
    % - will break because plotting moved below
    % line ([P(2) y],[P(1) x])
end

%% Plots
% image(T1slice, 'CDataMapping','scaled'); colorbar
% waitforbuttonpress
% image(GMslice, 'CDataMapping','scaled');  colorbar
% % waitforbuttonpress
% image(SCslice, 'CDataMapping','scaled'); colorbar
% waitforbuttonpress
% image(SCmask, 'CDataMapping','scaled'); colorbar
% waitforbuttonpress

% plot convex hull
% hold on;
% plot (SCboundary(:,2),SCboundary(:,1),'r','LineWidth',2)

figure; image(distslice, 'CDataMapping','scaled');  colorbar
%% Save image
% 3d: Save to .nii file

