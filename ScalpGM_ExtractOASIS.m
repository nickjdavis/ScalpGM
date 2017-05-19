% Extract OASIS brains from folders
% Currently converts to NIFTI and separates files
% TODO: Return list of files? Location?

function ScalpGM_ExtractOASIS (folder)

dirin = cd;
cd (folder)
d = dir('*.img');
n = length(d);

for i=1:n
    % open hdr
    f = d(i).name;
    % See Jose Vicente Manjon Herrera in this thread:
    % https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;3671aad3.1110
    % NB: John Ashburner's answer leads to errors
    V=spm_vol(f);
    ima=spm_read_vols(V);
    V.fname='filename_new.nii';
    spm_write_vol(V,ima);

end

% Create new subfolders for OASIS and for NII
mkdir('NII');
mkdir('OASIS');
% Move files
s = movefile('*.nii','NII');
if s~=1
    disp('Move error: NII');
end
s = movefile('*.hdr','OASIS');
if s~=1
    disp('Move error: HDR');
end
s = movefile('*.img','OASIS');
if s~=1
    disp('Move error: IMG');
end



cd(dirin)
