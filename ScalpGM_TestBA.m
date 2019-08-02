function DistbyArea = ScalpGM_TestBA (filelist)


%% Read file information
% This is awful - Matlab won't allow you to create an empty table!
% Shamefully hacky...
T = array2table(cell(0,3));
T.Properties.VariableNames = {'imgfolder','imgfile','MNI'};
if iscell(filelist)
    nLists = length(filelist);
    for i=1:nLists
        t = readtable(filelist{i});
        tt = table(t.imgfolder,t.imgfile,t.MNI,'VariableNames',{'imgfolder','imgfile','MNI'});
        if isempty(T)
            T = tt;
        else
            T = union(T,tt);
        end
    end
else
    T = readtable(filelist);
end
nFiles = size(T,1);
F = {};
D = T.imgfolder;
I = T.imgfile;
M = T.MNI;
for i=1:nFiles
    p = D{i};
    % get MNI file
    f=strcat(p,'\',M{i});
    % add folder+mni to F
    F=[F;f];
end


%% Load atlas
% Need a more effcicient way to do this!
% Atlas = spm_read_vols(spm_vol('brodmann.nii'));
% BA1 = 4;  % primary motor cortex
% BA2 = 17; % primary visual cortex
% BA3 = 27; % piriform cortex
% BA4 = 46; % dlpfc
% % Extract Left M1, Left V1, Left PC
% % NB L hemi has x<92
% BAmask1 = ismember(Atlas,BA1); BAmask1(92:end,:,:)=false;
% BAmask2 = ismember(Atlas,BA2); BAmask2(92:end,:,:)=false;
% BAmask3 = ismember(Atlas,BA3); BAmask3(92:end,:,:)=false;
% BAmask4 = ismember(Atlas,BA4); BAmask4(92:end,:,:)=false;
% Atlas = spm_read_vols(spm_vol('rhandnew.nii'));
% H = 255; % left hand area mask
% BAmask5 = ismember(Atlas,H);


Atlas = spm_read_vols(spm_vol('rROI_MNI_V4.nii')); % resliced version
fid = fopen('ROI_MNI_V4.txt');
Labels = textscan(fid,'%s\t%s\t%d');
fclose (fid);
nLabels = length(Labels{1})


% Array for output
DistbyArea = zeros (nFiles,nLabels);


%% Load files and smooth
mxX=182; mxY=218; mxZ=182;
% mxX=91; mxY=109; mxZ=91;
% ImageArray = zeros (mxX,mxY,mxZ,nFiles);
disp('Adding image files...')
for i=1:nFiles
    mnifile = F{i};
    disp(mnifile)
    V = spm_vol(mnifile);
    IMGDATA = spm_read_vols(V);
    %mean(mean(mean(IMGDATA)))
    %X = find(IMGDATA<0.05); IMGDATA(X)=0; %%% was NaN
    %%size(find(isnan(IMGDATA)))
    % Smooth data before adding to array
%     sigma = 3; % width of gaussian (assume isotropic smoothing)
%     sIMG = smooth3(IMGDATA,'gaussian',[sigma sigma sigma]);
    %ImageArray(:,:,:,i) = smooth3(IMGDATA,'gaussian',[sigma sigma sigma]);
%     img = sIMG(2:end,2:end,2:end);
    img = IMGDATA;
    %mean(mean(mean(img)))
    %size(isnan(img))
    img(find(isnan(img)))=0;
    %mean(mean(mean(img)))
    meanDepths = zeros(nLabels,1);
    for m=1:nLabels
        %l = Labels{3}(m)
        Mask = ismember(Atlas,Labels{3}(m));
        %size(Mask)
        BrainInMask = Mask & img;
        %disp(length(find(BrainInMask)))
        meanDepths(m) = mean(img(BrainInMask))
    end
    DistByArea(i,:) = meanDepths;
end

%
% %% Get mean dist for each BA
%
%
% for i=1:nFiles
% img = ImageArray(:,:,:,i); %spm_read_vols(spm_vol(imgfile));
% img = img(2:end,2:end,2:end);
% img(isnan(img))=0;
% BAinIMG1 = BAmask1 & img;
% BAinIMG2 = BAmask2 & img;
% DistbyBA(:,i) = [mean(img(BAinIMG1)) mean(img(BAinIMG2))];
% end
% % size(BAinIMG1)
% %M = [mean(img(BAmask1)) mean(img(BAmask2))];
%
%


%{


% BA1 = 2001; % code of Precentral_L in AAL
% %BA = 2; % code of Left_M1 in HMAT
% BA2 = 3001; % Insula_L in AAL
BA1 = 4; % code of Precentral_L in AAL
% BA2 = 13; % Insula_L in AAL
BA2 = 17; % visual cortex

% load atlas
Atlas = spm_read_vols(spm_vol('brodmann.nii'));
% Atlas = spm_read_vols(spm_vol('aal.nii'));
% Atlas = spm_read_vols(spm_vol('hmat.nii'));
% size(Atlas)
% Extract Left M1, Left V1
% NB L hemi has x<92
BAmask1 = ismember(Atlas,BA1); BAmask1(92:end,:,:)=false;
BAmask2 = ismember(Atlas,BA2); BAmask2(92:end,:,:)=false;


% load mean image
img = spm_read_vols(spm_vol(imgfile));
img = img(2:end,2:end,2:end);

img(isnan(img))=0;
BAinIMG1 = BAmask1 & img;
BAinIMG2 = BAmask2 & img;

% size(BAinIMG1)
M = [mean(img(BAmask1)) mean(img(BAmask2))];

%}