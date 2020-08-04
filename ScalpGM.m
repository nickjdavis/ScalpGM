
function ScalpGM (varargin)
%ScalpGM - Calculate distance from scalp to each grey matter voxel in
% a structural MRI
%
% ScalpGM(options, values)
%
% Inputs:
%   filetable : CSV file (opened as table) with images for processing
%   folder : points to folder containing files for processing
%   useExisting : (true)/false - if true will skip completed stages

% - 6 June 2019
%
% - Approx 13 mins per image (26 Feb 2019)


       

% Use an inputParser to handle options
% TODO - check validity of inputs
P = inputParser;
P.KeepUnmatched = true;
addParameter(P,'filelist','');
addParameter(P,'folder','');
addParameter(P,'useExisting',true);
addParameter(P,'logfile','ScalpGM_Log.txt');
P.parse(varargin{:});
% P.Results

global MATLABBASE, MATLABBASE = '\\staffhome\staff_home0\55121576\Documents\MATLAB\spm12';

logfile = P.Results.logfile; % TODO - append .txt if it's not there
if ~isempty(P.Results.filelist)
    % already have a log file
    logfile = P.Results.filelist;
end

if ~isempty(P.Results.folder)
    % need to build a log file
    d = P.Results.folder;
    int_createlogfile(d,logfile)
end


% readtable
T = readtable(logfile,'Delimiter',',');
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
    %tic
    T1folder=D{i};
    T1file = I{i}; %d(i).name;
    fprintf('Processing file %d of %d : %s\n',i,n,T1file)
    try
        % check here for exists(c1,c5) P.useExisting
        c1file = dir(strcat(T1folder,'\c1*'));
        c5file = dir(strcat(T1folder,'\c5*'));
        if (P.Results.useExisting) && (~isempty(c1file)) && (~isempty(c5file))
            disp('Skipping segment - already done')
            scalpfile = c5file.name;
            gmfile = c1file.name;
        else
            [scalpfile, gmfile] = ScalpGM_segmentImage (strcat(T1folder,'\',T1file),TPMfile);
        end
        disp(['-- Scalp file : ' scalpfile])
        disp(['-- Grey matter: ' gmfile])
        % Compute distance from each point in brain to scalp
        dfile = dir(strcat(T1folder,'\dc1*'));
        if (P.Results.useExisting) && (~isempty(dfile))
             disp('Skipping distance - already done');
             distfile = dfile.name;
        else
            % Get convex hull
            scalp_points = ScalpGM_getCH3d (strcat(T1folder,'\',scalpfile));
            distfile = ScalpGM_Distance (scalp_points,strcat(T1folder,'\',gmfile));
        end
        disp(['-- Dist file  : ' distfile])
        % warp file
        wfile = dir(strcat(T1folder,'\wdc1*'));
        if (P.Results.useExisting) && (~isempty(wfile))
             disp('Skipping warp - already done');
             mnifile = wfile.name;
        else
            [mnifile,yfile] = ScalpGM_warpMNI (strcat(T1folder,'\',T1file),strcat(T1folder,'\',distfile),TPMfile);
        end
        disp(['-- MNI file   : ' mnifile])
        
        scalp = [scalp; scalpfile];
        GM = [GM; gmfile];
        dist = [dist; distfile];
        MNI = [MNI; mnifile];
        
        
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




function int_createlogfile(basedir,logfile)
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
%logfile = 'testtable.txt';
writetable(T,logfile);
% create log file and return the name