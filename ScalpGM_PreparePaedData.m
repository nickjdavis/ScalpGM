function filetable = ScalpGM_PreparePaedData(folder)


dirin = cd;
cd (folder)
d = dir;
n = length(d);

dirlist = {};
filelist = {};


% For each folder, make new ScalpGM folder, then find data files (.nii.gz),
% move to folder (and reorient? May not be needed).

for i=1:n
    if d(i).isdir==true
        basedir = d(i).name;
        if ~(strcmp(basedir,'.')||strcmp(basedir,'..'))
            %basedir = dirlist{i}
            SGMdir = strcat(basedir,'\ScalpGM');
            mkdir (SGMdir);
            % copy data file to new folder
            srcfolder = strcat(basedir,'\anat');
            F = dir(strcat(srcfolder,'\*.gz'));
            
            if ~isempty(F)
                imgfileGZ = F.name
                X = strcat(srcfolder,'\',imgfileGZ);
                imgfile = gunzip(X,SGMdir);
                imgfile = extractBefore(imgfileGZ,'.gz')
                %hdrfile = strrep(imgfile,'.img','.hdr');
                %copyfile (strcat(srcfolder,'\',imgfile),SGMdir)
                %copyfile (strcat(srcfolder,'\',hdrfile),SGMdir)
            end
            % reorient the data
            %oasis_reorient(strcat(SGMdir,'\',imgfile));
            dirlist = [dirlist; strcat(folder,'\',SGMdir)]; 
            filelist= [filelist; imgfile];
            %}
        end
    end
end

% This bit is ugly - to maintain naming consistency across files...
imgfolder = dirlist;
imgfile = filelist;
filetable = table(imgfolder,imgfile);
cd (dirin)
