function DistByArea = ScalpGM_Stats (statsimage)

%% new code

% nImages = length(imagelist)

%% Load atlas and image data
Atlas = spm_read_vols(spm_vol('rROI_MNI_V4.nii')); % resliced version
fid = fopen('ROI_MNI_V4.txt');
Labels = textscan(fid,'%s\t%s\t%d');
fclose (fid);
nLabels = length(Labels{1});
V = spm_vol(statsimage);
IMGDATA = spm_read_vols(V);


% Array for output
nFiles = 1;
DistByArea = zeros (nFiles,nLabels);
ROIsizes = zeros (nFiles,nLabels);

%% create ROIs
ROIs = {...
    [1 19 59],[2 20 60];... % sensorimotor
    [3 7 9 11 13 15],[4 8 10 12 14 16];... % PFC
    %[71],[72];... % caudate
    [49 51 53],[50 52 54];... % occipital
    [59 61 63 65],[60 61 64 66];... % parietal
    [81 83 85],[82 84 86];... % temporal
};
img = IMGDATA;
img(find(isnan(img)))=0;
s = size(ROIs);
ROIdata = cell(s);
ROImeans= zeros(s);
ROIstds = zeros(s);
for i=1:s(1)
    %
    for side=1:2
        m = ROIs{i,side};
        Mask = ismember(Atlas,Labels{3}(m));
        BrainInMask = Mask & img;
        B = img(find(BrainInMask));
        ROIdata{i,side} = B;
        ROImeans(i,side) = nanmean(B);
        ROIstds(i,side) = nanstd(B);
        %nvoxels(m) = length(find(~isnan(B)));
    end
end
% ROIdata
% ROImeans
% ROIstds

% 
% figure;
L = {'SM','PFC','OCC','PAR','TEM'};
% bar(ROImeans);
% title('Depth'); set(gca,'XTickLabels',L); legend('L','R');
figure;
barweb(ROImeans,ROIstds, [], L, 'BWtitle', 'XL', 'YL', [], [], 'Legend', 1, 'axis');%,[],'GN','BWtitle','XL','YL',[],[],'Legend')

%% extract info


%     size(IMGDATA)
%     isnan(IMGDATA)
%
for i=1:1
    img = IMGDATA;
         img(find(isnan(img)))=0;
    %     size(isnan(IMGDATA))
    meanDepths = zeros(nLabels,1);
    nvoxels = zeros(nLabels,1);
    for m=1:nLabels
        Mask = ismember(Atlas,Labels{3}(m));
        BrainInMask = Mask & img;
        B = img(find(BrainInMask));
        %B(find(B<5))=nan;
        meanDepths(m) = nanmean(B);
        nvoxels(m) = length(find(~isnan(B)));
    end
    DistByArea(i,:) = meanDepths;
    ROIsizes(i,:) = nvoxels;
end

%% get data    
Indices = [1 2; 45 46; 3 4; 81 82; 71 72; [1] [2]];
m = []; % todo - preallocate with zeros
s = [];
c = [];
mv= [];
sv= [];
for j=1:6
    m = [m; mean(DistByArea(:,Indices(j,1))) mean(DistByArea(:,Indices(j,2)))];
%     s = [s; std(DistByArea(:,Indices(j,1))) std(DistByArea(:,Indices(j,2)))];
%     c = [c; s(end,1)/m(end,1) s(end,2)/m(end,2)];
%     mv= [mv; mean(ROIsizes(:,Indices(j,1))) mean(ROIsizes(:,Indices(j,2)))];
%     sv= [sv; std(ROIsizes(:,Indices(j,1))) std(ROIsizes(:,Indices(j,2)))];
end
% 
% %% plot
figure;
Labels= {'Precentral','Cuneus','DLPFC','Sup temp','Caudate','combSM'};
bar(m); title('Depth'); set(gca,'XTickLabels',Labels); legend('L','R');%, s, [], Labels, 'Depth by area', 'Area', 'Mean/std Depth (mm)', 'gray', [], {'Left','Right'});%, error_sides, legend_type)
% figure
% bar(c); title('CoV');%, zeros(size(c)), [], Labels, 'CoV by area', 'Area', 'CoV', 'gray', [], {'Left','Right'});%, error_sides, legend_type)
% figure
% bar(mv); title('N voxels');%, sv, [], Labels, 'N voxels by area', 'Area', 'nVoxels', 'gray', [], {'Left','Right'});



%% old code below


