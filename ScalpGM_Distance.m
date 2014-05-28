% get scalp-GM distance

function distfile = ScalpGM_Distance (scalp_points,gmfile)


%% Read GM data
GMvol = spm_vol(gmfile);
GMimg = spm_read_vols (GMvol);
% GMimg = spm_slice_vol(GMvol,spm_matrix([0 0 100]),GMvol(1).dim(1:2),0);
% GMimg = spm_slice_vol(GMvol,spm_matrix([256 256 175]),GMvol(1).dim(1:2),0);
GMmask = GMimg>0.9;


%% Set up Distance image for output
% TODO - filename!; fname in private data
Dvol = GMvol;
Dimg = GMimg;
[pth,nam,ext,vol] = spm_fileparts( deblank (gmfile));
outName = fullfile(pth,['d', nam, ext]);
Dvol.fname = outName;
distfile = outName;
% Dvol.fname = 'distance.nii';
% GMvol.dim
% % Dvol.dim = [256 256 1]
% size(Dimg)

%% Calculate distances
for z=1:GMvol.dim(3)
    for y=1:GMvol.dim(2)
        for x=1:GMvol.dim(1)
            if GMmask(x,y,z)==1
                % voxel==1 so get dist and write
                %distvec = sqrt( (scalp_points(:,1)-GMmask(i,1)).^2 + (scalp_points(:,2)-GM(i,2)).^2 );
                distvec = sqrt( (scalp_points(:,1)-x).^2 + (scalp_points(:,2)-y).^2 + (scalp_points(:,3)-z).^2);
                [d,pos] = min( distvec );
                Dimg(x,y,z) = d/100;
            end
        end
    end
end

% hist(Dimg,100)


%% Write output image
spm_write_vol(Dvol,Dimg);
% matname = fullfile(pth,['d', nam, '.mat']); %'d'istance
% save (matname, 'gmfile','Dimg')
%%





%{
% get biggest region
stats = regionprops (GMmask, 'Area','PixelList','ConvexHull');
nblobs = length(stats);
mx = [0 0];
for i=1:nblobs
    if stats(i).Area > mx(2)
        mx = [i stats(i).Area];
    end
end
GM = stats(mx(1)).PixelList;


%% Distance from GM points to scalp

Dimg = GMimg;
Dvol = GMvol;
D = zeros(size(GM,1),1);
for i=1:size(GM,1)
    distvec = sqrt( (scalp_points(:,1)-GM(i,1)).^2 + (scalp_points(:,2)-GM(i,2)).^2 );
    [val,pos] = min( distvec );
    D(i) = val;
    line ([GM(i,1) scalp_points(pos,1)] , [GM(i,2) scalp_points(pos,2)])
end

D = D ./ (max(D));


%% Plots
%
% if doplot==1
%     plot (CH(:,1),CH(:,2),'k-')
%     hold on
%     for i=1:length(D)
%         plot (GM(i,1),GM(i,2),'.','Color',[D(i) .5 .5]);
%     end
%     colormap(jet)
% end

%% Write image
Vgm = spm_vol(gmfile);

fprintf('Vgm size %d', Vgm.dim);
fprintf('D size   %d', size(D));

V.fname = ['d' Vgm.fname];
V.dim = Vgm.dim; %size (D);
V.dt = Vgm.dt;
V.mat = Vgm.mat;
V.pinfo = Vgm.pinfo;
spm_write_vol(V,D);


%%

%}