% Given a list of files and a list of ROIs, computes mean depth

function DistbyROI = ScalpGM_MeanDepth (filelist,varargin)

%% Compile file list
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



%% Compile ROI list
% varargin should be in pairs, with one (possibly) specifying labels
% (labels can come later...)
disp('Setting up regions of interest...')
ROIarray = [];
nvars = length(varargin);
for i=1:2:nvars
    ROIfile = varargin{i};
    ROIvals = varargin{i+1};
    Atlas = spm_read_vols(spm_vol(ROIfile));
    for j=1:length(ROIvals)
        V = ismember(Atlas,ROIvals(j));
        ROI = [];
        ROI.label = 'xxx';
        ROI.file = ROIfile;
        ROI.vol = V;
        ROIarray = [ROIarray ROI];
    end
end
    
    

%% Get depth from ROIs
% Array for output
DistbyROI = zeros (nFiles,length(ROIarray));
disp('Processing image files...')
for i=1:nFiles
    mnifile = F{i};
    disp(mnifile)
    V = spm_vol(mnifile);
    IMGDATA = spm_read_vols(V);
    X = find(IMGDATA<0.05); IMGDATA(X)=NaN; %%%
    % Smooth data before adding to array
    sigma = 3; % width of gaussian (assume isotropic smoothing)
    sIMG = smooth3(IMGDATA,'gaussian',[sigma sigma sigma]);
    img = sIMG(2:end,2:end,2:end);
    img(isnan(img))=0;
    for j=1:length(ROIarray)
        R = ROIarray(j);
        Y = R.vol & img;
        D = mean(img(Y));
        DistbyROI(i,j) = D;
    end
end


%% Tidy and return
% space to use label info

