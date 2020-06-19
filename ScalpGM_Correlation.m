% ScalpGM_Correlation
%
% Computes the correlation across images of the whole brain with a
% specific point
% 
% filelist: table of files for processing
% ROIinfo : [x y z r] is MNI coord of point, plus radius
%

function outdata = ScalpGM_Correlation (filelist,ROIinfo,id)

if nargin<3
    id = '';
end


%% Load mean image to get dims and to create new
% NB - this is a cheat to (effectively) get the brain mask - need to fix!
Mfile = '\\staffhome\staff_home0\55121576\Documents\MATLAB\ScalpGM\ALLPOSTFIX_M.nii';
V = spm_vol(Mfile);
MEANIMG = spm_read_vols(V);
% TODO - create new
% CORRIMG = spm_read_vols(V);
ROI = int_MNI2Index(ROIinfo(1:3),V.mat);
Vlist = int_getVoxelCoords( ROI,ROIinfo(4),MEANIMG );


%% Get data
% assume filelist is a table
T = readtable(filelist,'Delimiter','comma'); 
nFiles = size(T,1);
fprintf('Found %d files.\n',nFiles)
F = {};
D = T.imgfolder;
% I = T.imgfile;
M = T.MNI;
for i=1:nFiles
    p = D{i};
    % get MNI file
    f=strcat(p,'\',M{i});
    % add folder+mni to F
    F=[F;f];
end


CORRIMG = nan(size(MEANIMG));
NIMG = nan(size(MEANIMG));
PIMG = nan(size(MEANIMG));

%% Get depth of specified region
Depths = zeros(nFiles,1);
for i=1:nFiles
    vol = spm_vol(F{i});
    IMGDATA = spm_read_vols(vol);
    % mask out non-brain
    IMGDATA(IMGDATA<5)=NaN;
    d = [];
    for j=1:size(Vlist,1)
        x = Vlist(j,1);
        y = Vlist(j,2);
        z = Vlist(j,3);
        %id = IMGDATA(x,y,z);
        d = [d; IMGDATA(x,y,z)];
        NIMG(x,y,z) = 100;
    end
    Depths(i) = nanmean(d);
end

% size(find(NIMG>10))


%% Get each file, and build correlation map
mxX = size(CORRIMG,1);
mxY = size(CORRIMG,2);
mxZ = size(CORRIMG,3);
nplanes = mxZ;
wbstep = 1/nplanes; % step once per plane
wb = waitbar(0,'Reading image planes...');

for plane=1:nplanes
    Pstack = zeros (mxX,mxY,nFiles);
    % collect a stack of slices
    for imgFile = 1:nFiles
        mnifilename = F{imgFile};
        mnifile = spm_vol(mnifilename);
        P = spm_slice_vol(mnifile,spm_matrix([0 0 plane]),mnifile.dim(1:2),0);
        %X = find(P<10); P(X)=NaN; %%%
        Pstack(:,:,imgFile) = P;
    end
    % for each non-nan point, correlate stack with Depths
    % TODO: use corrcoef? handle nans better
    for y=1:mxY
        for x=1:mxX
            if ~isnan(MEANIMG(x,y,plane))
                PointDepths = squeeze(Pstack(x,y,:));
                I = find(~isnan(PointDepths));
                [c,pval] = corr(PointDepths(I),Depths(I));
                CORRIMG(x,y,plane) = c;
                PIMG(x,y,plane) = pval;
                NIMG(x,y,plane) = max([NIMG(x,y,plane) length(I)]);
            else
                %NIMG(x,y,plane) = 0;
            end
        end
    end
    waitbar(plane*wbstep,wb);
end
close(wb)

%% write output images
outVr = V;
outVp = V;
outVn = V;
if isempty(id)
    outVr.fname = sprintf('ScalpGM [%d %d %d] corr r.nii',...
        ROIinfo(1),ROIinfo(2),ROIinfo(3));
    outVp.fname = sprintf('ScalpGM [%d %d %d] corr p.nii',...
        ROIinfo(1),ROIinfo(2),ROIinfo(3));
    outVn.fname = sprintf('ScalpGM [%d %d %d] corr n.nii',...
        ROIinfo(1),ROIinfo(2),ROIinfo(3));
else
    outVr.fname = sprintf('ScalpGM %s [%d %d %d] corr r.nii',...
        id,ROIinfo(1),ROIinfo(2),ROIinfo(3));
    outVp.fname = sprintf('ScalpGM %s [%d %d %d] corr p.nii',...
        id,ROIinfo(1),ROIinfo(2),ROIinfo(3));
    outVn.fname = sprintf('ScalpGM %s [%d %d %d] corr n.nii',...
        id,ROIinfo(1),ROIinfo(2),ROIinfo(3));
end
spm_write_vol(outVr,CORRIMG);
spm_write_vol(outVp,PIMG);
spm_write_vol(outVn,NIMG);


if nargout==1
    outdata = Depths;
end





%% Internal functions
function newCoords = int_MNI2Index (MNIcoords,affmat)
x = MNIcoords(1)-affmat(1,4);
y = MNIcoords(2)-affmat(2,4);
z = MNIcoords(3)-affmat(3,4);
newCoords = [x y z];

function Vlist = int_getVoxelCoords (c,r,img)
% UGLY!!! Try sphere...
Vlist = [];
S = size(img);
for z=1:S(3)
    for y=1:S(2)
        for x=1:S(1)
            d = sqrt( (c(1)-x)^2 + (c(2)-y)^2 + (c(3)-z)^2 );
            if d<=r
                Vlist = [Vlist; x y z];
            end
        end
    end
end
% this does a cube...
% d = 2*r+1;
% for z=(c(3)-r):(c(3)+r)
%     for y=(c(2)-r):(c(2)+r)
%         for x=(c(1)-r):(c(1)+r)
%             Vlist = [Vlist; x y z];
%         end
%     end
% end