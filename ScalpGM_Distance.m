function distfile = ScalpGM_Distance (scalp_points,gmfile)
%ScalpGM_Distance - Creates image in native space with scalp-GM
% distance in GM voxels
%  
% distfile = ScalpGM_Distance(scalp_points,gmfile)
% 
% Inputs:
%   scalp_points : Convex hull of scalp
%   gmfile       : SPM-derived grey matter segment file
% Outputs:
%   distfile     : Image containing scalp-GM distances in native space

% - 2 Jan 2017

%% Read GM data
GMvol = spm_vol(gmfile);
GMimg = spm_read_vols (GMvol);
GMmask = GMimg>0.9;


%% Set up Distance image for output
% TODO - filename!; fname in private data
Dvol = GMvol;
Dimg = GMimg;
[pth,nam,ext,vol] = spm_fileparts( deblank (gmfile));
outName = fullfile(pth,['d', nam, ext]);
% outName = strcat('d',nam,ext);
Dvol.fname = outName;
distfile = strcat('d',nam,ext);;
% Dvol.fname = 'distance.nii';
% GMvol.dim
% % Dvol.dim = [256 256 1]
S = size(Dimg);

%% Calculate distances
% for z=1:GMvol.dim(3)
%     for y=1:GMvol.dim(2)
%         for x=1:GMvol.dim(1)
%             if GMmask(x,y,z)==1
%                 voxel==1 so get dist and write
%                 distvec = sqrt( (scalp_points(:,1)-GMmask(i,1)).^2 + (scalp_points(:,2)-GM(i,2)).^2 );
%                 distvec = sqrt( (scalp_points(:,1)-x).^2 + (scalp_points(:,2)-y).^2 + (scalp_points(:,3)-z).^2);
%                 [d,pos] = min( distvec );
%                 Dimg(x,y,z) = d;
%             end
%         end
%     end
% end

I = find(GMimg>0.9);
D = zeros(length(I),2);
 for i=1:length(I)
    % convert back to coordinate x,y,z
    [x,y,z] = ind2sub(S,I(i));
    % do distvec on it
    distvec = sqrt( (scalp_points(:,1)-x).^2 + (scalp_points(:,2)-y).^2 + (scalp_points(:,3)-z).^2);
    [d,pos] = min( distvec );
    %Dimg(I(i)) = d/100;
    D(i,:) = [I(i) d/100]; 
end

Dimg(D(:,1))=D(:,2);


% hist(Dimg,100)


%% Write output image
spm_write_vol(Dvol,Dimg);
% matname = fullfile(pth,['d', nam, '.mat']); %'d'istance
% save (matname, 'gmfile','Dimg')

