% View convex hulls to check

function ScalpGM_ViewCH (filelist)


% Get data
T = readtable(filelist);
nFiles = size(T,1);
disp(strcat('Found  ',num2str(nFiles),' files.'))
F = {};
D = T.imgfolder;
I = T.imgfile;
S = T.scalp;
G = T.GM;
%M = T.MNI;
% for i=1:nFiles
%     % get folder
%     %[p,n,e]=fileparts(I{i});
%     p = D{i};
%     % get MNI file
%     f=strcat(p,'\',M{i});
%     % add folder+mni to F
%     F=[F;f];
% end


for i=1:nFiles
    f = strcat(D{i},'\',S{i});
    scalp_points = ScalpGM_getCH3d (f);
    plot3(scalp_points(:,1),scalp_points(:,2),scalp_points(:,3),'.')
    %trisurf([scalp_points; scalp_points(1,:)])
    %waitforbuttonpress
end

