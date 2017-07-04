% Sanity check for distance routine
% Uses .\data3 folder for convenience

function ScalpGM_TestSliceDistance ()

T1 = '.\data3\HIVEx.img';
GM = '.\data3\c1HIVEx.nii';
SC = '.\data3\c5HIVEx.nii';
z  = 100;  % z-level for slice
th = 0.95; % Threshold for scalp/GM mask

% Get slice from files
T1data = spm_read_vols (spm_vol(T1));
T1slice = T1data(:,:,z);
GMdata = spm_read_vols (spm_vol(GM));
GMslice = GMdata(:,:,z);
SCdata = spm_read_vols (spm_vol(SC));
SCslice = SCdata(:,:,z);
GMmask = imbinarize(GMslice,th);
SCmask = bwareafilt(imbinarize(SCslice,th),1);
distslice = zeros(size(T1slice));
% plot for sanity
% image(T1slice, 'CDataMapping','scaled'); colorbar
% waitforbuttonpress
image(GMslice, 'CDataMapping','scaled');  colorbar
% % waitforbuttonpress
% image(SCslice, 'CDataMapping','scaled'); colorbar
% waitforbuttonpress
% image(SCmask, 'CDataMapping','scaled'); colorbar
% waitforbuttonpress


% get convex hull of SCslice
B = bwboundaries (SCmask, 'noholes');
SCboundary = B{1};
% plot convex hull
hold on;
plot (SCboundary(:,2),SCboundary(:,1),'r','LineWidth',2)


% get voxels from GM
G = find(GMmask);

for i=1:length(G)
    [x,y] = ind2sub(size(GMmask),G(i));
    distvec = sqrt( (SCboundary(:,1)-x).^2 + (SCboundary(:,2)-y).^2 ); % + (scalp_points(:,3)-z).^2);
    [d,pos] = min( distvec );
    %disp(d)
    distslice(x,y)=d;
    % Get x,y of pos from CH
    P = [SCboundary(pos,1) SCboundary(pos,2)];
    % draw line from GM point to point on CH
    line ([P(2) y],[P(1) x])
end

figure; image(distslice, 'CDataMapping','scaled');  colorbar
