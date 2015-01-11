function ScalpGM_MeanImage (filelist)

nFiles = length(filelist)

Mden = zeros(79,95,79);
Mnum = zeros(79,95,79);

for i=1:nFiles
    % import file
    distfile = filelist{i}
    Dvol = spm_vol(distfile)
    %Dimg = spm_read_vols (Dvol);
    Dden = [];
    Dnum = [];
    for z=1:Dvol.dim(3)
        %i
        Dimg = spm_slice_vol(Dvol,spm_matrix([0 0 z]),Dvol(1).dim(1:2),0);
        [r,c] = find(Dimg>0.1);
        if length(r)>2
            Mnum(r,c,z) = Mnum(r,c,z)+1;
            Mden(r,c,z) = Mden(r,c,z)+Dimg(r,c);
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
M = Mnum./Mden;
% size(M)
% plot3(M(:,1),M(:,2),M(:,3),'.')
% save mean image
Mvol = Dvol;
outName = 'meanimage.nii';
Mvol.fname = outName;
spm_write_vol(Dvol,M);





% filelist = cell(3,1)
% filelist{1} = '.\data3\wdc1o20100630_173454IM-0001-0001AnatomySENSEHive02s301a1003.nii';
% filelist{2} = '.\data3\wdc1sHIVE09-0301-00003-000001-01.nii';
% filelist{3} = '.\data3\wdc1sHIVE10-0301-00003-000001-01.nii';
