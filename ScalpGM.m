
function ScalpGM (logfile,benchmark)
%ScalpGM - Calculate distance from scalp to each grey matter voxel in
% a structural MRI
%
% ScalpGM(filetable, benchmark)
%
% Inputs:
%   filetable : CSV file (opened as table) with images for processing
%   benchmark : 1=yes, 0=no

% - 6 June 2019
%
% - Approx 13 mins per image (26 Feb 2019)

if nargin<2
    benchmark=0;
end


% readtable
T = readtable(logfile);
D = T.imgfolder;
I = T.imgfile;
n = length(I);

% TODO - new table columns, and create new table
scalp = {};
GM = {};
dist = {};
MNI = {};

% Link to TPM file
% TODO - get this rel to SPM path
%TPMfile = 'C:\SPM\spm12\spm12\tpm\tpm.nii';
TPMfile = 'C:\Program Files\MATLAB\spm12b\tpm\tpm.nii';

disp (sprintf('Found %d files',n))

% check if parallel toolbox is present
% v = ver;
% [installedToolboxes{1:length(v)}] = deal(v.Name);
% isPar = all(ismember('Parallel Computing Toolbox',installedToolboxes));
% if (isPar==1)
%     pool=parpool;
% else
%     %
% end
% isPar = 0;

for i=1:n
    tic
    T1folder=D{i};
    T1file = I{i}; %d(i).name;
    %[pathstr,fname,ext] = fileparts(T1file);
    fprintf('Processing file %d of %d : %s',i,n,T1file)
    try
        [scalpfile, gmfile] = ScalpGM_segmentImage (strcat(T1folder,'\',T1file),TPMfile);
        disp(['-- Scalp file : ' scalpfile])
        disp(['-- Grey matter: ' gmfile])
        toc1 = toc;
        % get convex hull
        %     scalp_points = ScalpGM_getCH (scalpfile);
        scalp_points = ScalpGM_getCH3d (strcat(T1folder,'\',scalpfile));
        toc2=toc;
        distfile = ScalpGM_Distance (scalp_points,strcat(T1folder,'\',gmfile));
        %end
        toc3=toc;
        disp(['-- Dist file  : ' distfile])
        % warp file
        % NB new - pass in TPM file
        [mnifile,yfile] = ScalpGM_warpMNI (strcat(T1folder,'\',T1file),strcat(T1folder,'\',distfile),TPMfile);
        toc4=toc;
        disp(['-- MNI file   : ' mnifile])
        
        % TODO - compile filenames into new table
        scalp = [scalp; scalpfile];
        GM = [GM; gmfile];
        dist = [dist; distfile];
        MNI = [MNI; mnifile];
        
        % output???
        if benchmark==1
            fprintf('Total elapsed time: %4.2f\nSegment  : %4.2f sec\nConvHull : %4.2f\nDistance : %4.2f\nMNI warp : %4.2f\n\n',...
                toc4,toc1,toc2-toc1,toc3-toc2,toc4-toc3)
        end
        
        % write log file
        % NB this is written in the target directory
        %         disp('-- writing log file')
        %         logfile = 'ScalpGM_log.txt';
        %         logstr = sprintf('%s\t%s\t%s\t%s\t%s\t%s\t%s\n',datestr(now),...
        %             T1file, scalpfile, gmfile, distfile, mnifile,yfile);
        %         fid = fopen(logfile,'a');
        %         fprintf(fid,'%s',logstr);
        %         fclose(fid);
        %         disp('-- closing log file')
        
        
    catch
        % Writes 'fail' to table for output
        scalp = [scalp; 'FAIL'];
        GM = [GM; 'FAIL'];
        dist = [dist; 'FAIL'];
        MNI = [MNI; 'FAIL'];
        disp(lasterr)
    end
end


% TODO - writetable
imgfolder = D;
imgfile = I;
outTable = table(imgfolder, imgfile, scalp, GM, dist, MNI);
writetable (outTable,logfile); % NB default behaviour is to overwrite file
