function ScalpGM_NewMean (filelist,outFileName)


% These are standard sizes of MNI image in SPM
% HACKY!!!
mxX=182; mxY=218; mxZ=182;
ImageArray = zeros (mxX,mxY,mxZ);%;,nFiles);


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



wbstep = 100/mxZ; % step once per plane
wb = waitbar(0,'Reading image planes...');

for plane=1:mxZ
    pause(0.01)
    waitbar(plane*wbstep,wb);
end
close(wb)


% create outfile
outfile = [];
