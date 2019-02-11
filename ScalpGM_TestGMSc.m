function ScalpGM_TestGMSc (filelist)

T = readtable(filelist);
nfiles = size(T,1)

figure;

for i=1:nfiles
    t = T(i,:);
    [p,n,e] = fileparts(t.imgfile{:});
    % open scalp file
    %sc = ScalpGM_getCH3d (strcat(p,'\',t.scalp{:}));
    % open GM file
    gm = spm_vol(strcat(p,'\',t.GM{:}));
    di = spm_vol(strcat(p,'\',t.dist{:}));
    % plot mesh over GM
%     plot3(sc(:,1),sc(:,2),sc(:,3),'.')
%     waitforbuttonpress
    X = gm.private.dat;
    Y = di.private.dat;
    subplot(1,2,1)
    imagesc(X(:,:,100)); colormap(gca,'gray');
    nn = strrep(t.GM{:},'_','\_'); title(nn)
    subplot(1,2,2)
    imagesc(Y(:,:,100)); colormap(gca,'jet');
    nn = strrep(t.dist{:},'_','\_'); title(nn)
    waitforbuttonpress
end
