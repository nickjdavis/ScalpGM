function ScalpGM_TestGMSc (filelist)

T = readtable(filelist);
nfiles = size(T,1)

% cmap1 = colormap('gray');
% cmap2 = jet(size(cmap1,1));
% cmap = [cmap1;cmap2];
% colormap(cmap)


figure;

for i=1:nfiles
    t = T(i,:);
    %%%[p,n,e] = fileparts(t.imgfile{:});
    p = t.imgfolder{:};
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
    imagesc(X(:,:,100)); %colormap(gca,'gray'); freezeColors;
    nn = strrep(t.GM{:},'_','\_'); title(nn)
    subplot(1,2,2)
    imagesc(Y(:,:,100)); %colormap(gca,'jet'); freezeColors;
    nn = strrep(t.dist{:},'_','\_'); title(nn)
    waitforbuttonpress
end
