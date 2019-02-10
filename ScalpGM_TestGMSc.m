function ScalpGM_TestGMSc (filelist)

T = readtable(filelist);
nfiles = size(T,1)

figure;

for i=1:nfiles
    t = T(i,:);
    [p,n,e] = fileparts(t.imgfile{:});
    % open scalp file
    sc = ScalpGM_getCH3d (strcat(p,'\',t.scalp{:}));
    % open GM file
    gm = spm_vol(strcat(p,'\',t.GM{:}))
    % plot mesh over GM
%     plot3(sc(:,1),sc(:,2),sc(:,3),'.')
%     waitforbuttonpress
    X = gm.private.dat;
    image(X(:,:,100))
    waitforbuttonpress
end
