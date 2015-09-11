% Returns points in convex hull of scalp.

function SCallpoints = ScalpGM_getCH3d (scalpimage)


%% New approach
% 1. preprocess data
% 2. fit smooth surface to points (gridfit)
% 3. now do 3d minimisation on whole volume.
% 4. Need GUI!


%% 1. Preprocess

% load tissue types (1=GM, 5=scalp)
% GMname = ['c1' imagebasename];
% GMvol = spm_vol (GMname);
% Scalpname = ['c5' imagebasename];
% SCvol = spm_vol (Scalpname);

SCvol = spm_vol(scalpimage);


SCallpoints = [];
SC = [];

for i=10:SCvol.dim(3)
    %i
    SCimg = spm_slice_vol(SCvol,spm_matrix([0 0 i]),SCvol(1).dim(1:2),0);
    [r,c] = find(SCimg>0.9);
    SC = [SC; r c i*ones(length(r),1)];
%     if length(r)>2
%         CH = convhull(r,c);
%         %SCallpoints = [SCallpoints; r c i*ones(length(r),1)];
%         SCallpoints = [SCallpoints; r(CH) c(CH) i*ones(length(CH),1)];
%     end
end

SCallpoints = convhull(SC);

% size(SC)


% imshow(SCimg)

% plot3 (SCallpoints(:,1),SCallpoints(:,2),SCallpoints(:,3),'.')

% figure, surf(SCallpoints(:,1),SCallpoints(:,2),SCallpoints(:,3))
%% 2. Fit surface

% % [xg,yg,zg] = gridfit (SCallpoints(:,1),SCallpoints(:,2),SCallpoints(:,3));
% % figure
% % surf(xg,yg,zg)

%% 3. 








%
%
%
% % TODO - segment image into tissue types
%
%
% SCimg = spm_slice_vol(SCvol,spm_matrix([0 0 100]),SCvol(1).dim(1:2),0);
% SCmask = SCimg>0.9;
% % imshow(SCmask)
%
%
% % get biggest region
% stats = regionprops (SCmask, 'Area','PixelList','ConvexHull');
% nblobs = length(stats);
% mx = [0 0];
% for i=1:nblobs
%     if stats(i).Area > mx(2)
%         mx = [i stats(i).Area];
%     end
% end
%
% % convex hull of scalp map
% CH = stats(mx(1)).ConvexHull;
% size(CH)
% % TODO - interpolate convex hull
%
%
%
%
% %% GM mask
% GMimg = spm_slice_vol(GMvol,spm_matrix([0 0 100]),GMvol(1).dim(1:2),0);
% GMmask = GMimg>0.9;
%
% % get biggest region
% stats = regionprops (GMmask, 'Area','PixelList','ConvexHull');
% nblobs = length(stats);
% mx = [0 0];
% for i=1:nblobs
%     if stats(i).Area > mx(2)
%         mx = [i stats(i).Area];
%     end
% end
% GM = stats(mx(1)).PixelList;
%
%
% %% Distance from GM points to scalp
%
% D = zeros(size(GM,1),1);
% for i=1:size(GM,1)
%     distvec = sqrt( (CH(:,1)-GM(i,1)).^2 + (CH(:,2)-GM(i,2)).^2 );
%     [val,pos] = min( distvec );
%     D(i) = val;
%     line ([GM(i,1) CH(pos,1)] , [GM(i,2) CH(pos,2)])
% end
%
% D = D ./ (max(D));
%
%
% %% Plots
%
% if doplot==1
%     plot (CH(:,1),CH(:,2),'k-')
%     hold on
%     for i=1:length(D)
%         plot (GM(i,1),GM(i,2),'.','Color',[D(i) .5 .5]);
%     end
%     colormap(jet)
% end
