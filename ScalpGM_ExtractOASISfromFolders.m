% Extract OASIS brains from folders
% - uses oasis_reorient.m by Ged Ridgway
% - transforms files to SPM-aligned space then returns list
% folder is directory where subject data can be found

function filelist = ScalpGM_ExtractOASISfromFolders (folder)


dirin = cd;
cd (folder)
d = dir;
n = length(d);

filelist = {};
% for i=1:n
%     if d(i).isdir == true
%         dirlist = {dirlist; d(i).name};
%     end
% end


% For each folder, make new ScalpGM folder, then find data files, move to
% folder and reorient.


for i=1:n
    if d(i).isdir==true
        basedir = d(i).name;
        if ~(strcmp(basedir,'.')||strcmp(basedir,'..'))
            %basedir = dirlist{i}
            SGMdir = strcat(basedir,'\ScalpGM');
            mkdir (SGMdir);
            % copy data file to new folder
            srcfolder = strcat(basedir,'\PROCESSED\MPRAGE\SUBJ_111');
            F = dir(strcat(srcfolder,'\*.img'));
            if ~isempty(F)
                imgfile = F.name;
                hdrfile = strrep(imgfile,'.img','.hdr');
                copyfile (strcat(srcfolder,'\',imgfile),SGMdir)
                copyfile (strcat(srcfolder,'\',hdrfile),SGMdir)
            end
            % reorient the data
            oasis_reorient(strcat(SGMdir,'\',imgfile));
            filelist = [filelist; strcat(folder,'\',SGMdir,'\',imgfile)];
        end
    end
end


cd (dirin)
