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
    SCvol = spm_vol(f);
    SCimg = spm_read_vols(SCvol);
    [x,y,z] = ind2sub(size(SCimg),find(SCimg>0.1)); %%%
    SC = [x,y,z];
    SCch = convhull (SC);
    plot3 (x,y,z,'k.'); 
    hold on;
    title (strrep(S{i},'_','-'))
    trimesh(SCch,SC(:,1),SC(:,2),SC(:,3))
    waitforbuttonpress; hold off
end