%{




%% Read file information
% This is awful - Matlab won't allow you to create an empty table!
% Shamefully hacky...
T = array2table(cell(0,3));
T.Properties.VariableNames = {'imgfolder','imgfile','MNI'};
if iscell(filelist)
    nLists = length(filelist);
    for i=1:nLists
        t = readtable(filelist{i},'delimiter',',');
        tt = table(t.imgfolder,t.imgfile,t.MNI,'VariableNames',{'imgfolder','imgfile','MNI'});
        if isempty(T)
            T = tt;
        else
            T = union(T,tt);
        end
    end
else
    T = readtable(filelist,'delimiter',',');
end
T
nFiles = size(T,1);
F = {};
D = T.imgfolder;
%I = T.imgfile;
M = T.MNI;
for i=1:nFiles
    p = D{i};
    % get MNI file
    f=strcat(p,'\',M{i});
    % add folder+mni to F
    F=[F;f];
end


%% Load atlas
Atlas = spm_read_vols(spm_vol('rROI_MNI_V4.nii')); % resliced version
fid = fopen('ROI_MNI_V4.txt');
Labels = textscan(fid,'%s\t%s\t%d');
fclose (fid);
nLabels = length(Labels{1})


% Array for output
DistByArea = zeros (nFiles,nLabels);
ROIsizes = zeros (nFiles,nLabels);


%% Load files (and smooth?)
%mxX=182; mxY=218; mxZ=182;
disp('Adding image files...')
for i=1:nFiles
    mnifile = F{i};
    disp(mnifile)
    V = spm_vol(mnifile);
    IMGDATA = spm_read_vols(V);
    %X = find(IMGDATA<0.05); IMGDATA(X)=0; %%% was NaN
    %%size(find(isnan(IMGDATA)))
    % Smooth data before adding to array
%     sigma = 3; % width of gaussian (assume isotropic smoothing)
%     sIMG = smooth3(IMGDATA,'gaussian',[sigma sigma sigma]);
    %ImageArray(:,:,:,i) = smooth3(IMGDATA,'gaussian',[sigma sigma sigma]);
%     img = sIMG(2:end,2:end,2:end);
    img = IMGDATA;
    img(find(isnan(img)))=0;
    meanDepths = zeros(nLabels,1);
    nvoxels = zeros(nLabels,1);
    for m=1:nLabels
        Mask = ismember(Atlas,Labels{3}(m)); 
        BrainInMask = Mask & img; 
        B = img(find(BrainInMask));
        B(find(B<5))=nan;
        meanDepths(m) = nanmean(B);
        nvoxels(m) = length(find(~isnan(B)));
    end
    DistByArea(i,:) = meanDepths;
    ROIsizes(i,:) = nvoxels;
end



%% plot key depths
% Areas = [2001 2002; 7001 7002; 5011 5012; 2101 2102];
%Indices = [1 2; 71 72; 45 46; 3 4; 81 82]; % AAAUGGHH
Indices = [1 2; 45 46; 3 4; 81 82; 71 72];
m = []; % todo - preallocate with zeros
s = [];
c = [];
mv= [];
sv= [];
for i=1:5
    m = [m; mean(DistByArea(:,Indices(i,1))) mean(DistByArea(:,Indices(i,2)))];
    s = [s; std(DistByArea(:,Indices(i,1))) std(DistByArea(:,Indices(i,2)))];
    c = [c; s(end,1)/m(end,1) s(end,2)/m(end,2)];
    mv= [mv; mean(ROIsizes(:,Indices(i,1))) mean(ROIsizes(:,Indices(i,2)))];
    sv= [sv; std(ROIsizes(:,Indices(i,1))) std(ROIsizes(:,Indices(i,2)))];
end
Labels= {'Precentral','Cuneus','DLPFC','Sup temp','Caudate'};
% barweb(m, s, [], Labels, 'Depth by area', 'Area', 'Mean/std Depth (mm)', 'gray', [], {'Left','Right'});%, error_sides, legend_type)
% figure
% barweb(c, zeros(size(c)), [], Labels, 'CoV by area', 'Area', 'CoV', 'gray', [], {'Left','Right'});%, error_sides, legend_type)
% figure
% barweb(mv, sv, [], Labels, 'N voxels by area', 'Area', 'nVoxels', 'gray', [], {'Left','Right'});
bar(m); title('Depth');%, s, [], Labels, 'Depth by area', 'Area', 'Mean/std Depth (mm)', 'gray', [], {'Left','Right'});%, error_sides, legend_type)
figure
bar(c); title('CoV');%, zeros(size(c)), [], Labels, 'CoV by area', 'Area', 'CoV', 'gray', [], {'Left','Right'});%, error_sides, legend_type)
figure
bar(mv); title('N voxels');%, sv, [], Labels, 'N voxels by area', 'Area', 'nVoxels', 'gray', [], {'Left','Right'});

 
%% Correlations
M1ave = (DistByArea (:,1)+DistByArea (:,2))./2;
CDave = (DistByArea(:,71)+DistByArea(:,72))./2;
V1ave = (DistByArea(:,45)+DistByArea(:,46))./2;
PFave = (DistByArea (:,3)+DistByArea (:,4))./2;
STave = (DistByArea(:,81)+DistByArea(:,82))./2;
[RHO,PVAL] = corr([M1ave V1ave PFave STave CDave]);
L = {'M1','V1','PFC','STG','CDN'};
%tmpcorrtbl(RHO,PVAL,L); % TEMP - make prettier and incorporate
disp(L)
disp(RHO)
disp(PVAL)

%}

%% Shameful junk

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