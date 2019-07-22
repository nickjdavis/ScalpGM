function ScalpGM_DepthCorr (filelist, ROIfile, outFileName)

mxX=182; mxY=218; mxZ=182;


% Get data
T = readtable(filelist);
nFiles = size(T,1);
disp(strcat('Found  ',num2str(nFiles),' files.'))
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

% Open ROIfile
ROIs = spm_read_vols(spm_vol(ROIfile));

% Create outfile
corrV = [];
corrV.dim = [mxX mxY mxZ];
% v.mat = [1 0 0 1; 0 1 0 1; 0 0 1 1; 0 0 0 1];
corrV.mat = [1 0 0 -90; 0 1 0 -125; 0 0 1 -71; 0 0 0 1];
corrV.pinfo = [1; 0; 0];
corrV.dt = [16 0]; % float32
corrV.fname = strrep(outFileName,'.nii','_r.nii');
outFileV = spm_create_vol(corrV);



%% Get M1 depth
disp ('Calculating depth of target region...')
M1all = zeros(nFiles,1);

wbstep = 1/nFiles; % step once per plane
wb = waitbar(0,'(1) Estimating target depth...');

%V = ismember(ROIfile,1);
V = ismember(ROIs,1); % 1 for M1
ROI = [];
ROI.label = 'xxx';
ROI.file = ROIfile;
ROI.vol = V;
%ROIarray = [ROIarray ROI];


for i=1:nFiles
    mnifile = F{i};
    %Sdisp(mnifile)
    V = spm_vol(mnifile);
    IMGDATA = spm_read_vols(V);
    X = find(IMGDATA<0.05); IMGDATA(X)=NaN; %%%
    % Smooth data before adding to array
    sigma = 3; % width of gaussian (assume isotropic smoothing)
    sIMG = smooth3(IMGDATA,'gaussian',[sigma sigma sigma]);
    img = sIMG(2:end,2:end,2:end);
    img(isnan(img))=0;
    % size(img)
    % size(ROI.vol)
    Y = ROI.vol & img;
    Dpth = mean(img(Y));
    M1all(i) = Dpth;
    waitbar(i*wbstep,wb);
end
close(wb)
% mean(M1all)
% hist(M1all)

%% Correlate all depths with M1 depth
disp ('Correlating whole brain with target area...')
wbstep = 1/mxZ; % step once per plane
wb = waitbar(0,'(2) Reading image planes...');

for plane=1:mxZ
    Pstack = zeros (mxX,mxY,nFiles);
    for imgFile = 1:nFiles
        % open file
        d = D{imgFile};
        m = M{imgFile};
        %disp(m)
        %mnifilename = strcat(D{imgFile},'\',M{imgFile});
        mnifilename = strcat(d,'\',m);
        mnifile = spm_vol(mnifilename);

        % read slice plane from file
        P = spm_slice_vol(mnifile,spm_matrix([0 0 plane]),mnifile.dim(1:2),0);
% stack with others, setting values less than 0.05 to NaN
        %X = find(P<0.05); P(X)=NaN; %%%
        % TRY SMOOTHING...
        %k = [.05 .05 .05; .05 .6 .05; .05 .05 .05];
        k = .125*ones(3);
        P = conv2(P,k,'same');% find(P<0.05); P(X)=NaN; %%%
        %size(P)
        Pstack(:,:,imgFile) = P;
    end
    % DO CORR HERE
    sliceCorr = zeros(mxX,mxY);
    for x=1:mxX
        %         for y=1:mxY
        %             %size(M1all)
        %             z = Pstack(x,y,:);
        %             %size(reshape(z,size(z,3),1))
        %             [r,p] = corr(M1all,reshape(z,size(z,3),1));
        %             % SAVE r INTO PLANE
        %             sliceCorr(x,y) = r;
        %         end
        z = Pstack(x,:,:);
        z = squeeze(z);
        %size(z)
        %size(M1all)
        [r,p] = corr(M1all,z');
        sliceCorr(x,:)=r;
    end
    % write to outfile
    outFileV  = spm_write_plane(outFileV,sliceCorr,plane);
    % update waitbar
    waitbar(plane*wbstep,wb);
end
close(wb)

%% Write output file