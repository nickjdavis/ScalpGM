
function ScalpGM (folder,benchmark)
%ScalpGM - Calculate distance from scalp to each grey matter voxel in
% a structural MRI
%  
% ScalpGM(folder, benchmark)
% 
% Inputs:
%   folder    : Folder containing images for processing
%   benchmark : 1=yes, 0=no

% - 2 Jan 2017
%
% - Approx 20 mins per image (1 Jan 2017)

if nargin<2
    benchmark=0;
end

dirin = cd();
cd (folder);
% file mask for scans
% d = dir ([folder '\*.img']);
d = dir ('*.img');
n = length(d);

% Link to TPM file
% TODO - get this rel to SPM path
TPMfile = 'C:\SPM\spm12\spm12\tpm\tpm.nii';

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
isPar = 0;

for i=1:n
    tic
    T1file = d(i).name;
    fprintf('Processing file %d of %d : %s',i,n,T1file)
    % OASIS brains need to be be rescaled
    %uT1file = nii_unity(T1file);
    %snfile = ScalpGM_getSN (T1file);
    % segment image
    try
        % [scalpfile, gmfile] = ScalpGM_segmentImage (T1file);
        [scalpfile, gmfile] = ScalpGM_segmentImage (T1file,TPMfile);
        disp(['-- Scalp file : ' scalpfile])
        disp(['-- Grey matter: ' gmfile])
        toc1 = toc;
        % get convex hull
        %     scalp_points = ScalpGM_getCH (scalpfile);
        scalp_points = ScalpGM_getCH3d (scalpfile);
        toc2=toc;
        %disp(['-- CH file    : ' scalp_points])
        % TODO: smooth convex hull
        % calculate scalp-GM distance
        %if (isPar)
        %    distfile = ScalpGM_Distance_par (scalp_points,gmfile);
        %else
            distfile = ScalpGM_Distance (scalp_points,gmfile);
        %end
        toc3=toc;
        disp(['-- Dist file  : ' distfile])
        % warp file
        % NB new - pass in TPM file
        [mnifile,yfile] = ScalpGM_warpMNI (T1file,distfile,TPMfile);
        toc4=toc;
        disp(['-- MNI file   : ' mnifile])
        
        % output???
        if benchmark==1
            fprintf('Total elapsed time: %4.2f\nSegment  : %4.2f sec\nConvHull : %4.2f\nDistance : %4.2f\nMNI warp : %4.2f\n\n',...
                toc4,toc1,toc2-toc1,toc3-toc2,toc4-toc3)
        end
        
        % write log file
        % NB this is written in the target directory
        disp('-- writing log file')
        logfile = 'ScalpGM_log.txt';
        logstr = sprintf('%s\t%s\t%s\t%s\t%s\t%s\t%s\n',datestr(now),...
            T1file, scalpfile, gmfile, distfile, mnifile,yfile);
        fid = fopen(logfile,'a');
        fprintf(fid,'%s',logstr);
        fclose(fid);
        disp('-- closing log file')
    catch
        disp('-- writing log file (fail)')
        logfile = 'ScalpGM_log.txt';
        logstr = sprintf('%s\t%s\t%s\t%s\t%s\t%s\t%s\n',datestr(now),...
            T1file, 'fail', 'fail', 'fail', 'fail','fail');
        fid = fopen(logfile,'a');
        fprintf(fid,'%s',logstr);
        fclose(fid);
        disp('-- closing log file (fail)')
        disp(lasterr)
    end
    %plot3 (scalp_points(:,1),scalp_points(:,2),scalp_points(:,3),'.')
end





% clean up and exit
cd (dirin)
if isPar
    delete(pool);
end