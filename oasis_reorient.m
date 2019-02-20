function oasis_reorient(imgs)
% oasis_reorient(imgs); % imgs is a character array
% oasis_reorient; % GUI selection

spm_defaults; % set analyze_flip=true here

if ~exist('imgs', 'var') || isempty(imgs)
    imgs = spm_select(inf, 'image');
end

for i = 1:size(imgs, 1)
    img = deblank(imgs(i, :));
    if regexp(img, 'mpr-\d')
        fprintf('reorienting raw original: %s\n', img);
        rot = [0 -pi/2 pi/2]; % (rotation gets applied first)
        trn = [-10200 8093 8064];
        tfm = spm_matrix([trn rot]);
    elseif regexp(img, 'sbj_111')
        fprintf('reorienting subject-average: %s\n', img);
        rot = [0 -pi/2 pi/2]; % (rotation gets applied first)
        trn = [-8142 8093 8064];
        tfm = spm_matrix([trn rot]);
    elseif regexp(img, '111_t88')
        fprintf('reorienting processed T88: %s\n', img);
        tfm = spm_matrix([-8136 8100 8151]); % translate only
    end
    origmat = spm_get_space(img);
    % modify image name to give filename for backup of voxel-world matrix
    % replace .img or .nii with _origvw and any frame number ,n with -n
    fnm = regexprep(img, '.(img|nii)', '_origvw');
    fnm = regexprep(fnm, ',(\d+)$', '-$1');
    save(fnm, 'origmat'); % .mat added automatically
    spm_get_space(img, tfm * origmat);
end
