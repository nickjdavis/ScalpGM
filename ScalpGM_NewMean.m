function ScalpGM_NewMean (filelist,outFileName)


% These are standard sizes of MNI image in SPM
% HACKY!!!
mxX=182; mxY=218; mxZ=182;
ImageArray = zeros (mxX,mxY,mxZ);%;,nFiles);

v = [];
v.fname = strrep(outFileName,'.nii','_M.nii');
v.dim = [mxX mxY mxZ];
v.mat = eye(4);
v.pinfo = [1; 0; 352]; %%% AAAUGH HACK!!!!
v.dt = [16 0]; % float32
outFileM = spm_create_vol(v);
outFileM = spm_write_vol(outFileM,ImageArray);
% spm_vol();
% outFileM = 

% read fileslist
if iscell(filelist)
    % this is what we expect
    F = filelist;
    nFiles = length(F);
    disp(strcat('Found ',nFiles,' files.'))
else
    % assume table file
    T = readtable(filelist);
    nFiles = size(T,1);
    F = {};
    D = T.imgfolder;
    I = T.imgfile;
    M = T.MNI;
    for i=1:nFiles
        % get folder
        %[p,n,e]=fileparts(I{i});
        p = D{i};
        % get MNI file
        f=strcat(p,'\',M{i});
        % add folder+mni to F
        F=[F;f];
    end
end



wbstep = 1/mxZ; % step once per plane
wb = waitbar(0,'Reading image planes...');



for plane=1:mxZ
    Pstack = zeros (mxX,mxY,nFiles);
    for imgFile = 1:nFiles
        % open file
        mnifilename = strcat(D{imgFile},'\',M{imgFile});
        mnifile = spm_vol(mnifilename);
        % read slice plane from file
        P = spm_slice_vol(mnifile,spm_matrix([0 0 plane]),mnifile.dim(1:2),0);
        % stack with others
        Pstack(:,:,plane) = P;
    end
    % average / sd / cov
    SliceMean = nanmean(Pstack,3);
    %size(SliceMean)
    % write to outfile
    outFileM = spm_write_plane(outFileM,SliceMean,plane);
    % update waitbar
    waitbar(plane*wbstep,wb);
end
close(wb)


% create outfile
% outfile = [];
