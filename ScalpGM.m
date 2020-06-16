
function ScalpGM (varargin)
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


% TODO
% 1. if argin(1)=='logfile', proceed as normal
%     2. if nargin(1)=='dir', build logfile
%         

global MATLABBASE, MATLABBASE = '\\staffhome\staff_home0\55121576\Documents\MATLAB\spm12';

logfile = '';
if strcmp(varargin(1),'filelist')
    % already have a log file
    logfile = varargin(2);
elseif strcmp(varargin(1),'folder')
    % need to build a log file
    % TODO = name for logfile?
    d = varargin{2}
    logfile = int_createlogfile(d)
    %logfile = 'testtable.txt'
end


% if nargin<2
%     benchmark=0;
% end
benchmark = 0;

% readtable
T = readtable(logfile,'Delimiter',',')
D = T.imgfolder;
I = T.imgfile;
n = length(I);

scalp = {};
GM = {};
dist = {};
MNI = {};

% Link to TPM file
% TODO - get this rel to SPM path
%TPMfile = 'C:\SPM\spm12\spm12\tpm\tpm.nii';
% TPMfile = 'C:\Program Files\MATLAB\spm12b\tpm\tpm.nii';
TPMfile = strcat(MATLABBASE,'\tpm\tpm.nii');


disp (sprintf('Found %d files',n))


for i=1:n
    tic
    T1folder=D{i};
    T1file = I{i}; %d(i).name;
    fprintf('Processing file %d of %d : %s',i,n,T1file)
    try
        [scalpfile, gmfile] = ScalpGM_segmentImage (strcat(T1folder,'\',T1file),TPMfile);
        disp(['-- Scalp file : ' scalpfile])
        disp(['-- Grey matter: ' gmfile])
        toc1 = toc;
        % Get convex hull
        scalp_points = ScalpGM_getCH3d (strcat(T1folder,'\',scalpfile));
        toc2=toc;
        % Compute distance from each point in brain to scalp
        distfile = ScalpGM_Distance (scalp_points,strcat(T1folder,'\',gmfile));
        toc3=toc;
        disp(['-- Dist file  : ' distfile])
        % warp file
        [mnifile,yfile] = ScalpGM_warpMNI (strcat(T1folder,'\',T1file),strcat(T1folder,'\',distfile),TPMfile);
        toc4=toc;
        disp(['-- MNI file   : ' mnifile])
        
        scalp = [scalp; scalpfile];
        GM = [GM; gmfile];
        dist = [dist; distfile];
        MNI = [MNI; mnifile];
        
        % Output from benchmark
        if benchmark==1
            fprintf('Total elapsed time: %4.2f\nSegment  : %4.2f sec\nConvHull : %4.2f\nDistance : %4.2f\nMNI warp : %4.2f\n\n',...
                toc4,toc1,toc2-toc1,toc3-toc2,toc4-toc3)
        end
        
    catch
        % Writes 'fail' to table for output
        scalp = [scalp; 'FAIL'];
        GM = [GM; 'FAIL'];
        dist = [dist; 'FAIL'];
        MNI = [MNI; 'FAIL'];
        disp(lasterr)
    end
end


imgfolder = D;
imgfile = I;
outTable = table(imgfolder, imgfile, scalp, GM, dist, MNI);
writetable (outTable,logfile); % NB default behaviour is to overwrite file




function logfile = int_createlogfile(basedir)
dirext = '\ScalpGM';
imgfolder = {};
imgfile = {};
D = dir(basedir);
n = length(D);
% ugly - first two entries SHOULD BE current dir and parent
for i=3:n
    %D(i)
    if D(i).isdir
        N = D(i).name;
        scalpgmdir = strcat(basedir,'\',N,dirext);
        if isempty(dir(scalpgmdir))
            disp ('no ScalpGM folder')
        else
            imgfolder = [imgfolder; scalpgmdir];
            NII = dir(strcat(scalpgmdir,'\*.img'));
            imgfile = [imgfile; NII(1).name];
            % bit dodgy - assume if folder exists, so do image files...
        end
    end
end
% disp(imgfolder)
% disp(imgfile)
T = table (imgfolder, imgfile);
logfile = 'testtable.txt';
writetable(T,logfile);
% create log file and return the name