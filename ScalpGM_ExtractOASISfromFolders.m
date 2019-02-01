% Extract OASIS brains from folders
% - uses oasis_reorient.m by Ged Ridgway
% - transforms files to SPM-aligned space then returns list
% folder is directory where subject data can be found

function dirlist = ScalpGM_ExtractOASISfromFolders (folder)


dirin = cd;
cd (folder)
d = dir;
n = length(d);

dirlist = {};
% for i=1:n
%     if d(i).isdir == true
%         dirlist = {dirlist; d(i).name};
%     end
% end


% For each folder, make new ScalpGM folder, then find data files, move to
% folder and reorient.


for i=1:n
    if d(i).isdir==true
        basedir = d(i).name
        if ~(strcmp(basedir,'.')||strcmp(basedir,'..'))
            %basedir = dirlist{i}
            SGMdir = strcat(basedir,'\ScalpGM');
            mkdir (SGMdir);
            % copy data file to new folder
            srcfolder = strcat(basedir,'\PROCESSED\MPRAGE\SUBJ_111');
            filelist = dir(strcat(srcfolder,'\*.img'));
            if ~isempty(filelist)
                imgfile = filelist.name
                hdrfile = strrep(imgfile,'.img','.hdr')
                copyfile (strcat(srcfolder,'\',imgfile),SGMdir)
                copyfile (strcat(srcfolder,'\',hdrfile),SGMdir)
            end
            
            % reorient the data
            %%%oasis_reorient(newoasisfile);
        end
    end
end


cd (dirin)

%{
% OLD - trying to manually reorient
for i=1:n
    % open hdr
    f = d(i).name;
    disp(f)
    V=spm_vol(f);
    ima=spm_read_vols(V);
    % Rotate images, OASIS are in an odd orientation...
    % https://brainder.org/2011/08/13/converting-oasis-brains-to-nifti/
    % fslorient -setsform  0 0 -1.25 0  1 0 0 0  0 1 0 0  0 0 0 1
    V.mat = [0 0 -1.25 0 ; 1 0 0 0 ; 0 1 0 0 ; 0 0 0 1];
    V.private.mat =  [0 0 -1.25 0 ; 1 0 0 0 ; 0 1 0 0 ; 0 0 0 1];
    V.private.mat0 = [0 0 -1.25 0 ; 1 0 0 0 ; 0 1 0 0 ; 0 0 0 1];
    V.fname=strrep(f,'.img','.nii');;
    spm_write_vol(V,ima);

end
%}

% % Create new subfolders for OASIS and for NII
% try
%     mkdir('NII');
%     mkdir('OASIS');
% catch
%     % issues a warning if dirs exist
%     % todo - suppress warning, or check for dir
% end
% % Move files
% s = movefile('*.nii','NII');
% if s~=1
%     disp('Move error: NII');
% end
% s = movefile('*.hdr','OASIS');
% if s~=1
%     disp('Move error: HDR');
% end
% s = movefile('*.img','OASIS');
% if s~=1
%     disp('Move error: IMG');
% end

