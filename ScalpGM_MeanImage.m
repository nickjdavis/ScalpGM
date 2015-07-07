function ScalpGM_MeanImage (filelist)

nFiles = length(filelist);

Msum = zeros(79,95,79); % Sum of valid voxel values
Mvox = zeros(79,95,79); % No of valid voxels per division

for i=1:nFiles
    % import file
    distfile = filelist{i}
    Dvol = spm_vol(distfile);
    %Dimg = spm_read_vols (Dvol);
%     Dden = [];
%     Dnum = [];
    for z=1:Dvol.dim(3)
        %i
        Dimg = spm_slice_vol(Dvol,spm_matrix([0 0 z]),Dvol(1).dim(1:2),0);
        [r,c] = find(Dimg>0.1);
        if length(r)>2
            Mvox(r,c,z) = Mvox(r,c,z)+1;
            Msum(r,c,z) = Msum(r,c,z)+Dimg(r,c);
        end
        % %         CH = convhull(r,c);
        % %         %SCallpoints = [SCallpoints; r c i*ones(length(r),1)];
        % %         Dallpoints = [SCallpoints; r(CH) c(CH) i*ones(length(CH),1)];
    end
end




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

% mean image is num./den
disp('Writing mean image')
%%%M = Mnum./Msum;
M = Msum ./ Mvox;
% size(M)
% plot3(M(:,1),M(:,2),M(:,3),'.')
% save mean image
Mvol = Dvol;
outName = 'meanimage_new.nii';
Mvol.fname = outName;
spm_write_vol(Mvol,M);


M(isinf(M))=NaN;
M(M>5)=NaN;
M(M<.1)=NaN;
MM = M(~isnan(M));
% MM(MM>255)=255;
min(MM)
max(MM)

hist(MM,100)
