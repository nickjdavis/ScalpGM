function ScalpGM_GetSubjectData (subjectInfo,ScalpGMinfo)


% load subjectInfo (comes with OASIS)
infotable = readtable(subjectInfo,'text','Delimiter',',');

% load ScalpGMinfo (from previous processing steps)
    T = readtable(ScalpGMinfo);
    nFiles = size(T,1);


% for each file in T, locate info in infotable
for i=1:nFiles
    % parse filename
    % find line matching subject number (some may be in twice)
    % get [sex age eTIV nWBV]
    % add info to table
end
% save table back into original file