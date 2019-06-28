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


%% Set up Distance image for output
% TODO - filename!; fname in private data
Dvol = GMvol;
Dimg = GMimg;
[pth,nam,ext,vol] = spm_fileparts( deblank (gmfile));
outName = fullfile(pth,['d', nam, ext]);
% outName = strcat('d',nam,ext);
Dvol.fname = outName;
Dvol.dt = [16 0]; % Default data type is uint8 ([2 0]). This makes it float32.
distfile = strcat('d',nam,ext);
% Dvol.fname = 'distance.nii';
% GMvol.dim
% % Dvol.dim = [256 256 1]
S = size(Dimg);

%% Calculate distances
I = find(GMimg>0.9);
D = zeros(length(I),2);
 for i=1:length(I)
    % convert back to coordinate x,y,z
    [x,y,z] = ind2sub(S,I(i));
    % do distvec on it
    distvec = sqrt( (scalp_points(:,1)-x).^2 + (scalp_points(:,2)-y).^2 + (scalp_points(:,3)-z).^2);
    [d,pos] = min( distvec );
    D(i,:) = [I(i) d];
end

Dimg(D(:,1))=D(:,2);



%% Write output image
% % Hacky - spm_write_vol seems to only save values as [0..1]
% rmfield(Dvol,'pinfo'); %%% VERY HACKY!!! Relies on SPM figuring out scale.
Dvol.pinfo = [1; 0; 352];
spm_write_vol(Dvol,Dimg);
% savefilename = strrep(outName,'.nii','.mat');
% save ('outName','Dimg','I');
% Dvol.pinfo
% matname = fullfile(pth,['d', nam, '.mat']); %'d'istance
% save (matname, 'gmfile','Dimg')

