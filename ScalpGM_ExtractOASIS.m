% Extract OASIS brains from folders

function ScalpGM_ExtractOASIS (folder)

dirin = cd;
cd (folder)
d = dir('*.hdr');
n = length(d)

for i=1:n
    % open hdr
    f = d(i).name;
    h = hdr_read_header(f)
    % get matrix
    % rotate matrix
    % save
end


% Folders have subfolders...

% Get four brain images
% collapse_nii_scan(scan_pattern,fileprefix,scan_path)

% Flip axes for SPM

% Save in new folder



cd(dirin)

% RESOURCE
% http://brainder.org/2011/08/13/converting-oasis-brains-to-nifti/
% 1. Convert to nifti:
% fslchfiletype NIFTI_GZ OAS1_0001_MR1_mpr-1_anon.hdr
% 2. Make sure there is no undesired orientation information:
% fslorient -deleteorient OAS1_0001_MR1_mpr-1_anon.nii.gz
% 3. Set the sform_code as 2, which is for “aligned anatomy”. Although this is still in native, not aligned space, it ensures that software will read them appropriately:
% fslorient -setsformcode 2 OAS1_0001_MR1_mpr-1_anon.nii.gz
% 4. Set the sform as the following matrix:
% fslorient -setsform  0 0 -1.25 0  1 0 0 0  0 1 0 0  0 0 0 1  OAS1_0001_MR1_mpr-1_anon.nii.gz
% 5. Swap the order of the data. Again, this isn’t really necessary, except to ensure that different applications will all read correctly:
% fslswapdim OAS1_0001_MR1_mpr-1_anon.nii.gz RL PA IS OAS1_0001_MR1_mpr-1_anon.nii.gz
% 6. fsl tries to preserve orientation and, when the voxels are reordered, it modifies the header accordingly, resulting in no net transformation when seen with fsl tools. To resolve this, it’s necessary to change the header again, now the qform:
% fslorient -setqform -1.25 0 0 0  0 1 0 0  0 0 1 0  0 0 0 1  OAS1_0001_MR1_mpr-1_anon.nii.gz
