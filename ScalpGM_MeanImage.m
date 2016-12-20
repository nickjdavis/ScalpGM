% TODO
% 1. Tidy up
% 2. Chase NaNs in output
% 3. Add mask back in?

function ScalpGM_MeanImage (filelist)

nFiles = length(filelist);

% Where do these values come from?
% Msum = zeros(79,95,79);     % Sum of valid voxel values
% Mvox = zeros(79,95,79);     % No of valid voxels per division
% V = zeros(79,95,79,nFiles); % All voxels, ready for SD
mxX=256; mxY=256; mxZ=256;
Msum = zeros(mxX,mxY,mxZ);     % Sum of valid voxel values
Mvox = zeros(mxX,mxY,mxZ);     % No of valid voxels per division
V = zeros(mxX,mxY,mxZ,nFiles); % All voxels, ready for SD

for i=1:nFiles
    % import file
    distfile = filelist{i}
    Dvol = spm_vol(distfile);
    Dvol.dim(3)
    for z=1:Dvol.dim(3)
        Dimg = spm_slice_vol(Dvol,spm_matrix([0 0 z]),Dvol(1).dim(1:2),0);
        [r,c] = find(Dimg>0.1);
        if length(r)>2
            Mvox(r,c,z) = Mvox(r,c,z)+1;
            Msum(r,c,z) = Msum(r,c,z)+Dimg(r,c);
            V(r,c,z,i)  = Dimg(r,c);
        end
    end
end

size(Dvol)



% % get mask
% Dmask = Dimg>0.01;
% % add mask voxels to denominator img
% % add values to numerator image
% if isempty(Mden)
%     Mden(Dmask) = 1;
%     Mnum(Dmask) = Dimg(Dmask);
% else
%     Mden(Dmask) = Mden(Dmask)+1;
%     Mnum(Dmask) = Mnum(Dmask)+Dimg(Dmask);
% end
% end

% % mean image is num./den
% disp('Writing mean image')
% %%%M = Mnum./Msum;
% M = Msum ./ Mvox;
% % size(M)
% % plot3(M(:,1),M(:,2),M(:,3),'.')
% % save mean image
% Mvol = Dvol;
% outName = 'meanimage_new.nii';
% Mvol.fname = outName;
% spm_write_vol(Mvol,M);

% Alt version of mean image - use V
disp('Alternative mean image')
outName = 'meanimage_alt.nii';
Vm = zeros(mxX,mxY,mxZ);
Vm(:,:,:) = mean (V,4);
size(Vm)
Mvol = Dvol;
Mvol.fname = outName;
spm_write_vol(Mvol,Vm);
% Standard deviation image - use V
disp('Alternative SD image')
outName = 'meanimage_alt_sd.nii';
Sm = zeros(mxX,mxY,mxZ);
Sm(:,:,:) = std (V,0,4);
Mvol = Dvol;
Mvol.fname = outName;
spm_write_vol(Mvol,Sm);
% Coefficient of variation image - SD/mean
% Lots of NaNs here (no infs) - not in prev steps
disp('CoV image')
outName = 'meanimage_alt_cov.nii';
% Cm = zeros(79,95,79);
Cm = Sm./Vm;
Mvol = Dvol;
Mvol.fname = outName;
spm_write_vol(Mvol,Cm);
N = size(find(isnan(Cm)==1))
M = size(find(isinf(Cm)==1))


% 
% M(isinf(M))=NaN;
% M(M>5)=NaN;
% M(M<.1)=NaN;
% MM = M(~isnan(M));
% % MM(MM>255)=255;
% min(MM)
% max(MM)
% 
% hist(MM,100)
