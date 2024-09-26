function ScalpGM_PrepareOASIS (folder)
% Preprocessing steps for the OASIS-1 dataset
% 1. [...]

% Is the subject folder, or folder of folders?
d = dir(folder)
for i=1:length(d)
    if d(i).isdir
        % check if is an OAS dir
    end
end

% STEP 1. Locate folder with T1
