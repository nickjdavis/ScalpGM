function ScalpGM_NewMean (filelist,outFileName)


% These are standard sizes of MNI image in SPM
% HACKY!!!
mxX=182; mxY=218; mxZ=182;
ImageArray = zeros (mxX,mxY,mxZ);%;,nFiles);

v = [];
v.dim = [mxX mxY mxZ];
% v.mat = [1 0 0 1; 0 1 0 1; 0 0 1 1; 0 0 0 1];
v.mat = [1 0 0 -90; 0 1 0 -125; 0 0 1 -71; 0 0 0 1];
v.pinfo = [1; 0; 0];
v.dt = [16 0]; % float32
v.fname = strrep(outFileName,'.nii','_M.nii');
outFileM = spm_create_vol(v);
v.fname = strrep(outFileName,'.nii','_SD.nii');
outFileSD = spm_create_vol(v);
v.fname = strrep(outFileName,'.nii','_CoV.nii');
outFileCoV = spm_create_vol(v);

% read fileslist
if iscell(filelist)
    % this is what we expect
    F = filelist;
    nFiles = length(F);
    disp(strcat('Found  ',num2str(nFiles),' files.'))
else
    % assume table file
    T = readtable(filelist);
    nFiles = size(T,1);
    disp(strcat('Found ',num2str(nFiles),' files.'))
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
        % stack with others, setting values less than 0.05 to NaN
        X = find(P<0.05); P(X)=NaN; %%%
        Pstack(:,:,imgFile) = P;
    end
    % average / sd / cov
    SliceMean = nanmean(Pstack,3);
    SliceSD = nanstd(Pstack,[],3);
    SliceCoV= SliceSD./SliceMean;
    %size(SliceMean)
    % write to outfile
    outFileM  = spm_write_plane(outFileM,SliceMean,plane);
    outFileSD = spm_write_plane(outFileSD,SliceSD,plane);
    outFileCoV= spm_write_plane(outFileCoV,SliceCoV,plane);
    % update waitbar
    waitbar(plane*wbstep,wb);
end
close(wb)


